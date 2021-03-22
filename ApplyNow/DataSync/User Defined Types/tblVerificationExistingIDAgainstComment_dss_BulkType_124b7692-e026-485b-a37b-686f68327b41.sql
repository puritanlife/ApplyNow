CREATE TYPE [DataSync].[tblVerificationExistingIDAgainstComment_dss_BulkType_124b7692-e026-485b-a37b-686f68327b41] AS TABLE (
    [LogExistingIDAgainstCommentID] INT      NOT NULL,
    [LogVerificationCommentSQLID]   INT      NULL,
    [ExistingID]                    INT      NULL,
    [AsOfDate]                      DATE     NULL,
    [CreatedDate]                   DATETIME NULL,
    [LastModifiedDate]              DATETIME NULL,
    [sync_update_peer_timestamp]    BIGINT   NULL,
    [sync_update_peer_key]          INT      NULL,
    [sync_create_peer_timestamp]    BIGINT   NULL,
    [sync_create_peer_key]          INT      NULL,
    PRIMARY KEY CLUSTERED ([LogExistingIDAgainstCommentID] ASC));

