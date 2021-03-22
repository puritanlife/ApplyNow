
CREATE PROCEDURE [TaskHosting].[UpdateScheduleTaskJobInfo]
    @ScheduleTaskId UNIQUEIDENTIFIER,
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
    SET JobId = @JobId
    WHERE ScheduleTaskId = @ScheduleTaskId