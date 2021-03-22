CREATE TABLE [dss].[task] (
    [id]                UNIQUEIDENTIFIER              DEFAULT (newid()) NOT NULL,
    [actionid]          UNIQUEIDENTIFIER              NOT NULL,
    [taskNumber]        BIGINT                        IDENTITY (1, 1) NOT NULL,
    [lastheartbeat]     DATETIME                      NULL,
    [state]             INT                           DEFAULT ((0)) NULL,
    [type]              INT                           NULL,
    [agentid]           UNIQUEIDENTIFIER              NULL,
    [owning_instanceid] UNIQUEIDENTIFIER              NULL,
    [creationtime]      DATETIME                      DEFAULT (getutcdate()) NULL,
    [pickuptime]        DATETIME                      NULL,
    [completedtime]     DATETIME                      NULL,
    [request]           [dss].[TASK_REQUEST_RESPONSE] NULL,
    [response]          [dss].[TASK_REQUEST_RESPONSE] NULL,
    [priority]          INT                           DEFAULT ((100)) NULL,
    [retry_count]       INT                           DEFAULT ((0)) NOT NULL,
    [dependency_count]  INT                           DEFAULT ((0)) NOT NULL,
    [version]           BIGINT                        DEFAULT ((0)) NOT NULL,
    [lastresettime]     DATETIME                      NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK__task__actionid] FOREIGN KEY ([actionid]) REFERENCES [dss].[action] ([id])
);


GO
CREATE NONCLUSTERED INDEX [index_task_state]
    ON [dss].[task]([state] ASC, [completedtime] ASC)
    INCLUDE([type]) WHERE ([state]=(2));


GO
CREATE NONCLUSTERED INDEX [index_task_agentid_state]
    ON [dss].[task]([agentid] ASC, [state] ASC)
    INCLUDE([type]) WHERE ([state]=(0));


GO
CREATE NONCLUSTERED INDEX [index_task_completedtime]
    ON [dss].[task]([completedtime] ASC)
    INCLUDE([actionid]);


GO
CREATE NONCLUSTERED INDEX [index_task_gettask]
    ON [dss].[task]([state] ASC, [agentid] ASC, [dependency_count] ASC, [priority] ASC, [creationtime] ASC)
    INCLUDE([owning_instanceid], [version]);


GO
CREATE NONCLUSTERED INDEX [index_task_state_lastheartbeat]
    ON [dss].[task]([lastheartbeat] ASC, [state] ASC)
    INCLUDE([id], [owning_instanceid]) WHERE ([state]<(0));


GO
CREATE NONCLUSTERED INDEX [index_task_actionid]
    ON [dss].[task]([actionid] ASC)
    INCLUDE([id], [state]);

