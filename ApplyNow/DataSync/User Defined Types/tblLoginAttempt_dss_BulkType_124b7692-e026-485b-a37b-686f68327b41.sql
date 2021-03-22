CREATE TYPE [DataSync].[tblLoginAttempt_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
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

