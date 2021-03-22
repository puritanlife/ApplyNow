CREATE TABLE [dss].[configuration] (
    [Id]           INT            NOT NULL,
    [ConfigKey]    NVARCHAR (100) NOT NULL,
    [ConfigValue]  NVARCHAR (256) NOT NULL,
    [LastModified] DATETIME       DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

