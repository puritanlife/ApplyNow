
-- Create InsertJob SP.

CREATE PROCEDURE [TaskHosting].[InsertJob]
  @JobId     uniqueidentifier,
  @JobType int,
  @TracingId uniqueidentifier
AS
BEGIN
    IF @JobId IS NULL
    BEGIN
      RAISERROR('@JobId argument is wrong.', 16, 1)
      RETURN
    END

    SET NOCOUNT ON
    INSERT TaskHosting.Job([JobId], [JobType], [TracingId])
    VALUES (@JobId, @JobType, @TracingId)
END