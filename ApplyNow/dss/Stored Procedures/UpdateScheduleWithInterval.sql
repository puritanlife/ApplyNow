CREATE PROCEDURE [dss].[UpdateScheduleWithInterval]
    @SyncGroupId UNIQUEIDENTIFIER,
    @Interval bigint
AS
BEGIN
    UPDATE [dss].[ScheduleTask]
    SET
        Interval = @Interval,
        [ExpirationTime] = DATEADD(SECOND, @Interval, GETUTCDATE()) -- Also update the due time for the task when the interval is updated.
    WHERE [SyncGroupId] = @SyncGroupId
END