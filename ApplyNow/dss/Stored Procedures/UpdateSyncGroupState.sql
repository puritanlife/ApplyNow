CREATE PROCEDURE [dss].[UpdateSyncGroupState]
    @SyncGroupId UNIQUEIDENTIFIER,
    @State		 INT
AS
BEGIN
    UPDATE [dss].[syncgroup]
    SET
        [state] = @State
    WHERE [id] = @SyncGroupId
END