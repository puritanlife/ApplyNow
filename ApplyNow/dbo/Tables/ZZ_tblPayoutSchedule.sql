CREATE TABLE [dbo].[ZZ_tblPayoutSchedule] (
    [PayoutScheduleID]     INT            IDENTITY (1, 1) NOT NULL,
    [PolicyNumber]         NVARCHAR (50)  NULL,
    [StripeChargeID]       NVARCHAR (100) NULL,
    [StripePayoutID]       NVARCHAR (100) NULL,
    [BalanceTransactionID] NVARCHAR (100) NOT NULL,
    [CreatedDate]          DATETIME       CONSTRAINT [DF_tblPayoutScheduleCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]     DATETIME       CONSTRAINT [DF_tblPayoutScheduleLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPayoutSchedule] PRIMARY KEY CLUSTERED ([PayoutScheduleID] ASC, [BalanceTransactionID] ASC),
    CONSTRAINT [FK_StripeChargeID] FOREIGN KEY ([StripeChargeID]) REFERENCES [dbo].[ZZ_tblCharge] ([StripeChargeID]),
    CONSTRAINT [FK_StripePayoutID] FOREIGN KEY ([StripePayoutID]) REFERENCES [dbo].[ZZ_tblPayout] ([StripePayoutID])
);

