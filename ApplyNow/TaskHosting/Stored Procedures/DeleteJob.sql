
-- Create DeleteJob SP.

CREATE PROCEDURE [TaskHosting].[DeleteJob]
  @JobId     uniqueidentifier
AS
BEGIN
    IF @JobId IS NULL
    BEGIN
      RAISERROR('@JobId argument is wrong.', 16, 1)
      RETURN
    END

    SET NOCOUNT ON
    DELETE TaskHosting.Job WHERE JobId = @JobId
END