CREATE TYPE [DataSync].[tblAddress_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [AddressID]                  INT            NOT NULL,
    [PersonID]                   INT            NULL,
    [AddressTypeID]              INT            NULL,
    [Address1]                   NVARCHAR (MAX) NULL,
    [Address2]                   NVARCHAR (MAX) NULL,
    [City]                       NVARCHAR (MAX) NULL,
    [StateID]                    INT            NULL,
    [ZipCode]                    NVARCHAR (MAX) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([AddressID] ASC));

