CREATE TABLE [dss].[scaleunitlimits] (
    [Id]           INT            NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [MaxValue]     INT            NOT NULL,
    [LastModified] DATETIME       DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

