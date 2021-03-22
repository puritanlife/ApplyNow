CREATE TYPE [DataSync].[tblSourceOfFunds_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
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

