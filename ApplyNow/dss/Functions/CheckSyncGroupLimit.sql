CREATE FUNCTION [dss].[CheckSyncGroupLimit]
(
    @SubscriptionId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    -- check the number of syncgroups per server

    DECLARE @SyncGroupCount INT
    DECLARE @SyncGroupLimit INT = (SELECT [MaxValue] FROM [dss].[scaleunitlimits] WHERE [Name] = 'SyncGroupCountPerServer')

    SET @SyncGroupCount = (SELECT COUNT([id]) FROM [dss].[syncgroup] WHERE [subscriptionid] = @SubscriptionId)

    IF (@SyncGroupCount >= @SyncGroupLimit)
    BEGIN
        RETURN 1
    END

    RETURN 0
END