CREATE FUNCTION [dss].[IsAgentInstanceValid]
(
    @AgentId			UNIQUEIDENTIFIER,
    @AgentInstanceId	UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [dss].[agent_instance] WHERE [id] = @AgentInstanceId AND [agentid] = @AgentId)
    BEGIN
        RETURN 1
    END

    RETURN 0
END