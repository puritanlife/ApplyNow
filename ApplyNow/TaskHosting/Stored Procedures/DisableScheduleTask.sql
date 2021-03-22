
CREATE PROCEDURE [TaskHosting].[DisableScheduleTask]
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
    SET State = 0
    WHERE ScheduleTaskId = @ScheduleTaskId