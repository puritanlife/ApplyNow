
-- Create ResetMessageById SP.

CREATE PROCEDURE [TaskHosting].[ResetMessageById]
  @MessageId uniqueidentifier
AS
BEGIN
    IF @MessageId IS NULL
    BEGIN
      RAISERROR('@MessageId argument is wrong.', 16, 1)
      RETURN
    END

    SET NOCOUNT ON
    UPDATE TaskHosting.MessageQueue
    SET [InsertTimeUTC] = GETUTCDATE(),
        [UpdateTimeUTC] = NULL,
        [ExecTimes] = 0,
        [WorkerId] = NULL,
        [ResetTimes] = [ResetTimes] + 1
    WHERE [MessageId] = @MessageId
END