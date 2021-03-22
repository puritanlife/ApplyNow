CREATE PROCEDURE [dss].[GetConcurrentSyncTaskCount]
AS
BEGIN
    SELECT COUNT(*) AS 'SyncTaskCount'
    FROM [dss].[task]
    WHERE [type] = 2 AND [state] = -1 -- type:2:sync
END