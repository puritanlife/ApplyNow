CREATE TABLE [dss].[action] (
    [id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [syncgroupid]    UNIQUEIDENTIFIER NULL,
    [type]           INT              NOT NULL,
    [state]          INT              DEFAULT ((0)) NOT NULL,
    [creationtime]   DATETIME         DEFAULT (getutcdate()) NULL,
    [lastupdatetime] DATETIME         NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [index_action_state_lastupdatetime]
    ON [dss].[action]([state] ASC, [lastupdatetime] ASC);

