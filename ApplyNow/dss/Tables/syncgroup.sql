CREATE TABLE [dss].[syncgroup] (
    [id]                           UNIQUEIDENTIFIER     DEFAULT (newid()) NOT NULL,
    [name]                         [dss].[DISPLAY_NAME] NULL,
    [subscriptionid]               UNIQUEIDENTIFIER     NULL,
    [schema_description]           XML                  NULL,
    [state]                        INT                  DEFAULT ((0)) NULL,
    [hub_memberid]                 UNIQUEIDENTIFIER     NULL,
    [conflict_resolution_policy]   INT                  NOT NULL,
    [sync_interval]                INT                  NOT NULL,
    [sync_enabled]                 BIT                  DEFAULT ((1)) NOT NULL,
    [lastupdatetime]               DATETIME             NULL,
    [ocsschemadefinition]          [dss].[DB_SCHEMA]    NULL,
    [hubhasdata]                   BIT                  NULL,
    [ConflictLoggingEnabled]       BIT                  DEFAULT ((0)) NOT NULL,
    [ConflictTableRetentionInDays] INT                  DEFAULT ((30)) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK__syncgroup__hub_m] FOREIGN KEY ([hub_memberid]) REFERENCES [dss].[userdatabase] ([id]),
    CONSTRAINT [FK__syncgroup__subsc] FOREIGN KEY ([subscriptionid]) REFERENCES [dss].[subscription] ([id])
);


GO
CREATE NONCLUSTERED INDEX [index_syncgroup_hub_memberid]
    ON [dss].[syncgroup]([hub_memberid] ASC);

