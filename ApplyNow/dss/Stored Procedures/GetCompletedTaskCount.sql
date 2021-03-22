CREATE PROCEDURE [dss].[GetCompletedTaskCount]
    @durationInSeconds INT
AS
BEGIN
    SELECT COUNT(*) AS [TaskCount], [task].[type] AS [TaskType]
    FROM [dss].[task]
    WHERE
        [task].[state] = 1 -- state:1:Succeed
        AND DATEDIFF(SECOND, [task].[completedtime], GETUTCDATE()) < @durationInSeconds
    GROUP BY [task].[type]
END