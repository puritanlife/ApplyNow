﻿CREATE TYPE [DataSync].[tblPPPWithRider_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [PPPWithRiderID]             INT      NOT NULL,
    [ProductPlanPeriodID]        INT      NULL,
    [RiderTypeID]                INT      NULL,
    [CreatedDate]                DATETIME NULL,
    [LastModifiedDate]           DATETIME NULL,
    [sync_update_peer_timestamp] BIGINT   NULL,
    [sync_update_peer_key]       INT      NULL,
    [sync_create_peer_timestamp] BIGINT   NULL,
    [sync_create_peer_key]       INT      NULL,
    PRIMARY KEY CLUSTERED ([PPPWithRiderID] ASC));

