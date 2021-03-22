CREATE TABLE [dbo].[tblACHToken] (
    [ACHTokenID]       INT             IDENTITY (1, 1) NOT NULL,
    [ACHTokenNumber]   NVARCHAR (1000) NULL,
    [AppID]            NVARCHAR (100)  NOT NULL,
    [CreatedDate]      DATETIME        CONSTRAINT [DF_tblACHTokenCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME        CONSTRAINT [DF_tblACHTokenLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblACHToken] PRIMARY KEY CLUSTERED ([ACHTokenID] ASC),
    CONSTRAINT [DF_tblACHTokenAppID] UNIQUE NONCLUSTERED ([AppID] ASC)
);

