CREATE TYPE [DataSync].[tblAdminUser_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
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

