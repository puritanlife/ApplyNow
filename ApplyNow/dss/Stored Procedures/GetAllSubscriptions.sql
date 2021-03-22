CREATE PROCEDURE [dss].[GetAllSubscriptions]
AS
BEGIN
    SELECT
        [id],
        [name],
        [creationtime],
        [WindowsAzureSubscriptionId]
    FROM [dss].[subscription]
END