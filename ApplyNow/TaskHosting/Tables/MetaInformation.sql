CREATE TABLE [TaskHosting].[MetaInformation] (
    [Id]             INT          IDENTITY (1, 1) NOT NULL,
    [VersionMajor]   INT          NOT NULL,
    [VersionMinor]   INT          NOT NULL,
    [VersionBuild]   INT          NOT NULL,
    [VersionService] INT          DEFAULT ((0)) NOT NULL,
    [VersionString]  VARCHAR (50) DEFAULT ('1.0.0.0') NULL,
    [Version]        BIGINT       NULL,
    [State]          BIT          DEFAULT ((1)) NOT NULL,
    [Timestamp]      DATETIME     DEFAULT (getutcdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

