-- TODO: Remove this SP after SU02-2013
CREATE PROCEDURE [dss].[ValidateNTierSessionV2]
    @DssServerId		UNIQUEIDENTIFIER,
    @AgentId		UNIQUEIDENTIFIER,
    @SyncGroupId		UNIQUEIDENTIFIER,
    @LocalDatabaseId	UNIQUEIDENTIFIER,
    @RemoteDatabaseId	UNIQUEIDENTIFIER,
    @TaskId				UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @AgentOnPremise	BIT = NULL
    DECLARE @InternalServerId		UNIQUEIDENTIFIER = NULL
    DECLARE @AgentState				INT = NULL
    DECLARE @InternalHubDatabaseId	UNIQUEIDENTIFIER = NULL
    DECLARE @InternalSyncGroupServerId	UNIQUEIDENTIFIER = NULL
    DECLARE	@SyncGroupState			INT = NULL

    DECLARE @LocalDatabaseServerId		UNIQUEIDENTIFIER = NULL
    DECLARE @LocalDatabaseAgentId		UNIQUEIDENTIFIER = NULL
    DECLARE @LocalDatabaseOnPremise	BIT = NULL
    DECLARE @LocalDatabaseState		INT = NULL

    DECLARE @RemoteDatabaseServerId		UNIQUEIDENTIFIER = NULL
    DECLARE @RemoteDatabaseOnPremise	BIT = NULL
    DECLARE @RemoteDatabaseState		INT = NULL

    DECLARE @TaskState	INT = NULL
    DECLARE @TaskAgentId	UNIQUEIDENTIFIER = NULL

    SELECT
            @AgentOnPremise = [is_on_premise],
            @InternalServerId = [subscriptionid],
            @AgentState = [state]
        FROM [dss].[agent]
        WHERE [id] = @AgentId

    IF @AgentOnPremise = 1
    BEGIN
        IF (@InternalServerId IS NULL)
        BEGIN
            RAISERROR('INVALID_AGENT', 15, 1);
            RETURN
        END

        IF (@InternalServerId <> @DssServerId)
        BEGIN
            RAISERROR('LOCAL_AGENT_NOT_IN_DSSSERVER', 15, 1);
            RETURN
        END

        IF (@AgentState <> 1) -- 1: active
        BEGIN
            RAISERROR('LOCAL_AGENT_NOT_ACTIVE', 15, 1);
            RETURN
        END
    END

    SELECT
        @TaskState = [state],
        @TaskAgentId = [agentid]
    FROM [dss].[task]
    WHERE [id] = @TaskId

    IF (@TaskState IS NULL)
    BEGIN
        RAISERROR('INVALID_TASK', 15, 1)
        RETURN
    END

    -- Check Agent
    IF (@AgentId <> @TaskAgentId)
    BEGIN
        RAISERROR('TASK_AGENT_MISMATCH', 15, 1)
        RETURN
    END

    -- Check state
    -- Raise error when the task is processing or cancelling
    IF (@TaskState <> -1 AND @TaskState <> -4) -- -1: processing -4: cancelling
    BEGIN
        RAISERROR('TASK_NOT_IN_PROCESSING_STATE', 15, 1)
        RETURN
    END

    SELECT
        @LocalDatabaseServerId = [subscriptionid],
        @LocalDatabaseAgentId = [agentid],
        @LocalDatabaseOnPremise = [is_on_premise],
        @LocalDatabaseState = [state]
    FROM [dss].[userdatabase]
    WHERE [id] = @LocalDatabaseId

    IF (@LocalDatabaseServerId IS NULL) -- non nullable column
    BEGIN
        RAISERROR('INVALID_LOCAL_DATABASE', 15, 1)
        RETURN
    END

    IF (@LocalDatabaseServerId <> @DssServerId)
    BEGIN
        RAISERROR('LOCAL_DATABASE_NOT_IN_DSSSERVER', 15, 1);
        RETURN
    END

    IF @AgentOnPremise = 1
    BEGIN
        IF (@LocalDatabaseOnPremise <> 1) -- 1: onpremise
        BEGIN
            RAISERROR('LOCAL_DATABASE_NOT_LOCAL', 15, 1);
            RETURN
        END
    END

    IF (@LocalDatabaseState = 5) -- 5: SuspendedDueToWrongCredentials
    BEGIN
        RAISERROR('LOCAL_DATABASE_SUSPENDED', 15, 1);
        RETURN
    END

    IF (@LocalDatabaseAgentId <> @AgentId)
    BEGIN
        RAISERROR('LOCAL_DATABASE_AGENT_MISMATCH', 15, 1);
        RETURN
    END

    SELECT
        @RemoteDatabaseServerId = [subscriptionid],
        @RemoteDatabaseOnPremise = [is_on_premise],
        @RemoteDatabaseState = [state]
    FROM [dss].[userdatabase]
    WHERE [id] = @RemoteDatabaseId

    IF (@RemoteDatabaseServerId IS NULL) -- non nullable column
    BEGIN
        RAISERROR('INVALID_CLOUD_DATABASE', 15, 1)
        RETURN
    END

    IF (@RemoteDatabaseServerId <> @DssServerId)
    BEGIN
        RAISERROR('CLOUD_DATABASE_NOT_IN_DSSSERVER', 15, 1);
        RETURN
    END

    IF (@RemoteDatabaseOnPremise <> 0) -- 0: cloud
    BEGIN
        RAISERROR('CLOUD_DATABASE_NOT_CLOUD', 15, 1);
        RETURN
    END

    IF (@RemoteDatabaseState = 5) -- 5: SuspendedDueToWrongCredentials
    BEGIN
        RAISERROR('CLOUD_DATABASE_SUSPENDED', 15, 1);
        RETURN
    END

    SELECT
        @InternalSyncGroupServerId = [subscriptionid],
        @SyncGroupState = [state],
        @InternalHubDatabaseId = [hub_memberid]
    FROM [dss].[syncgroup]
    WHERE [id] = @SyncGroupId

    IF (@InternalSyncGroupServerId IS NULL)
    BEGIN
        RAISERROR('INVALID_SYNC_GROUP', 15, 1);
        RETURN
    END

    IF (@InternalSyncGroupServerId <> @DssServerId)
    BEGIN
        RAISERROR('SYNC_GROUP_NOT_IN_DSSSERVER', 15, 1);
        RETURN
    END

    IF @AgentOnPremise = 1
    BEGIN
        IF (@InternalHubDatabaseId <> @RemoteDatabaseId)
        BEGIN
            RAISERROR('CLOUD_DATABASE_NOT_HUB', 15, 1);
            RETURN
        END

        IF NOT EXISTS (SELECT 1 FROM [dss].[syncgroupmember] WHERE [syncgroupid] = @SyncGroupId AND [databaseid] = @LocalDatabaseId)
        BEGIN
            RAISERROR('INVALID_SYNC_GROUP_MEMBER', 15, 1);
            RETURN
        END
    END
END