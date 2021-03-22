CREATE TYPE [DataSync].[tblVerificationCommentSQL_dss_BulkType_ac07f40e-d7b8-425c-bf97-76657090c6d0] AS TABLE (
    [LogVerificationCommentSQLID] INT            NOT NULL,
    [Comment]                     NVARCHAR (MAX) NULL,
    [SQL]                         NVARCHAR (MAX) NULL,
    [CreatedDate]                 DATETIME       NULL,
    [LastModifiedDate]            DATETIME       NULL,
    [StatusTypeID]                INT            NULL,
    [sync_update_peer_timestamp]  BIGINT         NULL,
    [sync_update_peer_key]        INT            NULL,
    [sync_create_peer_timestamp]  BIGINT         NULL,
    [sync_create_peer_key]        INT            NULL,
    PRIMARY KEY CLUSTERED ([LogVerificationCommentSQLID] ASC));

