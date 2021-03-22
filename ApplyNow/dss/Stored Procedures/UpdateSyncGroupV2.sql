﻿CREATE PROCEDURE [dss].[UpdateSyncGroupV2]
    @SyncGroupId	UNIQUEIDENTIFIER,
    @SyncInterval	INT,
    @Name	[dss].[DISPLAY_NAME],
    @SchemaDescription XML = null,
    @OCSSchemaDefinition NVARCHAR(MAX) = null,
    @Version dss.VERSION = null,
    @ConflictLoggingEnabled bit = 0,
    @ConflictTableRetentionInDays int = 30
AS
BEGIN
    IF (([dss].[IsSyncGroupActiveOrNotReady] (@SyncGroupId)) = 0)
    BEGIN
        RAISERROR('SYNCGROUP_DOES_NOT_EXIST_OR_NOT_ACTIVE', 15, 1);
        RETURN
    END

    BEGIN TRY
        BEGIN TRANSACTION

        DECLARE @oldState int

        UPDATE [dss].[syncgroup]
        SET
            [name] = @Name,
            [sync_interval] = @SyncInterval,
            [lastupdatetime] = GETUTCDATE(),
            [schema_description] = COALESCE(@SchemaDescription, [schema_description]),
            [ocsschemadefinition] = COALESCE(@OCSSchemaDefinition, [ocsschemadefinition]),
            [ConflictLoggingEnabled] = COALESCE(@ConflictLoggingEnabled, [ConflictLoggingEnabled], 0),
            [ConflictTableRetentionInDays] = COALESCE(@ConflictTableRetentionInDays, [ConflictTableRetentionInDays], 30),
            @oldState = [state]  -- retrieve the original state
        WHERE [id] = @SyncGroupId

        IF (@oldState = 3) -- 3: sync group is not ready
        BEGIN
            IF ((@SchemaDescription IS NOT NULL) AND (@OCSSchemaDefinition IS NOT NULL))
            BEGIN
                UPDATE [dss].[syncgroup]
                SET	[state] = 0
                WHERE [id] = @SyncGroupId

                IF (@Version is NULL)
                    EXECUTE [dss].CreateSchedule @SyncGroupID,@SyncInterval,0 --0== Recurring Sync Task for DSS
                ELSE
                    EXECUTE [dss].CreateSchedule @SyncGroupID,@SyncInterval,2 --2== Recurring Sync Task for ADMS
            END
        END
        ELSE
            EXECUTE [dss].UpdateScheduleWithInterval @SyncGroupId, @SyncInterval

        IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        IF(ERROR_NUMBER() = 2627) -- Constraint Violation
            BEGIN
                RAISERROR('DUPLICATE_SYNC_GROUP_NAME', 15, 1)
            END
        ELSE
            BEGIN
                -- get error infromation and raise error
                EXECUTE [dss].[RethrowError]
            END
        RETURN
    END CATCH
END