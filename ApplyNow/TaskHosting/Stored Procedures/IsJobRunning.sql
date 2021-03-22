
-- Detect whether the job is running by checking the messages

CREATE PROCEDURE [TaskHosting].[IsJobRunning]
    @JobId UNIQUEIDENTIFIER
AS
    IF @JobId IS NULL
    BEGIN
        RAISERROR('@JobId argument is wrong.', 16, 1)
        RETURN
    END

    SET NOCOUNT ON

    IF EXISTS
        (SELECT *
        FROM [TaskHosting].[MessageQueue]
        WHERE JobId = @JobId
        )
        SELECT 1
    ELSE
        SELECT 0

RETURN 0