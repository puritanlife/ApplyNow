CREATE PROCEDURE [dss].[UpdateSyncGroupMemberState]
    @SyncGroupMemberID	UNIQUEIDENTIFIER    ,
    @MemberState		INT,
    @DownloadChangesFailed	INT = NULL,
    @UploadChangesFailed INT = NULL,
    @JobId             UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON

    IF (@MemberState <> 5) -- 5: SyncSucceeded.
    BEGIN
        UPDATE [dss].[syncgroupmember]
        SET
            [memberstate] = @MemberState,
            [memberstate_lastupdated] = GETUTCDATE(),
            [jobId] = @JobId
        WHERE [id] = @SyncGroupMemberID
    END
    ELSE -- If SyncSucceeded then update [lastsynctime]
    BEGIN
        UPDATE [dss].[syncgroupmember]
        SET
            [memberstate] = @MemberState,
            [memberstate_lastupdated] = GETUTCDATE(),
            [JobId] = @JobId,
            [lastsynctime] = GETUTCDATE()
        WHERE [id] = @SyncGroupMemberID
    END

    IF (@MemberState IN (5, 12)) -- 5: SyncSucceeded. 12: SyncSucceededWithWarnings
    BEGIN
        UPDATE [dss].[syncgroupmember]
        SET
            [lastsynctime_zerofailures_member] = CASE WHEN @DownloadChangesFailed = 0 THEN GETUTCDATE() ELSE [lastsynctime_zerofailures_member] END,
            [lastsynctime_zerofailures_hub] = CASE WHEN @UploadChangesFailed = 0 THEN GETUTCDATE() ELSE [lastsynctime_zerofailures_hub] END
        WHERE [id] = @SyncGroupMemberID
    END
END