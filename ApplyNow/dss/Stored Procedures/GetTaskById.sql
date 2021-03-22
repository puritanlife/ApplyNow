CREATE PROCEDURE [dss].[GetTaskById]
    @TaskId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT
        [id],
        [actionid],
        [agentid],
        [request],
        [response],
        [state],
        [retry_count],
        [dependency_count],
        [owning_instanceid],
        [creationtime],
        [pickuptime],
        [priority],
        [type],
        [completedtime],
        [lastheartbeat],
        [taskNumber],
        [version]
    FROM [dss].[task]
    WHERE [id] = @TaskId
END