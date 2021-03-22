
-- Cancel Job SP
CREATE PROCEDURE [TaskHosting].[CancelJob]
  @JobId     uniqueidentifier
AS
BEGIN
    IF @JobId IS NULL
    BEGIN
      RAISERROR('@JobId argument is wrong.', 16, 1)
      RETURN
    END

    SET NOCOUNT ON
    UPDATE TaskHosting.Job SET IsCancelled = 1 WHERE JobId = @JobId
END