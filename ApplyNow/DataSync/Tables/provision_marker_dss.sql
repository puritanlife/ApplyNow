CREATE TABLE [DataSync].[provision_marker_dss] (
    [object_id]                      INT        NOT NULL,
    [owner_scope_local_id]           INT        NOT NULL,
    [provision_scope_local_id]       INT        NULL,
    [provision_timestamp]            BIGINT     NOT NULL,
    [provision_local_peer_key]       INT        NOT NULL,
    [provision_scope_peer_key]       INT        NULL,
    [provision_scope_peer_timestamp] BIGINT     NULL,
    [provision_datetime]             DATETIME   NULL,
    [state]                          INT        NULL,
    [version]                        ROWVERSION NOT NULL,
    CONSTRAINT [PK_DataSync.provision_marker_dss] PRIMARY KEY CLUSTERED ([owner_scope_local_id] ASC, [object_id] ASC)
);

