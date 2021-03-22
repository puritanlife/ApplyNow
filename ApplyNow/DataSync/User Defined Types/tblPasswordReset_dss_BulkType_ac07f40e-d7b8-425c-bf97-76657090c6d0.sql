CREATE TYPE [DataSync].[tblPasswordReset_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [PasswordResetId]            INT      NOT NULL,
    [UserId]                     INT      NULL,
    [Request_Date]               DATETIME NULL,
    [PasswordUsedDate]           DATETIME NULL,
    [PasswordUsed]               BIT      NULL,
    [CreatedDate]                DATETIME NULL,
    [LastModifiedDate]           DATETIME NULL,
    [sync_update_peer_timestamp] BIGINT   NULL,
    [sync_update_peer_key]       INT      NULL,
    [sync_create_peer_timestamp] BIGINT   NULL,
    [sync_create_peer_key]       INT      NULL,
    PRIMARY KEY CLUSTERED ([PasswordResetId] ASC));

