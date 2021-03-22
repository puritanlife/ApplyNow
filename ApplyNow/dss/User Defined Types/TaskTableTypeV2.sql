CREATE TYPE [dss].[TaskTableTypeV2] AS TABLE (
    [id]               UNIQUEIDENTIFIER              NULL,
    [actionid]         UNIQUEIDENTIFIER              NULL,
    [agentid]          UNIQUEIDENTIFIER              NULL,
    [request]          [dss].[TASK_REQUEST_RESPONSE] NULL,
    [dependency_count] INT                           NULL,
    [priority]         INT                           DEFAULT ((100)) NULL,
    [type]             INT                           NULL,
    [version]          BIGINT                        DEFAULT ((0)) NULL);

