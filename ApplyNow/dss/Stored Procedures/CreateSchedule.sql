CREATE PROCEDURE [dss].[CreateSchedule]
    @SyncGroupId UNIQUEIDENTIFIER,
    @Interval bigInt,
    @Type int
AS
BEGIN TRY
        INSERT INTO [dss].[ScheduleTask]
        (
            SyncGroupId,
            Interval,
            LastUpdate,
            ExpirationTime,
            State,
            Type
        )
        VALUES
        (
        @SyncGroupId,
            @Interval,
            GETUTCDATE(),
            DATEADD(SECOND, @Interval,GETUTCDATE()),
            0,
            @Type
        )

END TRY
BEGIN CATCH
         -- get error infromation and raise error
        --EXECUTE [dss].[RethrowError]
        RETURN
END CATCH