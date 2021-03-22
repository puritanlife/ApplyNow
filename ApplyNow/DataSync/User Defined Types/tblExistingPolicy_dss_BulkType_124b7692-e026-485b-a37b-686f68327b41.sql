CREATE TYPE [DataSync].[tblExistingPolicy_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [ExistingPolicyID]           INT            NOT NULL,
    [ApplyNowID]                 INT            NULL,
    [PolicyNumber]               NVARCHAR (255) NULL,
    [IssueDate]                  DATE           NULL,
    [CarrierID]                  INT            NULL,
    [ChangePolicies]             BIT            NULL,
    [ExistingPolicies]           BIT            NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([ExistingPolicyID] ASC));

