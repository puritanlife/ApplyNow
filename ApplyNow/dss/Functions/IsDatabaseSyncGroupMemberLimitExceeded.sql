CREATE FUNCTION [dss].[IsDatabaseSyncGroupMemberLimitExceeded]
(
    @DatabaseID UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    -- check the number of sync group memberships for a database in a server.

    DECLARE @DatabaseGroupMembershipCount INT
    DECLARE @DatabaseGroupMembershipLimit INT

    SET @DatabaseGroupMembershipLimit = (SELECT [MaxValue] FROM [dss].[scaleunitlimits] WHERE [Name] = 'DbSyncGroupMemberCountPerServer')

    -- get the # of members
    SET @DatabaseGroupMembershipCount = (SELECT COUNT([id]) FROM [dss].[syncgroupmember] WHERE [databaseid] = @DatabaseID)
                                        -- also include the hub
                                        + (SELECT COUNT([id]) FROM [dss].[syncgroup] WHERE [hub_memberid] = @DatabaseID)

    IF (@DatabaseGroupMembershipCount >= @DatabaseGroupMembershipLimit)
    BEGIN
        RETURN 1
    END

    RETURN 0
END