CREATE TYPE [DataSync].[tblLogCatchingErrors_dss_BulkType_6583ac21-60a9-4673-b783-62e2f2099d8a] AS TABLE (
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

