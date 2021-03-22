CREATE PROCEDURE [dss].[ResetSyncGroupMemberState]
    @SyncGroupMemberID	UNIQUEIDENTIFIER,
    @MemberState		INT,
    @ConditionalMemberState INT
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dss].[syncgroupmember]
    SET
        [memberstate] = @MemberState,
        [memberstate_lastupdated] = GETUTCDATE()
    WHERE [id] = @SyncGroupMemberID AND [memberstate] = @ConditionalMemberState

    SELECT @@ROWCOUNT
END