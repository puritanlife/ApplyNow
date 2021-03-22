-- Validate whether a agent instance is valid.
-- Return 0 if agent instance is valid.
-- Return 1 if a agent id is invalid.
-- Return 2 if a agent id is valid but the agent instance id is invalid.
CREATE PROCEDURE [dss].[ValidateAgentInstance]
    @AgentId			UNIQUEIDENTIFIER,
    @AgentInstanceId	UNIQUEIDENTIFIER
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dss].[agent] WHERE [id] = @AgentId)
    BEGIN
        SELECT 1
        RETURN
    END

    IF EXISTS (SELECT 1 FROM [dss].[agent_instance] WHERE [id] = @AgentInstanceId AND [agentid] = @AgentId)
    BEGIN
        SELECT 0
        RETURN
    END

    SELECT 2
END