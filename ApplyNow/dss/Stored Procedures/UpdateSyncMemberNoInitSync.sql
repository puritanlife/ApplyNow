CREATE PROCEDURE [dss].[UpdateSyncMemberNoInitSync]
    @syncMemberId uniqueidentifier,
    @noInitSync bit
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dss].[syncgroupmember]
    SET
        [noinitsync] = @noInitSync
    WHERE [id] = @syncMemberId

END