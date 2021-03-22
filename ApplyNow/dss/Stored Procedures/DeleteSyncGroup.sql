CREATE PROCEDURE [dss].[DeleteSyncGroup]
    @SyncGroupID UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        DECLARE @SyncGroupMemberDatabaseIdList TABLE ([databaseid] UNIQUEIDENTIFIER PRIMARY KEY NOT NULL)
        DECLARE @DatabaseId UNIQUEIDENTIFIER
        DECLARE @IsOnPremise BIT

        BEGIN TRANSACTION

        DELETE FROM [dss].[ScheduleTask]
        WHERE [SyncGroupId] = @SyncGroupID

        -- Get the list of database Ids for the syncgroup
        INSERT INTO @SyncGroupMemberDatabaseIdList ([databaseid])
        (SELECT [databaseid] FROM [dss].[syncgroupmember] WHERE [syncgroupid] = @SyncGroupID
         UNION
         SELECT [hub_memberid] FROM [dss].[syncgroup] WHERE [id] = @SyncGroupID)

        -- Remove all syncgroup members
        DELETE FROM [dss].[syncgroupmember]
        WHERE [syncgroupid] = @SyncGroupID

        -- Mark database as unregistering.
        DELETE FROM [dss].[syncgroup]
        WHERE [id] = @SyncGroupID

        WHILE EXISTS(SELECT 1 FROM @SyncGroupMemberDatabaseIdList)
        BEGIN
            SET @DatabaseId = (SELECT TOP 1 [databaseid] FROM @SyncGroupMemberDatabaseIdList)

            EXEC [dss].[CheckAndDeleteUnusedDatabase] @DatabaseId

            DELETE FROM @SyncGroupMemberDatabaseIdList WHERE [databaseid] = @DatabaseId
        END

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

         -- get error infromation and raise error
        EXECUTE [dss].[RethrowError]
        RETURN
    END CATCH

END