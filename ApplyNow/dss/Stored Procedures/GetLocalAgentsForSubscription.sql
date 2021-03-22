CREATE PROCEDURE [dss].[GetLocalAgentsForSubscription]
    @SubscriptionId UNIQUEIDENTIFIER
AS
BEGIN
    -- Q: Active/Inactive?
    SELECT
        a.[id],
        a.[name],
        a.[subscriptionid],
        a.[state],
        a.[lastalivetime],
        a.[is_on_premise],
        a.[version],
        a.[password_hash],
        a.[password_salt]
    FROM [dss].[agent] a
    WHERE a.[subscriptionid] = @SubscriptionId AND a.[is_on_premise] = 1

END