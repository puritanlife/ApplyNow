CREATE TYPE [DataSync].[tblUnlockAttempt_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [UnlockAttemptID]            INT            NOT NULL,
    [UserID]                     INT            NULL,
    [Email]                      NVARCHAR (75)  NULL,
    [SuccessFlag]                INT            NULL,
    [AttemptDate]                DATETIME       NULL,
    [AttemptMessage]             NVARCHAR (500) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([UnlockAttemptID] ASC));

