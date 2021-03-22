CREATE TYPE [DataSync].[tblLogCatchingErrors_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [LogCatchingErrorsID]        INT            NOT NULL,
    [ErrorNumber]                NVARCHAR (MAX) NULL,
    [ErrorSeverity]              NVARCHAR (MAX) NULL,
    [ErrorState]                 NVARCHAR (MAX) NULL,
    [ErrorProcedure]             NVARCHAR (MAX) NULL,
    [ErrorMessage]               NVARCHAR (MAX) NULL,
    [ErrorParameters]            NVARCHAR (MAX) NULL,
    [CreatedDate]                DATETIME       NULL,
    [LastModifiedDate]           DATETIME       NULL,
    [sync_update_peer_timestamp] BIGINT         NULL,
    [sync_update_peer_key]       INT            NULL,
    [sync_create_peer_timestamp] BIGINT         NULL,
    [sync_create_peer_key]       INT            NULL,
    PRIMARY KEY CLUSTERED ([LogCatchingErrorsID] ASC));

