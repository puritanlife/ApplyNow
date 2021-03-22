CREATE TABLE [dbo].[tblLexisNexisCallType] (
    [LexisNexisCallTypeID] INT            IDENTITY (1, 1) NOT NULL,
    [Type]                 NVARCHAR (MAX) NULL,
    [Descr]                NVARCHAR (MAX) NULL,
    [CreatedDate]          DATETIME       CONSTRAINT [DF_tblLexisNexisCallTypeCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]     DATETIME       CONSTRAINT [DF_tblLexisNexisCallTypeLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblLexisNexisCallType] PRIMARY KEY CLUSTERED ([LexisNexisCallTypeID] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblLexisNexisCallType].[LexisNexisCallTypeID]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Financial', INFORMATION_TYPE_ID = 'C44193E1-0E58-4B2A-9001-F7D6E7BC1373', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblLexisNexisCallType_dss_delete_trigger] ON [dbo].[tblLexisNexisCallType] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 411148510 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLexisNexisCallType_dss_tracking] AS [target] 
USING (SELECT [i].[LexisNexisCallTypeID] FROM DELETED AS [i]) AS source([LexisNexisCallTypeID]) 
ON ([target].[LexisNexisCallTypeID] = [source].[LexisNexisCallTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LexisNexisCallTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LexisNexisCallTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblLexisNexisCallType_dss_update_trigger] ON [dbo].[tblLexisNexisCallType] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 411148510 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLexisNexisCallType_dss_tracking] AS [target] 
USING (SELECT [i].[LexisNexisCallTypeID] FROM INSERTED AS [i]) AS source([LexisNexisCallTypeID]) 
ON ([target].[LexisNexisCallTypeID] = [source].[LexisNexisCallTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LexisNexisCallTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LexisNexisCallTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
 
CREATE TRIGGER [dbo].[trg_tblLexisNexisCallTypeLastModifiedDate]
ON [dbo].[tblLexisNexisCallType]
AFTER UPDATE
AS
    UPDATE [dbo].[tblLexisNexisCallType]
    SET [LastModifiedDate] = GETDATE()
    WHERE [LexisNexisCallTypeID] IN (SELECT [LexisNexisCallTypeID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblLexisNexisCallType_dss_insert_trigger] ON [dbo].[tblLexisNexisCallType] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 411148510 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLexisNexisCallType_dss_tracking] AS [target] 
USING (SELECT [i].[LexisNexisCallTypeID] FROM INSERTED AS [i]) AS source([LexisNexisCallTypeID]) 
ON ([target].[LexisNexisCallTypeID] = [source].[LexisNexisCallTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LexisNexisCallTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LexisNexisCallTypeID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );