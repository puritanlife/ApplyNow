CREATE TYPE [DataSync].[tblEmailReset_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
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

