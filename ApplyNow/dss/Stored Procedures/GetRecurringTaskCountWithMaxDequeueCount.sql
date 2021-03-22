CREATE PROCEDURE [dss].[GetRecurringTaskCountWithMaxDequeueCount]
AS
BEGIN
    SELECT COUNT([Id]) AS [TaskCount]
    FROM [dss].[ScheduleTask]
    WHERE [DequeueCount] >= 254
END