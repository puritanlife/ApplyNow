
CREATE PROCEDURE [TaskHosting].[UpdateScheduleTaskMessageInfoV2]
    @ScheduleTaskId UNIQUEIDENTIFIER,
    @MessageId UNIQUEIDENTIFIER,
    @JobId UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON

    IF NOT EXISTS (
        SELECT * FROM [TaskHosting].ScheduleTask
        WHERE ScheduleTaskId = @ScheduleTaskId)
    BEGIN
      RAISERROR('@ScheduleTaskId argument is wrong.', 16, 1)
      RETURN
    END

    UPDATE [TaskHosting].ScheduleTask
    SET MessageId = @MessageId,
        JobId = @JobId,
        NextRunTime = TaskHosting.GetNextRunTime(Schedule)
    WHERE ScheduleTaskId = @ScheduleTaskId