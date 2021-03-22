CREATE PROCEDURE [dss].[DeleteSchedule]
    @SyncGroupId UNIQUEIDENTIFIER = NULL
AS
BEGIN
BEGIN TRY
    DELETE
    FROM [dss].[ScheduleTask]
    WHERE [SyncGroupId] = @SyncGroupId

END TRY
BEGIN CATCH
         -- get error infromation and raise error
            EXECUTE [dss].[RethrowError]
        RETURN

END CATCH

END