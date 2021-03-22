CREATE PROCEDURE [dss].[GetFailedTaskCount]
    @durationInSeconds INT
AS
BEGIN
    SELECT COUNT(*) AS [TaskCount], [task].[type] AS [TaskType]
    FROM [dss].[task]
    WHERE
        [task].[state] = 2 -- state:2:Failed
        AND [task].[completedtime] > DATEADD(SECOND, -@durationInSeconds, GETUTCDATE())
    GROUP BY [task].[type]
END