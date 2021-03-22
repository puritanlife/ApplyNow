CREATE TABLE [DataSync].[tblPasswordReset_dss_tracking] (
    [PasswordResetId]             INT        NOT NULL,
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
    CONSTRAINT [PK_DataSync.tblPasswordReset_dss_tracking] PRIMARY KEY CLUSTERED ([PasswordResetId] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [DataSync].[tblPasswordReset_dss_tracking].[PasswordResetId]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
CREATE NONCLUSTERED INDEX [tombstone_index]
    ON [DataSync].[tblPasswordReset_dss_tracking]([sync_row_is_tombstone] ASC, [local_update_peer_timestamp] ASC)
    INCLUDE([last_change_datetime]);


GO
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index]
    ON [DataSync].[tblPasswordReset_dss_tracking]([local_update_peer_timestamp] ASC, [PasswordResetId] ASC);

