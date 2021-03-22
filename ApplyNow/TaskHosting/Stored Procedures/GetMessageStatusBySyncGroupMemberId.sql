
CREATE PROCEDURE [Taskhosting].[GetMessageStatusBySyncGroupMemberId]
    @SyncGroupMemberId UNIQUEIDENTIFIER,
    @StartTime DATETIME,
    @MaxExecTimes TINYINT,
    @TimeoutInSeconds INT,
    @HasMessage BIT OUTPUT,
    @HasRunningMessage BIT OUTPUT
AS
BEGIN
    IF @SyncGroupMemberId IS NULL
    BEGIN
        RAISERROR('@SyncGroupMemberId argument is wrong', 16, 1)
        RETURN
    END

    SET NOCOUNT ON

    SELECT
        @HasMessage = COUNT(*),
        @HasRunningMessage =
            COUNT
            (
                CASE WHEN
                -- Execute Times less than max, or execute times equal to max but it is still running, then return 1.
                    (ExecTimes < @MaxExecTimes) OR (ExecTimes = @MaxExecTimes AND UpdateTimeUTC >= DATEADD(SECOND, -@TimeoutInSeconds, GETUTCDATE()))
                THEN 1
                END
            )
    FROM TaskHosting.MessageQueue
    WHERE
        InsertTimeUTC >= @StartTime
        AND MessageData LIKE '%' + CONVERT(VARCHAR(50), @SyncGroupMemberId) + '%'

END