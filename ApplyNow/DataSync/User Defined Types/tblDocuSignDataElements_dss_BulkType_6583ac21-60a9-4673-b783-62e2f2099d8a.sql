CREATE TYPE [DataSync].[tblDocuSignDataElements_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
    [DocuSignDataElementsID]     INT      NOT NULL,
    [ApplyNowID]                 INT      NULL,
    [Signature]                  BIT      NULL,
    [CreatedDate]                DATETIME NULL,
    [LastModifiedDate]           DATETIME NULL,
    [sync_update_peer_timestamp] BIGINT   NULL,
    [sync_update_peer_key]       INT      NULL,
    [sync_create_peer_timestamp] BIGINT   NULL,
    [sync_create_peer_key]       INT      NULL,
    PRIMARY KEY CLUSTERED ([DocuSignDataElementsID] ASC));

