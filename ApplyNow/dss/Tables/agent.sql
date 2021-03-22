CREATE TABLE [dss].[agent] (
    [id]             UNIQUEIDENTIFIER      DEFAULT (newid()) NOT NULL,
    [name]           [dss].[DISPLAY_NAME]  NULL,
    [subscriptionid] UNIQUEIDENTIFIER      NULL,
    [state]          INT                   DEFAULT ((1)) NULL,
    [lastalivetime]  DATETIME              NULL,
    [is_on_premise]  BIT                   NOT NULL,
    [version]        [dss].[VERSION]       NULL,
    [password_hash]  [dss].[PASSWORD_HASH] NULL,
    [password_salt]  [dss].[PASSWORD_SALT] NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK__agent__subscript] FOREIGN KEY ([subscriptionid]) REFERENCES [dss].[subscription] ([id])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dss].[agent].[password_hash]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dss].[agent].[password_salt]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Agent_SubId_Name]
    ON [dss].[agent]([subscriptionid] ASC, [name] ASC);

