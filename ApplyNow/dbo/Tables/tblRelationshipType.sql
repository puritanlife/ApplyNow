﻿CREATE TABLE [dbo].[tblRelationshipType] (
    [RelationshipTypeID] INT            IDENTITY (1, 1) NOT NULL,
    [Descr]              NVARCHAR (MAX) NULL,
    [GenderTypeID]       INT            NOT NULL,
    [CreatedDate]        DATETIME       CONSTRAINT [DF_tblRelationshipTypeCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]   DATETIME       CONSTRAINT [DF_tblRelationshipTypeLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    [Natural]            VARCHAR (25)   NULL,
    [Order]              INT            NULL,
    CONSTRAINT [PK_tblRelationshipType] PRIMARY KEY CLUSTERED ([RelationshipTypeID] ASC),
    CONSTRAINT [FK_RelationshipTypeGenderTypeID] FOREIGN KEY ([GenderTypeID]) REFERENCES [dbo].[tblGenderType] ([GenderTypeID])
);


GO
CREATE TRIGGER [dbo].[tblRelationshipType_dss_update_trigger] ON [dbo].[tblRelationshipType] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1202103323 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblRelationshipType_dss_tracking] AS [target] 
USING (SELECT [i].[RelationshipTypeID] FROM INSERTED AS [i]) AS source([RelationshipTypeID]) 
ON ([target].[RelationshipTypeID] = [source].[RelationshipTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[RelationshipTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[RelationshipTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblRelationshipType_dss_insert_trigger] ON [dbo].[tblRelationshipType] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1202103323 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblRelationshipType_dss_tracking] AS [target] 
USING (SELECT [i].[RelationshipTypeID] FROM INSERTED AS [i]) AS source([RelationshipTypeID]) 
ON ([target].[RelationshipTypeID] = [source].[RelationshipTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[RelationshipTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[RelationshipTypeID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblRelationshipTypeLastModifiedDate
ON [dbo].[tblRelationshipType]
AFTER UPDATE
AS
    UPDATE [dbo].[tblRelationshipType]
    SET [LastModifiedDate] = GETDATE()
    WHERE [RelationshipTypeID] IN (SELECT [RelationshipTypeID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblRelationshipType_dss_delete_trigger] ON [dbo].[tblRelationshipType] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1202103323 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblRelationshipType_dss_tracking] AS [target] 
USING (SELECT [i].[RelationshipTypeID] FROM DELETED AS [i]) AS source([RelationshipTypeID]) 
ON ([target].[RelationshipTypeID] = [source].[RelationshipTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[RelationshipTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[RelationshipTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );