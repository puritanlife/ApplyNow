﻿CREATE PROCEDURE [dss].[GetNextScheduleTaskV2]
    @NoOfTasks int
AS
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    DECLARE @jobs TABLE
    ( Id uniqueidentifier,
      State tinyint
    )

    INSERT into @jobs
    SELECT TOP(@NoOfTasks)
        sch.Id, sch.State
    FROM [dss].[ScheduleTask] sch WITH (UPDLOCK, READPAST)
    JOIN [dss].[syncgroup] grp ON sch.SyncGroupId = grp.id
    JOIN [dss].[subscription] sub ON grp.subscriptionid = sub.id
    WHERE
    (sch.State = 0 OR
     (DATEDIFF(SECOND,[ExpirationTime],GETUTCDATE()) > 0 AND sch.State != 1) OR	-- Pick tasks that are due and not pending
     (DATEDIFF(SECOND,DATEADD(MINUTE,5,[LastUpdate]),GETUTCDATE()) > 0 AND sch.State = 1)	 --pick rows that was not updated even after 5min...suggesting a worker role crash
     )
    AND Interval > 0
    AND sub.subscriptionstate = 0 AND sch.Type > 0

    IF (@@ROWCOUNT > 0)
    BEGIN

        UPDATE ST
        SET
        ST.[State] = 1, -- pending
        ST.[LastUpdate] = GETUTCDATE(),
        ST.[PopReceipt] = NEWID(),
        ST.[DequeueCount] =
                CASE
                    WHEN ST.[DequeueCount] < 254 -- This is a tinyint, so make sure we don't overflow
                        THEN ST.[DequeueCount] + 1
                    ELSE
                        ST.[DequeueCount]
                    END
        FROM [dss].[ScheduleTask] AS ST
        JOIN @jobs AS jbs
        ON ST.[Id] = jbs.Id
    END

    SELECT
        ST.Id As Id,
        ST.SyncGroupId as SyncGroupId,
        ST.PopReceipt as PopReceipt,
        ST.Type as TaskType
    FROM [dss].[ScheduleTask] AS ST
    JOIN @jobs as jbs
    ON ST.[Id] = jbs.Id

    RETURN
END