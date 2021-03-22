
-- Create InsertMessage SP.

CREATE PROCEDURE [TaskHosting].[InsertMessage]
  @MessageId	uniqueidentifier,
  @JobId		uniqueidentifier,
  @MessageType	int,
  @MessageData	nvarchar(max),
  @QueueId		uniqueidentifier,
  @TracingId	uniqueidentifier,
  @Version		bigint = 0
AS
BEGIN
    IF @MessageId IS NULL
    BEGIN
      RAISERROR('@MessageId argument is wrong.', 16, 1)
      RETURN
    END

    IF @JobId IS NULL
    BEGIN
      RAISERROR('@JobId argument is wrong.', 16, 1)
      RETURN
    END

    SET NOCOUNT ON
    INSERT TaskHosting.MessageQueue ([MessageId], [JobId], [MessageType], [MessageData], [QueueId], [TracingId], [InitialInsertTimeUTC], [InsertTimeUTC], [Version])
    VALUES (@MessageId, @JobId, @MessageType, @MessageData, @QueueId, @TracingId, GETUTCDATE(), GETUTCDATE(), @Version)
END