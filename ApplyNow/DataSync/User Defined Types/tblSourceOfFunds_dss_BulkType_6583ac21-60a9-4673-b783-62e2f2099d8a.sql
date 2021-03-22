CREATE TYPE [DataSync].[tblSourceOfFunds_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
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

