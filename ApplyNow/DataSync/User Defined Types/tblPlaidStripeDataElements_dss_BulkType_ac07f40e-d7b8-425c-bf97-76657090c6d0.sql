CREATE TYPE [DataSync].[tblPlaidStripeDataElements_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
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

