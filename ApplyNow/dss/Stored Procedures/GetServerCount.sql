CREATE PROCEDURE [dss].[GetServerCount]
AS
BEGIN
    SELECT COUNT(id) FROM [dss].[subscription]
END