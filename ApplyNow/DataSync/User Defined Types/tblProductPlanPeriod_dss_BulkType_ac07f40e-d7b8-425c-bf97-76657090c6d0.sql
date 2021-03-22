CREATE TYPE [DataSync].[tblProductPlanPeriod_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [ProductPlanPeriodID]        INT        NOT NULL,
    [ProductTypeID]              INT        NULL,
    [PlanTypeID]                 INT        NULL,
    [PeriodTypeID]               INT        NULL,
    [PremMin]                    FLOAT (53) NULL,
    [PremMax]                    FLOAT (53) NULL,
    [CreditingRate]              FLOAT (53) NULL,
    [EffectiveDate]              DATETIME   NULL,
    [EndDate]                    DATETIME   NULL,
    [CreatedDate]                DATETIME   NULL,
    [LastModifiedDate]           DATETIME   NULL,
    [sync_update_peer_timestamp] BIGINT     NULL,
    [sync_update_peer_key]       INT        NULL,
    [sync_create_peer_timestamp] BIGINT     NULL,
    [sync_create_peer_key]       INT        NULL,
    PRIMARY KEY CLUSTERED ([ProductPlanPeriodID] ASC));

