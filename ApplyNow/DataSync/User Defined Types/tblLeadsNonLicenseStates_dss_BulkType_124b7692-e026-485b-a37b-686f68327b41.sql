CREATE TYPE [DataSync].[tblLeadsNonLicenseStates_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [LeadsNonLicenseStatesID]    INT            NOT NULL,
    [ProductPlanPeriodID]        INT            NULL,
    [UUID]                       NVARCHAR (250) NULL,
    [StateID]                    INT            NULL,
    [Premium]                    INT            NULL,
    [StateLicenseTypeID]         INT            NULL,
    [Email]                      NVARCHAR (100) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [LeadStatus]                 NVARCHAR (20)  NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([LeadsNonLicenseStatesID] ASC));

