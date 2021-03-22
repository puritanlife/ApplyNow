
CREATE PROCEDURE [TaskHosting].[GetPendingMessageCount]
AS
    SELECT [MessageType], COUNT(*) as [MessageCount] FROM [TaskHosting].[MessageQueue] WITH (NOLOCK) WHERE UpdateTimeUTC IS NULL
    GROUP BY [MessageType]
    RETURN 0