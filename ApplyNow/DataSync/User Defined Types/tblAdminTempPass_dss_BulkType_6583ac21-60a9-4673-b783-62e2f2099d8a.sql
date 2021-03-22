CREATE TYPE [DataSync].[tblAdminTempPass_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
    [AdminTempPassID]            INT          NOT NULL,
    [AdminUserID]                INT          NULL,
    [Pass]                       VARCHAR (60) NULL,
    [PasswordUsed]               BIT          NULL,
    [ExpirationDate]             DATETIME     NULL,
    [PasswordUsedDate]           DATETIME     NULL,
    [CreatedDate]                DATETIME     NULL,
    [LastModifiedDate]           DATETIME     NULL,
    [sync_update_peer_timestamp] BIGINT       NULL,
    [sync_update_peer_key]       INT          NULL,
    [sync_create_peer_timestamp] BIGINT       NULL,
    [sync_create_peer_key]       INT          NULL,
    PRIMARY KEY CLUSTERED ([AdminTempPassID] ASC));

