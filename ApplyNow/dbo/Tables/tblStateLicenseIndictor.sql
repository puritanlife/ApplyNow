CREATE TABLE [dbo].[tblStateLicenseIndictor] (
    [StateLicenseIndictorID] INT      IDENTITY (1, 1) NOT NULL,
    [StateID]                INT      NOT NULL,
    [StateLicenseTypeID]     INT      NOT NULL,
    [EffectiveDate]          DATETIME NOT NULL,
    [CreatedDate]            DATETIME CONSTRAINT [DF_tblStateLicenseIndictorCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]       DATETIME CONSTRAINT [DF_tblStateLicenseIndictorLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblStateLicenseIndictor] PRIMARY KEY CLUSTERED ([StateLicenseIndictorID] ASC),
    CONSTRAINT [FK_StateLicenseIndictorStateID] FOREIGN KEY ([StateID]) REFERENCES [dbo].[tblState] ([StateID]),
    CONSTRAINT [FK_StateLicenseIndictorStateLicenseTypeID] FOREIGN KEY ([StateLicenseTypeID]) REFERENCES [dbo].[tblStateLicenseType] ([StateLicenseTypeID])
);


GO



CREATE TRIGGER [dbo].[trg_tblStateLicenseIndictorLastModifiedDate]
ON [dbo].[tblStateLicenseIndictor]
AFTER UPDATE
AS
    UPDATE [dbo].[tblStateLicenseIndictor]
    SET [LastModifiedDate] = GETDATE()
    WHERE [StateLicenseIndictorID] IN (SELECT [StateLicenseIndictorID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblStateLicenseIndictor_dss_delete_trigger] ON [dbo].[tblStateLicenseIndictor] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1362103893 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblStateLicenseIndictor_dss_tracking] AS [target] 
USING (SELECT [i].[StateLicenseIndictorID] FROM DELETED AS [i]) AS source([StateLicenseIndictorID]) 
ON ([target].[StateLicenseIndictorID] = [source].[StateLicenseIndictorID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[StateLicenseIndictorID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[StateLicenseIndictorID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblStateLicenseIndictor_dss_insert_trigger] ON [dbo].[tblStateLicenseIndictor] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1362103893 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblStateLicenseIndictor_dss_tracking] AS [target] 
USING (SELECT [i].[StateLicenseIndictorID] FROM INSERTED AS [i]) AS source([StateLicenseIndictorID]) 
ON ([target].[StateLicenseIndictorID] = [source].[StateLicenseIndictorID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[StateLicenseIndictorID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[StateLicenseIndictorID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblStateLicenseIndictor_dss_update_trigger] ON [dbo].[tblStateLicenseIndictor] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1362103893 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblStateLicenseIndictor_dss_tracking] AS [target] 
USING (SELECT [i].[StateLicenseIndictorID] FROM INSERTED AS [i]) AS source([StateLicenseIndictorID]) 
ON ([target].[StateLicenseIndictorID] = [source].[StateLicenseIndictorID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[StateLicenseIndictorID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[StateLicenseIndictorID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );