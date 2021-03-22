
-- create stored procedure to get the next the due schedule tasks.

CREATE PROCEDURE [TaskHosting].[UpdateAllTaskNextRunTime]
AS
BEGIN -- stored procedure
    SET NOCOUNT ON

    -- update next run time
    UPDATE TaskHosting.ScheduleTask WITH (UPDLOCK, READPAST)
    SET NextRunTime = TaskHosting.GetNextRunTime(Schedule), JobId='00000000-0000-0000-0000-000000000000'
    WHERE State = 1	-- enabled task.
END  -- stored procedure