CREATE TABLE [dss].[userdatabase] (
    [id]                    UNIQUEIDENTIFIER  DEFAULT (newid()) NOT NULL,
    [server]                NVARCHAR (256)    NULL,
    [database]              NVARCHAR (256)    NULL,
    [state]                 INT               DEFAULT ((0)) NOT NULL,
    [subscriptionid]        UNIQUEIDENTIFIER  NOT NULL,
    [agentid]               UNIQUEIDENTIFIER  NOT NULL,
    [connection_string]     VARBINARY (MAX)   NULL,
    [db_schema]             [dss].[DB_SCHEMA] NULL,
    [is_on_premise]         BIT               NOT NULL,
    [sqlazure_info]         XML               NULL,
    [last_schema_updated]   DATETIME          NULL,
    [last_tombstonecleanup] DATETIME          NULL,
    [region]                NVARCHAR (256)    NULL,
    [jobId]                 UNIQUEIDENTIFIER  NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK__userdatab__subsc] FOREIGN KEY ([subscriptionid]) REFERENCES [dss].[subscription] ([id])
);

