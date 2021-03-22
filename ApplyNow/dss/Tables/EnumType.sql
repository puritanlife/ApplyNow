CREATE TABLE [dss].[EnumType] (
    [Id]           INT            NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [Type]         VARCHAR (100)  NOT NULL,
    [EnumId]       INT            NOT NULL,
    [LastModified] DATETIME       DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

