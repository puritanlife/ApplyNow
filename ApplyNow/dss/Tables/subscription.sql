CREATE TABLE [dss].[subscription] (
    [id]                             UNIQUEIDENTIFIER     DEFAULT (newid()) NOT NULL,
    [name]                           [dss].[DISPLAY_NAME] NULL,
    [creationtime]                   DATETIME             NULL,
    [lastlogintime]                  DATETIME             NULL,
    [tombstoneretentionperiodindays] INT                  NOT NULL,
    [policyid]                       INT                  DEFAULT ((0)) NULL,
    [subscriptionstate]              TINYINT              DEFAULT ((0)) NOT NULL,
    [WindowsAzureSubscriptionId]     UNIQUEIDENTIFIER     NULL,
    [EnableDetailedProviderTracing]  BIT                  DEFAULT ((0)) NULL,
    [syncserveruniquename]           NVARCHAR (256)       NULL,
    [version]                        [dss].[VERSION]      NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SyncServerUniqueName]
    ON [dss].[subscription]([syncserveruniquename] ASC) WHERE ([syncserveruniquename] IS NOT NULL);

