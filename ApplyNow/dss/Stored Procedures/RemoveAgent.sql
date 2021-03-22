CREATE PROCEDURE [dss].[RemoveAgent]
    @AgentID	UNIQUEIDENTIFIER
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- Remove Agent Instances
        DELETE FROM [dss].[agent_instance]
        WHERE [agentid] = @AgentID

        -- Remove agent
        DELETE FROM [dss].[agent]
        WHERE [id] = @AgentID

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

        IF (ERROR_NUMBER() = 547) -- FK/constraint violation
        BEGIN
            -- some dependant tables are not cleaned up yet.
            RAISERROR('AGENT_DELETE_CONSTRAINT_VIOLATION',15, 1)
        END
        ELSE
        BEGIN
             -- get error infromation and raise error
            EXECUTE [dss].[RethrowError]
        END

        RETURN

    END CATCH

END