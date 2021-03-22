
-- Currently, this sproc is created as place holder for test purpose.

CREATE PROCEDURE [TaskHosting].[GetJobByMessageId]
    @MessageId uniqueidentifier
AS
BEGIN
  IF @MessageId IS NULL
  BEGIN
     RAISERROR('@MessageId argument is wrong.', 16, 1)
     RETURN
  END

  SET NOCOUNT ON
  SELECT JobId FROM TaskHosting.MessageQueue
      WHERE MessageId = @MessageId

RETURN 0
END