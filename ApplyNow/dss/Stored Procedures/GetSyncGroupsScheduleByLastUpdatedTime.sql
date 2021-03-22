CREATE PROCEDURE [dss].[GetSyncGroupsScheduleByLastUpdatedTime]
    @LastUpdatedTime DATETIME
AS
BEGIN
    SELECT
        [id],
        [sync_interval],
        [sync_enabled],
        [lastupdatetime]
    FROM [dss].[syncgroup]
    WHERE [lastupdatetime] >= @LastUpdatedTime
END