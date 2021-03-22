CREATE PROCEDURE [dss].[CreateActionAndTasksV2]
    @ActionId UNIQUEIDENTIFIER,
    @SyncGroupId UNIQUEIDENTIFIER = NULL,
    @Type INT,
    @TaskList [dss].[TaskTableTypeV2] READONLY,
    @TaskDependencyList [dss].[TaskDependencyTableType] READONLY
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        INSERT INTO [dss].[action]
        (
            [id],
            [syncgroupid],
            [type],
            [state],
            [creationtime],
            [lastupdatetime]
        )
        VALUES
        (
            @ActionId,
            @SyncGroupId,
            @Type,
            0, -- 0: ready
            GETUTCDATE(),
            GETUTCDATE()
        )

        -- Insert tasks
        INSERT INTO [dss].[task]
        (
            [id],
            [actionid],
            [agentid],
            [request],
            [state],
            [dependency_count],
            [priority],
            [type],
            [version]
        )
        SELECT
            [id],
            [actionid],
            [agentid],
            [request],
            0, -- 0: ready
            [dependency_count],
            [priority],
            [type],
            [version]
        FROM @TaskList

        -- Insert task dependencies
        INSERT INTO [dss].[taskdependency]
        (
            [nexttaskid],
            [prevtaskid]
        )
        SELECT
            [nexttaskid],
            [prevtaskid]
        FROM @TaskDependencyList

        IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

         -- get error infromation and raise error
        EXECUTE [dss].[RethrowError]
        RETURN
    END CATCH
END