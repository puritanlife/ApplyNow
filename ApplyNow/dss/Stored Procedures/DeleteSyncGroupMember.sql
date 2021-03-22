CREATE PROCEDURE [dss].[DeleteSyncGroupMember]
    @SyncGroupMemberID	UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        DECLARE @DatabaseId UNIQUEIDENTIFIER

        SELECT @DatabaseId = [databaseid]
        FROM [dss].[syncgroupmember]
        WHERE [id] = @SyncGroupMemberID

        BEGIN TRANSACTION

        DELETE FROM [dss].[syncgroupmember]
        WHERE [id] = @SyncGroupMemberID

        EXEC [dss].[CheckAndDeleteUnusedDatabase] @DatabaseId

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