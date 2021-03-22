CREATE PROCEDURE [dss].[GetNextScheduleTaskCount]
AS
BEGIN

    SELECT COUNT(sch.Id)
    FROM [dss].[ScheduleTask] sch
    JOIN [dss].[syncgroup] grp ON sch.SyncGroupId = grp.id
    JOIN [dss].[subscription] sub ON grp.subscriptionid = sub.id
    WHERE
    (sch.State = 0 OR
     (DATEDIFF(SECOND,[ExpirationTime],GETUTCDATE()) > 0 AND sch.State != 1) OR	-- Pick tasks that are due and not pending
     (DATEDIFF(SECOND,DATEADD(MINUTE,5,[LastUpdate]),GETUTCDATE()) > 0 AND sch.State = 1)	 --pick rows that was not updated even after 5min...suggesting a worker role crash
     )
    AND Interval > 0
    AND sub.subscriptionstate = 0

END