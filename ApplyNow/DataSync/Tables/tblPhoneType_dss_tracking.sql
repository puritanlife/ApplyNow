CREATE TABLE [DataSync].[tblPhoneType_dss_tracking] (
    [PhoneTypeID]                 INT        NOT NULL,
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
    CONSTRAINT [PK_DataSync.tblPhoneType_dss_tracking] PRIMARY KEY CLUSTERED ([PhoneTypeID] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [DataSync].[tblPhoneType_dss_tracking].[PhoneTypeID]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
CREATE NONCLUSTERED INDEX [tombstone_index]
    ON [DataSync].[tblPhoneType_dss_tracking]([sync_row_is_tombstone] ASC, [local_update_peer_timestamp] ASC)
    INCLUDE([last_change_datetime]);


GO
CREATE NONCLUSTERED INDEX [local_update_peer_timestamp_index]
    ON [DataSync].[tblPhoneType_dss_tracking]([local_update_peer_timestamp] ASC, [PhoneTypeID] ASC);

