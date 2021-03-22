CREATE TYPE [DataSync].[tblLoginAttempt_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
    [LoginAttemptID]             INT            NOT NULL,
    [UserID]                     INT            NULL,
    [Email]                      NVARCHAR (75)  NULL,
    [SuccessFlag]                INT            NULL,
    [AttemptDate]                DATETIME       NULL,
    [AttemptMessage]             NVARCHAR (255) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([LoginAttemptID] ASC));

