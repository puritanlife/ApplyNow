CREATE TYPE [DataSync].[tblLogStoredProcedureCalls_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
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

