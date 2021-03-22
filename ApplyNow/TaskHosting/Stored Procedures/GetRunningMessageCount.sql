
CREATE PROCEDURE [TaskHosting].[GetRunningMessageCount]
AS
    SELECT [MessageType], COUNT(*) as [MessageCount] FROM [TaskHosting].[MessageQueue] WITH (NOLOCK)
    WHERE UpdateTimeUTC IS NOT NULL AND ExecTimes < 3
    GROUP BY [MessageType]
    RETURN 0