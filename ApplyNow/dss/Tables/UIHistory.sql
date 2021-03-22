CREATE TABLE [dss].[UIHistory] (
    [id]                     UNIQUEIDENTIFIER NOT NULL,
    [completionTime]         DATETIME2 (7)    NOT NULL,
    [taskType]               INT              NOT NULL,
    [recordType]             INT              NOT NULL,
    [serverid]               UNIQUEIDENTIFIER NOT NULL,
    [agentid]                UNIQUEIDENTIFIER NOT NULL,
    [databaseid]             UNIQUEIDENTIFIER NOT NULL,
    [syncgroupId]            UNIQUEIDENTIFIER NOT NULL,
    [detailEnumId]           NVARCHAR (400)   NOT NULL,
    [detailStringParameters] NVARCHAR (MAX)   NULL,
    [isWritable]             BIT              DEFAULT ((1)) NULL
);


GO
CREATE NONCLUSTERED INDEX [Idx_UIHistory_DatabaseId]
    ON [dss].[UIHistory]([databaseid] ASC);


GO
CREATE NONCLUSTERED INDEX [Idx_UIHistory_CompletionTime]
    ON [dss].[UIHistory]([completionTime] ASC);


GO
CREATE NONCLUSTERED INDEX [Idx_UIHistory_Id]
    ON [dss].[UIHistory]([id] ASC);


GO
CREATE NONCLUSTERED INDEX [Idx_UIHistory_SyncgroupId]
    ON [dss].[UIHistory]([syncgroupId] ASC);


GO
CREATE NONCLUSTERED INDEX [Idx_UIHistory_AgentId]
    ON [dss].[UIHistory]([agentid] ASC);


GO
CREATE CLUSTERED INDEX [Idx_UIHistory_ServerId]
    ON [dss].[UIHistory]([serverid] ASC);

