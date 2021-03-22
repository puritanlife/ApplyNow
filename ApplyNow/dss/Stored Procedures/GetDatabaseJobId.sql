CREATE PROCEDURE [dss].[GetDatabaseJobId]
    @DatabaseId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT [jobId] FROM [dss].[userdatabase]
    WHERE [id] = @DatabaseId
    RETURN 0
END