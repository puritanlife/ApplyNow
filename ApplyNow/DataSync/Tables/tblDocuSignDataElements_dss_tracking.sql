CREATE TABLE [DataSync].[tblDocuSignDataElements_dss_tracking] (
    [DocuSignDataElementsID]      INT        NOT NULL,
    [update_scope_local_id]       INT        NULL,
    [scope_update_peer_key]       INT        NULL,
    [scope_update_peer_timestamp] BIGINT     NULL,
    [local_update_peer_key]       INT        NOT NULL,
    [local_update_peer_timestamp] ROWVERSION NOT NULL,
    [create_scope_local_id]       INT        NULL,
    [scope_create_peer_key]       INT        NULL,
    [scope_create_peer_timestamp] BIGINT     NULL,
    [local_create_peer_key]       INT        NOT NULL,
    [local_create_peer_timestamp] BIGINT     NOT NULL,
    [sync_row_is_tombstone]       INT        NOT NULL,
    [last_change_datetime]        DATETIME   NULL,
    CONSTRAINT [PK_DataSync.tblDocuSignDataElements_dss_tracking] PRIMARY KEY CLUSTERED ([DocuSignDataElementsID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [tombstone_index]
    ON [DataSync].[tblDocuSignDataElements_dss_tracking]([sync_row_is_tombstone] ASC, [local_update_peer_timestamp] ASC)
    INCLUDE([last_change_datetime]);


GO
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index]
    ON [DataSync].[tblDocuSignDataElements_dss_tracking]([local_update_peer_timestamp] ASC, [DocuSignDataElementsID] ASC);

