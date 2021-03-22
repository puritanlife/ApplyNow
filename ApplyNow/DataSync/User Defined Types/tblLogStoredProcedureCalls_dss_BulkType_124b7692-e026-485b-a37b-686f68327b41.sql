CREATE TYPE [DataSync].[tblLogStoredProcedureCalls_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [LogStoredProcedureCallsID]  INT            NOT NULL,
    [Procedure]                  NVARCHAR (MAX) NULL,
    [Message]                    NVARCHAR (MAX) NULL,
    [Parameters]                 NVARCHAR (MAX) NULL,
    [Output]                     NVARCHAR (MAX) NULL,
    [StartSPCall]                DATETIME       NULL,
    [EndSPCall]                  DATETIME       NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([LogStoredProcedureCallsID] ASC));

