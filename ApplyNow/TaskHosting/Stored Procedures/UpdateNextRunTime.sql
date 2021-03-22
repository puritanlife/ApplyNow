
-- create stored procedure to get the next the due schedule tasks.

CREATE PROCEDURE [TaskHosting].[UpdateNextRunTime]
@ScheduleTaskId UNIQUEIDENTIFIER
AS
BEGIN -- stored procedure
    SET NOCOUNT ON

    -- update next run time
    UPDATE TaskHosting.ScheduleTask WITH (UPDLOCK, READPAST)
    SET NextRunTime = TaskHosting.GetNextRunTime(Schedule)
    WHERE State = 1	-- enabled task.
     AND ScheduleTaskId = @ScheduleTaskId
END  -- stored procedure