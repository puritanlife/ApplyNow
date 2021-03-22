CREATE PROCEDURE [dss].[GetSubscriptionById]
    @subscriptionid uniqueidentifier
AS
    SELECT
        sub.[id],
        sub.[name],
        sub.[creationtime],
        sub.[lastlogintime],
        sub.[tombstoneretentionperiodindays],
        sub.[policyid],
        sub.[WindowsAzureSubscriptionId],
        sub.[EnableDetailedProviderTracing],
        sub.[syncserveruniquename],
        sub.[version]
    from [dss].[subscription] sub where sub.id = @subscriptionid
RETURN 0