﻿CREATE TYPE [DataSync].[tblApplication_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [ApplicationID]              INT            NOT NULL,
    [ProductPlanPeriodID]        INT            NULL,
    [UUID]                       NVARCHAR (250) NULL,
    [StateID]                    INT            NULL,
    [Premium]                    FLOAT (53)     NULL,
    [ForCompany]                 BIT            NULL,
    [StatusTypeID]               INT            NULL,
    [CanvasPolicyNumber]         NVARCHAR (100) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [StateLicenseTypeID]         INT            NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([ApplicationID] ASC));

