CREATE PROCEDURE [dss].[GetSyncGroupsForSubscription]
    @SubscriptionId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON

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
        [hubhasdata]
    FROM [dss].[syncgroup]
    WHERE [subscriptionid] = @SubscriptionId
END