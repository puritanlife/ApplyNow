CREATE FUNCTION [dss].[CheckOnPremiseSyncGroupMemberLimit]
(
    @SyncGroupId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    -- check number of on-premise databases for a syncgroup.

    DECLARE @OnPremiseDbSyncGroupMemberCount INT
    DECLARE @OnPremiseDbSyncGroupMemberLimit INT = (SELECT [MaxValue] FROM [dss].[scaleunitlimits] WHERE [Name] = 'OnPremiseMemberCountPerSyncGroup')

    -- exclude the hub since it cannot be an on-premise database.
    SET @OnPremiseDbSyncGroupMemberCount = (
            SELECT COUNT(sgm.[id]) FROM [dss].[syncgroupmember] sgm JOIN [dss].[userdatabase] ud
            ON sgm.[databaseid] = ud.[id]
            WHERE sgm.[syncgroupid] = @SyncGroupId AND ud.[is_on_premise] = 1)

    IF (@OnPremiseDbSyncGroupMemberCount >= @OnPremiseDbSyncGroupMemberLimit)
    BEGIN
        RETURN 1
    END

    RETURN 0
END