
CREATE PROCEDURE [TaskHosting].[AddMessageIdToScheduleTask]
    @ScheduleTaskId UNIQUEIDENTIFIER,
    @MessageId UNIQUEIDENTIFIER
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
    SET MessageId = @MessageId
    WHERE ScheduleTaskId = @ScheduleTaskId