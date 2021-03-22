CREATE PROCEDURE [dss].[SetDatabaseRegion]
    @DatabaseID	UNIQUEIDENTIFIER,
    @Region nvarchar(256)
AS
BEGIN
    UPDATE [dss].[userdatabase]
    SET
        [region] = @Region
    WHERE [id] = @DatabaseID
END