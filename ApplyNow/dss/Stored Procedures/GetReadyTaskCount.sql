CREATE PROCEDURE [dss].[GetReadyTaskCount]
AS
BEGIN
    SELECT COUNT(*) AS [TaskCount], [task].[type] AS [TaskType]
    FROM [dss].[task]
    WHERE
        [task].[state] = 0                                             -- state:0:Ready
        AND [task].[agentid] = '28391644-B7E4-4F5A-B8AF-543966779059'  -- Cloud Tasks only
    GROUP BY [task].[type]
END