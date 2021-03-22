CREATE PROCEDURE [dss].[GetRegisteredDatabasesForSubscription]
    @SubscriptionID UNIQUEIDENTIFIER
AS
BEGIN
    SELECT
        [id],
        [server],
        [database],
        [state],
        [subscriptionid],
        [agentid],
        [connection_string],
        [db_schema] = null,
        [is_on_premise],
        [sqlazure_info],
        [last_schema_updated],
        [last_tombstonecleanup],
        [region],
        [jobId]
    FROM [dss].[userdatabase]
    WHERE [subscriptionid] = @SubscriptionID
END