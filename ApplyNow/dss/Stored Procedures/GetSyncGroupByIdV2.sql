CREATE PROCEDURE [dss].[GetSyncGroupByIdV2]
    @SyncGroupId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT
    [id],
    [name],
    [subscriptionid],
    [schema_description],
    [state],
    [hub_memberid],
    [conflict_resolution_policy],
    [sync_interval],
    [lastupdatetime],
    [ocsschemadefinition],
    [hubhasdata],
    [ConflictLoggingEnabled],
    [ConflictTableRetentionInDays]
    FROM [dss].[syncgroup]
    WHERE [id] = @SyncGroupId
END