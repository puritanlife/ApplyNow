CREATE TYPE [DataSync].[tblApplyNow_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [ApplyNowID]                 INT        NOT NULL,
    [ApplicationID]              INT        NULL,
    [PersonID]                   INT        NULL,
    [PersonTypeID]               INT        NULL,
    [Percentage]                 FLOAT (53) NULL,
    [RelationshipTypeID]         INT        NULL,
    [CreatedDate]                DATETIME   NULL,
    [LastModifiedDate]           DATETIME   NULL,
    [sync_update_peer_timestamp] BIGINT     NULL,
    [sync_update_peer_key]       INT        NULL,
    [sync_create_peer_timestamp] BIGINT     NULL,
    [sync_create_peer_key]       INT        NULL,
    PRIMARY KEY CLUSTERED ([ApplyNowID] ASC));

