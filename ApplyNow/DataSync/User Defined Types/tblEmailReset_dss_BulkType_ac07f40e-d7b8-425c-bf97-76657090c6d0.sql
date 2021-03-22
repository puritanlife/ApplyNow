CREATE TYPE [DataSync].[tblEmailReset_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [EmailResetID]               INT           NOT NULL,
    [OldEmail]                   NVARCHAR (75) NULL,
    [NewEmail]                   NVARCHAR (75) NULL,
    [Token]                      NVARCHAR (60) NULL,
    [TimeStamp]                  DATETIME      NULL,
    [UsedToken]                  BIT           NULL,
    [CreatedDate]                DATETIME      NULL,
    [LastModifiedDate]           DATETIME      NULL,
    [sync_update_peer_timestamp] BIGINT        NULL,
    [sync_update_peer_key]       INT           NULL,
    [sync_create_peer_timestamp] BIGINT        NULL,
    [sync_create_peer_key]       INT           NULL,
    PRIMARY KEY CLUSTERED ([EmailResetID] ASC));

