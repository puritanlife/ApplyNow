﻿CREATE TABLE [dbo].[tblApplyNow] (
    [ApplyNowID]         INT        IDENTITY (1, 1) NOT NULL,
    [ApplicationID]      INT        NOT NULL,
    [PersonID]           INT        NOT NULL,
    [PersonTypeID]       INT        NOT NULL,
    [Percentage]         FLOAT (53) NULL,
    [RelationshipTypeID] INT        NOT NULL,
    [CreatedDate]        DATETIME   CONSTRAINT [DF_tblApplyNowCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]   DATETIME   CONSTRAINT [DF_tblApplyNowLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblApplyNowID] PRIMARY KEY CLUSTERED ([ApplyNowID] ASC),
    CONSTRAINT [FK_ApplyNowApplicationID] FOREIGN KEY ([ApplicationID]) REFERENCES [dbo].[tblApplication] ([ApplicationID]),
    CONSTRAINT [FK_ApplyNowPersonID] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[tblPerson] ([PersonID]),
    CONSTRAINT [FK_ApplyNowPersonTypeID] FOREIGN KEY ([PersonTypeID]) REFERENCES [dbo].[tblPersonType] ([PersonTypeID]),
    CONSTRAINT [FK_ApplyNowRelationshipTypeID] FOREIGN KEY ([RelationshipTypeID]) REFERENCES [dbo].[tblRelationshipType] ([RelationshipTypeID])
);


GO
CREATE TRIGGER [dbo].[tblApplyNow_dss_update_trigger] ON [dbo].[tblApplyNow] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 466100701 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblApplyNow_dss_tracking] AS [target] 
USING (SELECT [i].[ApplyNowID] FROM INSERTED AS [i]) AS source([ApplyNowID]) 
ON ([target].[ApplyNowID] = [source].[ApplyNowID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ApplyNowID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ApplyNowID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblApplyNow_dss_delete_trigger] ON [dbo].[tblApplyNow] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 466100701 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblApplyNow_dss_tracking] AS [target] 
USING (SELECT [i].[ApplyNowID] FROM DELETED AS [i]) AS source([ApplyNowID]) 
ON ([target].[ApplyNowID] = [source].[ApplyNowID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ApplyNowID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ApplyNowID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO


 
CREATE TRIGGER trg_tblApplyNowLastModifiedDate
ON [dbo].[tblApplyNow]
AFTER UPDATE
AS
    UPDATE [dbo].[tblApplyNow]
    SET [LastModifiedDate] = GETDATE()
    WHERE [ApplyNowID] IN (SELECT [ApplyNowID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblApplyNow_dss_insert_trigger] ON [dbo].[tblApplyNow] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 466100701 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblApplyNow_dss_tracking] AS [target] 
USING (SELECT [i].[ApplyNowID] FROM INSERTED AS [i]) AS source([ApplyNowID]) 
ON ([target].[ApplyNowID] = [source].[ApplyNowID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ApplyNowID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ApplyNowID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );