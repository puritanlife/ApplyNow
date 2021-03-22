CREATE TABLE [dbo].[tblLexisNexisDataElements] (
    [LexisNexisDataElementsID] INT      IDENTITY (1, 1) NOT NULL,
    [LexisNexisCallTypeID]     INT      NOT NULL,
    [ApplyNowID]               INT      NOT NULL,
    [ConversationID]           BIGINT   NULL,
    [CreatedDate]              DATETIME CONSTRAINT [DF_tblLexisNexisDataElementsCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]         DATETIME CONSTRAINT [DF_tblLexisNexisDataElementsLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblLexisNexisDataElementsID] PRIMARY KEY CLUSTERED ([LexisNexisDataElementsID] ASC),
    CONSTRAINT [FK_LexisNexisDataElementsApplyNowID] FOREIGN KEY ([ApplyNowID]) REFERENCES [dbo].[tblApplyNow] ([ApplyNowID]),
    CONSTRAINT [FK_LexisNexisDataElementsLexisNexisCallType] FOREIGN KEY ([LexisNexisCallTypeID]) REFERENCES [dbo].[tblLexisNexisCallType] ([LexisNexisCallTypeID])
);


GO

 
CREATE TRIGGER [dbo].[trg_tblLexisNexisDataElementsLastModifiedDate]
ON [dbo].[tblLexisNexisDataElements]
AFTER UPDATE
AS
    UPDATE [dbo].[tblLexisNexisDataElements]
    SET [LastModifiedDate] = GETDATE()
    WHERE [LexisNexisDataElementsID] IN (SELECT [LexisNexisDataElementsID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblLexisNexisDataElements_dss_update_trigger] ON [dbo].[tblLexisNexisDataElements] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 507148852 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLexisNexisDataElements_dss_tracking] AS [target] 
USING (SELECT [i].[LexisNexisDataElementsID] FROM INSERTED AS [i]) AS source([LexisNexisDataElementsID]) 
ON ([target].[LexisNexisDataElementsID] = [source].[LexisNexisDataElementsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LexisNexisDataElementsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LexisNexisDataElementsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblLexisNexisDataElements_dss_insert_trigger] ON [dbo].[tblLexisNexisDataElements] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 507148852 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLexisNexisDataElements_dss_tracking] AS [target] 
USING (SELECT [i].[LexisNexisDataElementsID] FROM INSERTED AS [i]) AS source([LexisNexisDataElementsID]) 
ON ([target].[LexisNexisDataElementsID] = [source].[LexisNexisDataElementsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LexisNexisDataElementsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LexisNexisDataElementsID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblLexisNexisDataElements_dss_delete_trigger] ON [dbo].[tblLexisNexisDataElements] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 507148852 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLexisNexisDataElements_dss_tracking] AS [target] 
USING (SELECT [i].[LexisNexisDataElementsID] FROM DELETED AS [i]) AS source([LexisNexisDataElementsID]) 
ON ([target].[LexisNexisDataElementsID] = [source].[LexisNexisDataElementsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LexisNexisDataElementsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LexisNexisDataElementsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );