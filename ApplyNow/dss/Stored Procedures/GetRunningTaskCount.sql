CREATE PROCEDURE [dss].[GetRunningTaskCount]
AS
BEGIN
    SELECT COUNT(*) AS [TaskCount], [type] AS [TaskType]
    FROM [dss].[task]
    WHERE [state] = -1 OR [state] = -4 -- state:-1:processing; -4: cancelling
    GROUP BY [type]
END