CREATE TABLE [dss].[agent_instance] (
    [id]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [agentid]       UNIQUEIDENTIFIER NOT NULL,
    [lastalivetime] DATETIME         NULL,
    [version]       [dss].[VERSION]  NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK__agent_ins__agent] FOREIGN KEY ([agentid]) REFERENCES [dss].[agent] ([id])
);

