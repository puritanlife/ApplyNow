CREATE TYPE [DataSync].[tblAdminUser_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
    [AdminUserId]                INT          NOT NULL,
    [Email]                      VARCHAR (75) NULL,
    [Pass]                       VARCHAR (60) NULL,
    [Attempt]                    INT          NULL,
    [locked]                     BIT          NULL,
    [Last_Login]                 DATETIME     NULL,
    [PasswordChangeDate]         DATETIME     NULL,
    [CreatedDate]                DATETIME     NULL,
    [LastModifiedDate]           DATETIME     NULL,
    [sync_update_peer_timestamp] BIGINT       NULL,
    [sync_update_peer_key]       INT          NULL,
    [sync_create_peer_timestamp] BIGINT       NULL,
    [sync_create_peer_key]       INT          NULL,
    PRIMARY KEY CLUSTERED ([AdminUserId] ASC));

