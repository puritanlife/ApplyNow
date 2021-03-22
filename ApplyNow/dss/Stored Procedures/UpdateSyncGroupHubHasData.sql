CREATE PROCEDURE [dss].[UpdateSyncGroupHubHasData]
    @syncGroupId uniqueidentifier,
    @hasData bit
AS
BEGIN
    UPDATE [dss].[syncgroup]
    SET
        [hubhasdata] = @hasData
    WHERE [id] = @syncGroupId
END