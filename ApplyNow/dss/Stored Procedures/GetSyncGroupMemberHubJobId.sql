CREATE PROCEDURE [dss].[GetSyncGroupMemberHubJobId]
    @SyncGroupMemberId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT [hubJobId] FROM [dss].[syncgroupmember]
    WHERE [id] = @SyncGroupMemberId
    RETURN 0
END