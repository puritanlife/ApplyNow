CREATE PROCEDURE [dss].[GetAgentById]
    @AgentId	UNIQUEIDENTIFIER
AS
BEGIN
    SELECT
        [id],
        [name],
        [subscriptionid],
        [state],
        [lastalivetime],
        [is_on_premise],
        [version],
        [password_hash],
        [password_salt]
    FROM [dss].[agent]
    WHERE [id] = @AgentId
END