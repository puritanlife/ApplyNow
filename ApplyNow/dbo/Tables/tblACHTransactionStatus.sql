CREATE TABLE [dbo].[tblACHTransactionStatus] (
    [ACHTransactionStatusID] INT             IDENTITY (1, 1) NOT NULL,
    [TransactRefID]          NVARCHAR (1000) NOT NULL,
    [Description]            NVARCHAR (1000) NULL,
    [EventName]              NVARCHAR (100)  NULL,
    [EventDate]              NVARCHAR (100)  NULL,
    [EventTime]              NVARCHAR (100)  NULL,
    [ResultingStatus]        NVARCHAR (100)  NULL,
    [CreatedDate]            DATETIME        CONSTRAINT [DF_tblACHTransactionStatusCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]       DATETIME        CONSTRAINT [DF_tblACHTransactionStatusLastModifiedDate] DEFAULT (getdate()) NOT NULL
);

