CREATE PROCEDURE [dss].[GetAgentCredentials]
    @AgentID	UNIQUEIDENTIFIER
AS
BEGIN

    SELECT
        [id],
        [password_hash],
        [password_salt]
    FROM [dss].[agent]
    WHERE [id] = @AgentID

END