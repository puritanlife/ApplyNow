CREATE PROCEDURE [dss].[SetDatabaseState]
    @DatabaseID	UNIQUEIDENTIFIER,
    @DatabaseState int,
    @JobId      UNIQUEIDENTIFIER
AS
BEGIN
    -- Change the database state
    UPDATE [dss].[userdatabase]
    SET
        [state] = @DatabaseState,
        [jobId] = @JobId
    WHERE [id] = @DatabaseID
END