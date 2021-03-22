CREATE PROCEDURE [dss].[GetSubscriptionByUniqueName]
    @SyncServerUniqueName nvarchar(256)
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
    from [dss].[subscription] sub where sub.syncserveruniquename = @SyncServerUniqueName
RETURN 0