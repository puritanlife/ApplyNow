﻿CREATE PROCEDURE [dss].[RegisterAgentInstance]
    @AgentInstanceId UNIQUEIDENTIFIER,
    @AgentId UNIQUEIDENTIFIER,
    @Version dss.VERSION
AS
BEGIN
    DECLARE @AgentOnPremise BIT

    SET @AgentOnPremise = (SELECT [is_on_premise] FROM [dss].[agent] WHERE [id] = @AgentId)

    BEGIN TRY
        BEGIN TRANSACTION

        -- we only want one instance of a local agent to run at any time.
        IF (@AgentOnPremise = 1) -- 1: on premise agent
        BEGIN
            -- Delete all previous instances of the agent.
            DELETE FROM [dss].[agent_instance] WHERE [agentid] = @AgentId
        END

        INSERT INTO [dss].[agent_instance]
        (
            [id],
            [agentid],
            [version]
        )
        VALUES
        (
            @AgentInstanceId,
            @AgentId,
            @Version
        )

        UPDATE [dss].[agent]
        SET
            [version] = @Version
        WHERE [id] = @AgentId

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