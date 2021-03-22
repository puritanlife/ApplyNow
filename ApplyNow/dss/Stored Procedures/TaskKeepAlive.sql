CREATE PROCEDURE [dss].[TaskKeepAlive]
    @TaskId	UNIQUEIDENTIFIER
AS
BEGIN

    DECLARE @State INT
    SELECT @State = 0
    SET NOCOUNT ON

    UPDATE [dss].[task]
    SET [lastheartbeat] = GETUTCDATE(),
        @State = [state]
    WHERE [id] = @TaskId

    -- check if the task is cancelling
    IF (@State <> -4) -- -4: cancelling
        SELECT 1
    ELSE
        SELECT 0

END