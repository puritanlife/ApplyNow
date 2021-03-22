CREATE PROCEDURE [dss].[SetUserDatabaseTombstoneCleanupTime]
    @DatabaseId UNIQUEIDENTIFIER,
    @LastTombstoneCleanup datetime
AS
    UPDATE [dss].[userdatabase]
    SET
        [last_tombstonecleanup] = @LastTombstoneCleanup
    WHERE [id] = @DatabaseId

    RETURN @@ROWCOUNT