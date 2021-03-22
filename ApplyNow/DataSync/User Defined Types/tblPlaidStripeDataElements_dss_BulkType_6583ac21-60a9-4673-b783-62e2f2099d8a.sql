CREATE TYPE [DataSync].[tblPlaidStripeDataElements_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
    [PlaidStripeDataElementsID]  INT            NOT NULL,
    [ApplyNowID]                 INT            NULL,
    [Charged]                    BIT            NULL,
    [PlaidStripeID]              NVARCHAR (250) NULL,
    [PaymentAmount]              FLOAT (53)     NULL,
    [PaymentMethodTypeID]        INT            NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([PlaidStripeDataElementsID] ASC));

