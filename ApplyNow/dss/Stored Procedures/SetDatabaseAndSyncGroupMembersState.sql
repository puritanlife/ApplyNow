CREATE PROCEDURE [dss].[SetDatabaseAndSyncGroupMembersState]
    @DatabaseId UNIQUEIDENTIFIER,
    @MemberState INT,
    @DatabaseState INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        UPDATE [dss].[syncgroupmember]
        SET
            [memberstate] = @MemberState,
            [memberstate_lastupdated] = GETUTCDATE(),
            [jobId] = NULL
        WHERE [databaseid] = @DatabaseId

        UPDATE [dss].[userdatabase]
        SET
            [state] = @DatabaseState,
            [jobId] = NULL
        WHERE [id] = @DatabaseId

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