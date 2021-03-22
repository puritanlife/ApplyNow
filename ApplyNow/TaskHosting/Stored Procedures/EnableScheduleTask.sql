
CREATE PROCEDURE [TaskHosting].[EnableScheduleTask]
    @ScheduleTaskId UNIQUEIDENTIFIER
AS
    SET NOCOUNT ON

    DECLARE @State INT
    IF NOT EXISTS (
        SELECT * FROM [TaskHosting].ScheduleTask
        WHERE ScheduleTaskId = @ScheduleTaskId)
    BEGIN
      RAISERROR('@ScheduleTaskId argument is wrong.', 16, 1)
      RETURN
    END


    UPDATE [TaskHosting].ScheduleTask
    SET State = 1, NextRunTime = TaskHosting.GetNextRunTime(Schedule)
    WHERE ScheduleTaskId = @ScheduleTaskId AND
        State = 0	-- only enabled the task in disabled state, otherwise, keep the current state.