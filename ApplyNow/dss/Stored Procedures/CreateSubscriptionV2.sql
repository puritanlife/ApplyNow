﻿CREATE PROCEDURE [dss].[CreateSubscriptionV2]
    @Name [dss].[DISPLAY_NAME],
    @TombstoneRetentionInDays int,
    @WindowsAzureSubscriptionId	UNIQUEIDENTIFIER,
    @DssServerId	UNIQUEIDENTIFIER,
    @SyncServerUniqueName nvarchar(256) = NULL,
    @Version [dss].[VERSION] = NULL
AS
BEGIN

    BEGIN TRY
        INSERT INTO [dss].[subscription]
        (
            [id],
            [name],
            [creationtime],
            [lastlogintime],
            [policyid],
            [tombstoneretentionperiodindays],
            [WindowsAzureSubscriptionId],
            [syncserveruniquename],
            [version]
        )
        VALUES
        (
            @DssServerId,
            @Name,
            GETUTCDATE(),
            NULL,
            0, -- 0:v1
            @TombstoneRetentionInDays,
            @WindowsAzureSubscriptionId,
            @SyncServerUniqueName,
            @Version
        )

        SELECT @DssServerId AS [SubscriptionId]
    END TRY
    BEGIN CATCH
        IF(ERROR_NUMBER() = 2627) -- Primary Key Violation
            BEGIN
                RAISERROR('DUPLICATE_SYNC_SERVER_ID', 15, 1)
            END
        ELSE IF(ERROR_NUMBER() = 2601) -- Unique Index Violation
            BEGIN
                RAISERROR('DUPLICATE_SYNC_SERVER_UNIQUE_NAME', 15, 1)
            END
        ELSE
            BEGIN
                -- get error infromation and raise error
                EXECUTE [dss].[RethrowError]
            END
    RETURN
    END CATCH
END