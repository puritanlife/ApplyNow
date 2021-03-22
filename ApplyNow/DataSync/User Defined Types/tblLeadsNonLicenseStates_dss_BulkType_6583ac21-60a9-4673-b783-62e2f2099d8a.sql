CREATE TYPE [DataSync].[tblLeadsNonLicenseStates_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
    [LeadsNonLicenseStatesID]    INT            NOT NULL,
    [ProductPlanPeriodID]        INT            NULL,
    [UUID]                       NVARCHAR (250) NULL,
    [StateID]                    INT            NULL,
    [Premium]                    INT            NULL,
    [StateLicenseTypeID]         INT            NULL,
    [Email]                      NVARCHAR (100) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([LeadsNonLicenseStatesID] ASC));

