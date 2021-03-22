﻿CREATE TABLE [dbo].[ZZ_tblCharge] (
    [ChargeID]            INT            IDENTITY (1, 1) NOT NULL,
    [Status]              NVARCHAR (50)  NULL,
    [StripeChargeID]      NVARCHAR (100) NOT NULL,
    [ChargeDate]          DATETIME       NULL,
    [ChargeSuccessDate]   DATETIME       NULL,
    [ChargeFailureDate]   DATETIME       NULL,
    [ChargeFailureReason] NVARCHAR (100) NULL,
    [Amount]              NVARCHAR (100) NULL,
    [CreatedDate]         DATETIME       CONSTRAINT [DF_tblChargeCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME       CONSTRAINT [DF_tblChargeLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblCharge] PRIMARY KEY CLUSTERED ([StripeChargeID] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[ZZ_tblCharge].[Amount]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Financial', INFORMATION_TYPE_ID = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373', RANK = MEDIUM);

