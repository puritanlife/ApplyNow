
CREATE PROCEDURE [TaskHosting].[GetMessageById]
    @MessageId uniqueidentifier
AS
BEGIN
  IF @MessageId IS NULL
  BEGIN
     RAISERROR('@MessageId argument is wrong.', 16, 1)
     RETURN
  END

  SET NOCOUNT ON

  SELECT JobId, TracingId, InsertTimeUTC, InitialInsertTimeUTC, UpdateTimeUTC, [Version]
  FROM TaskHosting.MessageQueue
  WHERE MessageId = @MessageId

END