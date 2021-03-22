CREATE FUNCTION [dss].[CheckSyncGroupMemberLimit]
(
    @SubscriptionId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    -- check the number of sync group members across all syncgroups for a server

    DECLARE @SyncGroupMemberCount INT
    DECLARE @SyncGroupMemberLimit INT = (SELECT [MaxValue] FROM [dss].[scaleunitlimits] WHERE [Name] = 'SyncGroupMemberCountPerServer')

    SET @SyncGroupMemberCount = (
            SELECT COUNT(sgm.[id]) FROM [dss].[syncgroup] sg JOIN [dss].[syncgroupmember] sgm
            ON sgm.[syncgroupid] = sg.[id]
            WHERE sg.[subscriptionid] = @SubscriptionId)

    IF (@SyncGroupMemberCount >= @SyncGroupMemberLimit)
    BEGIN
        RETURN 1
    END

    RETURN 0
END