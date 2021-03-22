CREATE TYPE [DataSync].[tblSourceOfFunds_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [SourceOfFundsID]            INT      NOT NULL,
    [ApplicationID]              INT      NULL,
    [FundsTypeID]                INT      NULL,
    [Contribution]               BIT      NULL,
    [ContributionYear]           INT      NULL,
    [Transfer]                   BIT      NULL,
    [Rollover]                   BIT      NULL,
    [Conversion]                 BIT      NULL,
    [ConversionYear]             INT      NULL,
    [CreatedDate]                DATETIME NULL,
    [LastModifiedDate]           DATETIME NULL,
    [sync_update_peer_timestamp] BIGINT   NULL,
    [sync_update_peer_key]       INT      NULL,
    [sync_create_peer_timestamp] BIGINT   NULL,
    [sync_create_peer_key]       INT      NULL,
    PRIMARY KEY CLUSTERED ([SourceOfFundsID] ASC));

