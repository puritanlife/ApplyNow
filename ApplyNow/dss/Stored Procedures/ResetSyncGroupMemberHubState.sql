CREATE PROCEDURE [dss].[ResetSyncGroupMemberHubState]
    @SyncGroupMemberID	UNIQUEIDENTIFIER,
    @MemberHubState		INT,
    @ConditionalMemberHubState INT
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dss].[syncgroupmember]
    SET
        [hubstate] = @MemberHubState,
        [hubstate_lastupdated] = GETUTCDATE()
    WHERE [id] = @SyncGroupMemberID AND [hubstate] = @ConditionalMemberHubState

    SELECT @@ROWCOUNT
END