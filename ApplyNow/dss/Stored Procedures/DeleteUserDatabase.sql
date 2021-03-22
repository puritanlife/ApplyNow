CREATE PROCEDURE [dss].[DeleteUserDatabase]
    @AgentId UNIQUEIDENTIFIER,
    @DatabaseID	UNIQUEIDENTIFIER
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dss].[userdatabase] WHERE [id] = @DatabaseID AND [agentid] = @AgentId)
    BEGIN
        RAISERROR('INVALID_DATABASE', 15, 1)
        RETURN
    END

    BEGIN TRY
        BEGIN TRANSACTION

        -- Remove database from all sync groups
        DELETE FROM [dss].[syncgroupmember]
        WHERE [databaseid] = @DatabaseID

        DELETE [dss].[userdatabase]
        WHERE [id] = @DatabaseID

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