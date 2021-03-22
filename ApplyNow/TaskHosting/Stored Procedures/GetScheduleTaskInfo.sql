
-- create stored procedure [TaskHosting].[GetScheduleTaskInfo]

CREATE PROCEDURE [TaskHosting].GetScheduleTaskInfo
    @MessageId uniqueidentifier
AS
BEGIN -- stored procedure
    SET NOCOUNT ON

    SELECT * FROM [TaskHosting].[ScheduleTask]
    WHERE MessageId = @MessageId
END  -- stored procedure