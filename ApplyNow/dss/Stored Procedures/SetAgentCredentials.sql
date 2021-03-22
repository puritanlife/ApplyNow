CREATE PROCEDURE [dss].[SetAgentCredentials]
    @AgentID	UNIQUEIDENTIFIER,
    @PasswordHash	[dss].[PASSWORD_HASH],
    @PasswordSalt	[dss].[PASSWORD_SALT]
AS
BEGIN
    UPDATE [dss].[agent]
    SET
        [password_hash] = @PasswordHash,
        [password_salt] = @PasswordSalt
    WHERE [id] = @AgentID
END