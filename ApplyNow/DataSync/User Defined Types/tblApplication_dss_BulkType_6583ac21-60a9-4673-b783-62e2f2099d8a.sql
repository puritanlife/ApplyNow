CREATE TYPE [DataSync].[tblApplication_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
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

