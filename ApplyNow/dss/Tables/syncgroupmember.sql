CREATE TABLE [dss].[syncgroupmember] (
    [id]                               UNIQUEIDENTIFIER     DEFAULT (newid()) NOT NULL,
    [name]                             [dss].[DISPLAY_NAME] NOT NULL,
    [scopename]                        NVARCHAR (100)       DEFAULT (newid()) NOT NULL,
    [syncgroupid]                      UNIQUEIDENTIFIER     NOT NULL,
    [syncdirection]                    INT                  DEFAULT ((0)) NOT NULL,
    [databaseid]                       UNIQUEIDENTIFIER     NOT NULL,
    [memberstate]                      INT                  DEFAULT ((0)) NOT NULL,
    [hubstate]                         INT                  DEFAULT ((0)) NOT NULL,
    [memberstate_lastupdated]          DATETIME             DEFAULT (getutcdate()) NOT NULL,
    [hubstate_lastupdated]             DATETIME             DEFAULT (getutcdate()) NOT NULL,
    [lastsynctime]                     DATETIME             NULL,
    [lastsynctime_zerofailures_member] DATETIME             NULL,
    [lastsynctime_zerofailures_hub]    DATETIME             NULL,
    [jobId]                            UNIQUEIDENTIFIER     NULL,
    [hubJobId]                         UNIQUEIDENTIFIER     NULL,
    [noinitsync]                       BIT                  DEFAULT ((0)) NOT NULL,
    [memberhasdata]                    BIT                  NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK__syncmember__datab] FOREIGN KEY ([databaseid]) REFERENCES [dss].[userdatabase] ([id]),
    CONSTRAINT [FK__syncmember__syncg] FOREIGN KEY ([syncgroupid]) REFERENCES [dss].[syncgroup] ([id]),
    CONSTRAINT [IX_SyncGroupMember_SyncGroupId_DatabaseId] UNIQUE NONCLUSTERED ([syncgroupid] ASC, [databaseid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_syncgroupmember_databaseid]
    ON [dss].[syncgroupmember]([databaseid] ASC);

