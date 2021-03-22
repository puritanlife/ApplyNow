﻿CREATE PROCEDURE [dss].[CleanupCompletedTasks]
AS
BEGIN
    DECLARE @ActionsToDelete TABLE ([id] UNIQUEIDENTIFIER PRIMARY KEY NOT NULL)

    INSERT INTO @ActionsToDelete ([id])
    SELECT [id] FROM [dss].[action] WHERE [state] = 1 -- 1:Succeeded

    -- Cleanup tasks and actions that have been completed successfully.
    -- An action can be in [state]=1 only when all tasks are in [state]=1

    DECLARE @RowsAffected BIGINT
    DECLARE @DeleteBatchSize BIGINT
    SET @DeleteBatchSize = 1000

    SET @RowsAffected = @DeleteBatchSize

    WHILE (@RowsAffected = @DeleteBatchSize)
    BEGIN
        DELETE TOP (@DeleteBatchSize) [dss].[task]
        FROM [dss].[task] WITH (FORCESEEK) WHERE [actionid] IN (SELECT [id] FROM @ActionsToDelete)
        SET @RowsAffected = @@ROWCOUNT
    END

    SET @RowsAffected = @DeleteBatchSize

    WHILE (@RowsAffected = @DeleteBatchSize)
    BEGIN
        DELETE TOP (@DeleteBatchSize) [dss].[action]
        FROM [dss].[action] WITH (FORCESEEK) WHERE [id] IN (SELECT [id] FROM @ActionsToDelete)
        SET @RowsAffected = @@ROWCOUNT
    END

END