CREATE TABLE [dbo].[tblSSNTINType] (
    [SSNTINTypeID]     INT            IDENTITY (1, 1) NOT NULL,
    [Type]             NVARCHAR (MAX) NULL,
    [Descr]            NVARCHAR (MAX) NULL,
    [CreatedDate]      DATETIME       CONSTRAINT [DF_tblSSNTINTypeCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME       CONSTRAINT [DF_tblSSNTINTypeLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblSSNTINType] PRIMARY KEY CLUSTERED ([SSNTINTypeID] ASC)
);


GO
CREATE TRIGGER [dbo].[tblSSNTINType_dss_delete_trigger] ON [dbo].[tblSSNTINType] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1298103665 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblSSNTINType_dss_tracking] AS [target] 
USING (SELECT [i].[SSNTINTypeID] FROM DELETED AS [i]) AS source([SSNTINTypeID]) 
ON ([target].[SSNTINTypeID] = [source].[SSNTINTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[SSNTINTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[SSNTINTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblSSNTINType_dss_update_trigger] ON [dbo].[tblSSNTINType] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1298103665 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblSSNTINType_dss_tracking] AS [target] 
USING (SELECT [i].[SSNTINTypeID] FROM INSERTED AS [i]) AS source([SSNTINTypeID]) 
ON ([target].[SSNTINTypeID] = [source].[SSNTINTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[SSNTINTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[SSNTINTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblSSNTINTypeLastModifiedDate
ON [dbo].[tblSSNTINType]
AFTER UPDATE
AS
    UPDATE [dbo].[tblSSNTINType]
    SET [LastModifiedDate] = GETDATE()
    WHERE [SSNTINTypeID] IN (SELECT [SSNTINTypeID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblSSNTINType_dss_insert_trigger] ON [dbo].[tblSSNTINType] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1298103665 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblSSNTINType_dss_tracking] AS [target] 
USING (SELECT [i].[SSNTINTypeID] FROM INSERTED AS [i]) AS source([SSNTINTypeID]) 
ON ([target].[SSNTINTypeID] = [source].[SSNTINTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[SSNTINTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[SSNTINTypeID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );