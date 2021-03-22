CREATE PROCEDURE [dss].[UpdateSyncGroupMemberHubState]
    @SyncGroupMemberID	UNIQUEIDENTIFIER,
    @HubState			INT,
    @JobId             UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dss].[syncgroupmember]
    SET
        [hubstate] = @HubState,
        [hubstate_lastupdated] = GETUTCDATE(),
        [hubJobId] = @JobId
    WHERE [id] = @SyncGroupMemberID

END