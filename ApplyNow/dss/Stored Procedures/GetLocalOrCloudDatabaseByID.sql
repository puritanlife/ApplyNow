CREATE PROCEDURE [dss].[GetLocalOrCloudDatabaseByID]
    @DatabaseId UNIQUEIDENTIFIER,
    @IsOnPremise bit
AS
BEGIN
    SELECT
        [id],
        [server],
        [database],
        [state],
        [subscriptionid],
        [agentid],
        [connection_string] = null,
        [db_schema],
        [is_on_premise],
        [sqlazure_info],
        [last_schema_updated],
        [last_tombstonecleanup],
        [region],
        [jobId]
    FROM [dss].[userdatabase]
    WHERE [id] = @DatabaseId and [is_on_premise] = @IsOnPremise
END