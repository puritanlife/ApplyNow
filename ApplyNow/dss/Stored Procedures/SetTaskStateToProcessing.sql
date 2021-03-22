CREATE PROCEDURE [dss].[SetTaskStateToProcessing]
    @TaskId UNIQUEIDENTIFIER,
    @AgentId UNIQUEIDENTIFIER,
    @AgentInstanceId UNIQUEIDENTIFIER
AS
BEGIN
    IF (([dss].[IsAgentInstanceValid] (@AgentId, @AgentInstanceId)) = 0)
    BEGIN
        RAISERROR('INVALID_AGENT_INSTANCE', 15, 1);
        RETURN
    END

    -- Can only update state using this procedure to processing.
    --
    UPDATE [dss].[task]
        SET
            [state] = -1 -- -1: processing
        WHERE [id] = @TaskId AND [state] <> -4 AND [owning_instanceid] = @AgentInstanceId -- -4: cancelling

END