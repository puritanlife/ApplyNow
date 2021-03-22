CREATE TYPE [DataSync].[tblPhoneType_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [PhoneTypeID]                INT            NOT NULL,
    [Type]                       NVARCHAR (MAX) NULL,
    [Descr]                      NVARCHAR (MAX) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([PhoneTypeID] ASC));

