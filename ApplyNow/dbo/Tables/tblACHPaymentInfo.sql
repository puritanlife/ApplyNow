CREATE TABLE [dbo].[tblACHPaymentInfo] (
    [ACHPaymentInfoID]             INT             IDENTITY (1, 1) NOT NULL,
    [AppID]                        NVARCHAR (100)  NOT NULL,
    [Command]                      NVARCHAR (200)  NULL,
    [Amount]                       NVARCHAR (100)  NULL,
    [CustomerIPAddress]            NVARCHAR (100)  NULL,
    [Merchant_ReferenceID]         NVARCHAR (100)  NULL,
    [Billing_CustomerName]         NVARCHAR (100)  NULL,
    [AccountToken]                 NVARCHAR (100)  NULL,
    [Status]                       NVARCHAR (100)  NULL,
    [Status_Details]               NVARCHAR (1000) NULL,
    [TransactionReferenceID]       NVARCHAR (1000) NULL,
    [CreatedDate]                  DATETIME        CONSTRAINT [DF_tblACHPaymentInfoCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]             DATETIME        CONSTRAINT [DF_tblACHPaymentInfoLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    [TransactionStatus]            NVARCHAR (500)  NULL,
    [TransactionStatusUpdatedDate] DATETIME        NULL,
    CONSTRAINT [PK_tblACHPaymentInfo] PRIMARY KEY CLUSTERED ([ACHPaymentInfoID] ASC),
    CONSTRAINT [DF_tblACHPaymentInfoAppID] UNIQUE NONCLUSTERED ([AppID] ASC)
);

