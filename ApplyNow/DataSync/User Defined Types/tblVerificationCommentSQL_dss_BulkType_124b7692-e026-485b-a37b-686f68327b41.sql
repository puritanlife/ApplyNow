CREATE TYPE [DataSync].[tblVerificationCommentSQL_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
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

