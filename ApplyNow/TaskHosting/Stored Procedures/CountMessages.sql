
CREATE PROCEDURE [TaskHosting].[CountMessages]
AS
BEGIN
SELECT COUNT([MessageId]) FROM TaskHosting.MessageQueue
END