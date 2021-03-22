-- Create the Insertion SP
-- Make sure this file is in ANSI format
CREATE PROCEDURE [dss].[CleanupUIHistoryRecord]
        @CompletionTime	DateTime
AS
BEGIN

    DECLARE @RowsAffected BIGINT
    DECLARE @DeleteBatchSize BIGINT
    SET @DeleteBatchSize = 1000  --Set the batch size to 1000 so that everytime, we will delete 1000 rows together.

    SET @RowsAffected = @DeleteBatchSize

    WHILE (@RowsAffected = @DeleteBatchSize)
    BEGIN
        DELETE TOP(@DeleteBatchSize) FROM [dss].[UIHistory] WHERE [completionTime] < @CompletionTime
        SET @RowsAffected = @@ROWCOUNT
    END
END