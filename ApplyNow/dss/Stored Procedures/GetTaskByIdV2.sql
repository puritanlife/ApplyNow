CREATE PROCEDURE [dss].[GetTaskByIdV2]
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
        [lastresettime],
        [taskNumber],
        [version]
    FROM [dss].[task]
    WHERE [id] = @TaskId
END