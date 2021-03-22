CREATE TYPE [DataSync].[tblEmailNotification_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [EmailNotificationID]        INT           NOT NULL,
    [EmailAddress]               NVARCHAR (60) NULL,
    [SG_MessageID]               NVARCHAR (75) NULL,
    [SG_EventID]                 NVARCHAR (75) NULL,
    [EventStatus]                NVARCHAR (75) NULL,
    [IP_Address]                 NVARCHAR (60) NULL,
    [CreatedDate]                DATETIME      NULL,
    [LastModifiedDate]           DATETIME      NULL,
    [sync_update_peer_timestamp] BIGINT        NULL,
    [sync_update_peer_key]       INT           NULL,
    [sync_create_peer_timestamp] BIGINT        NULL,
    [sync_create_peer_key]       INT           NULL,
    PRIMARY KEY CLUSTERED ([EmailNotificationID] ASC));

