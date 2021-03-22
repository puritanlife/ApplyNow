CREATE TABLE [dss].[agent_version] (
    [Id]        INT            NOT NULL,
    [Version]   NVARCHAR (50)  NOT NULL,
    [ExpiresOn] DATETIME       DEFAULT ('9999-12-31 23:59:59.997') NOT NULL,
    [Comment]   NVARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    UNIQUE NONCLUSTERED ([Version] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dss].[agent_version].[ExpiresOn]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credit Card', INFORMATION_TYPE_ID = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646', RANK = MEDIUM);

