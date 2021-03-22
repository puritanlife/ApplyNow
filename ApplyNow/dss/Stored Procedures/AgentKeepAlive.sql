CREATE PROCEDURE [dss].[AgentKeepAlive]
    @AgentId UNIQUEIDENTIFIER,
    @AgentInstanceId UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @LastAliveTime DATETIME = GETUTCDATE()

    UPDATE [dss].[agent_instance]
    SET
        [lastalivetime] = @LastAliveTime
    WHERE [id] = @AgentInstanceId AND [agentid] = @AgentId

    -- For local agents also update the agent table.
    UPDATE [dss].[agent]
    SET
        [lastalivetime] = @LastAliveTime
    WHERE [id] = @AgentId AND [is_on_premise] = 1

END