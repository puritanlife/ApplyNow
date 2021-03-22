CREATE TABLE [dbo].[tblEmailReset] (
    [EmailResetID]     INT           IDENTITY (1, 1) NOT NULL,
    [OldEmail]         NVARCHAR (75) NULL,
    [NewEmail]         NVARCHAR (75) NULL,
    [Token]            NVARCHAR (60) NULL,
    [TimeStamp]        DATETIME      NOT NULL,
    [UsedToken]        BIT           CONSTRAINT [conUsedToken] DEFAULT ((0)) NOT NULL,
    [CreatedDate]      DATETIME      CONSTRAINT [DF_tblEmailResetCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME      CONSTRAINT [DF_tblEmailResetLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_EmailReset] PRIMARY KEY CLUSTERED ([EmailResetID] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblEmailReset].[OldEmail]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblEmailReset].[NewEmail]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO



 
CREATE TRIGGER trg_tblEmailResetLastModifiedDate
ON [dbo].[tblEmailReset]
AFTER UPDATE
AS
    UPDATE [dbo].[tblEmailReset]
    SET [LastModifiedDate] = GETDATE()
    WHERE [EmailResetID] IN (SELECT [EmailResetID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblEmailReset_dss_delete_trigger] ON [dbo].[tblEmailReset] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 530100929 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblEmailReset_dss_tracking] AS [target] 
USING (SELECT [i].[EmailResetID] FROM DELETED AS [i]) AS source([EmailResetID]) 
ON ([target].[EmailResetID] = [source].[EmailResetID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[EmailResetID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[EmailResetID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblEmailReset_dss_update_trigger] ON [dbo].[tblEmailReset] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 530100929 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblEmailReset_dss_tracking] AS [target] 
USING (SELECT [i].[EmailResetID] FROM INSERTED AS [i]) AS source([EmailResetID]) 
ON ([target].[EmailResetID] = [source].[EmailResetID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[EmailResetID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[EmailResetID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblEmailReset_dss_insert_trigger] ON [dbo].[tblEmailReset] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 530100929 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblEmailReset_dss_tracking] AS [target] 
USING (SELECT [i].[EmailResetID] FROM INSERTED AS [i]) AS source([EmailResetID]) 
ON ([target].[EmailResetID] = [source].[EmailResetID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[EmailResetID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[EmailResetID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );