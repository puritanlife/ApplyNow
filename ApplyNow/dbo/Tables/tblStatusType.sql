CREATE TABLE [dbo].[tblStatusType] (
    [StatusTypeID]     INT            IDENTITY (1, 1) NOT NULL,
    [Type]             NVARCHAR (MAX) NULL,
    [Descr]            NVARCHAR (MAX) NULL,
    [CreatedDate]      DATETIME       CONSTRAINT [DF_tblStatusTypeCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME       CONSTRAINT [DF_tblStatusTypeLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblStatusType] PRIMARY KEY CLUSTERED ([StatusTypeID] ASC)
);


GO
CREATE TRIGGER [dbo].[tblStatusType_dss_delete_trigger] ON [dbo].[tblStatusType] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1426104121 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblStatusType_dss_tracking] AS [target] 
USING (SELECT [i].[StatusTypeID] FROM DELETED AS [i]) AS source([StatusTypeID]) 
ON ([target].[StatusTypeID] = [source].[StatusTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[StatusTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[StatusTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblStatusType_dss_insert_trigger] ON [dbo].[tblStatusType] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1426104121 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblStatusType_dss_tracking] AS [target] 
USING (SELECT [i].[StatusTypeID] FROM INSERTED AS [i]) AS source([StatusTypeID]) 
ON ([target].[StatusTypeID] = [source].[StatusTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[StatusTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[StatusTypeID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblStatusTypeLastModifiedDate
ON [dbo].[tblStatusType]
AFTER UPDATE
AS
    UPDATE [dbo].[tblStatusType]
    SET [LastModifiedDate] = GETDATE()
    WHERE [StatusTypeID] IN (SELECT [StatusTypeID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblStatusType_dss_update_trigger] ON [dbo].[tblStatusType] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1426104121 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblStatusType_dss_tracking] AS [target] 
USING (SELECT [i].[StatusTypeID] FROM INSERTED AS [i]) AS source([StatusTypeID]) 
ON ([target].[StatusTypeID] = [source].[StatusTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[StatusTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[StatusTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );