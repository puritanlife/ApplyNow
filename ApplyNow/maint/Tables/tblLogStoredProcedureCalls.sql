CREATE TABLE [maint].[tblLogStoredProcedureCalls] (
    [LogStoredProcedureCallsID] INT            IDENTITY (1, 1) NOT NULL,
    [Procedure]                 NVARCHAR (MAX) NULL,
    [Message]                   NVARCHAR (MAX) NULL,
    [Parameters]                NVARCHAR (MAX) NULL,
    [Output]                    NVARCHAR (MAX) NULL,
    [StartSPCall]               DATETIME       NULL,
    [EndSPCall]                 DATETIME       NULL,
    [CreatedDate]               DATETIME       CONSTRAINT [DF_tblLogStoredProcedureCallsCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]          DATETIME       CONSTRAINT [DF_tblLogStoredProcedureCallsLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblLogStoredProcedureCalls] PRIMARY KEY CLUSTERED ([LogStoredProcedureCallsID] ASC)
);


GO
CREATE TRIGGER [maint].[tblLogStoredProcedureCalls_dss_insert_trigger] ON [maint].[tblLogStoredProcedureCalls] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 130099504 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLogStoredProcedureCalls_dss_tracking] AS [target] 
USING (SELECT [i].[LogStoredProcedureCallsID] FROM INSERTED AS [i]) AS source([LogStoredProcedureCallsID]) 
ON ([target].[LogStoredProcedureCallsID] = [source].[LogStoredProcedureCallsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LogStoredProcedureCallsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LogStoredProcedureCallsID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [maint].[tblLogStoredProcedureCalls_dss_delete_trigger] ON [maint].[tblLogStoredProcedureCalls] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 130099504 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLogStoredProcedureCalls_dss_tracking] AS [target] 
USING (SELECT [i].[LogStoredProcedureCallsID] FROM DELETED AS [i]) AS source([LogStoredProcedureCallsID]) 
ON ([target].[LogStoredProcedureCallsID] = [source].[LogStoredProcedureCallsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LogStoredProcedureCallsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LogStoredProcedureCallsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [maint].[tblLogStoredProcedureCalls_dss_update_trigger] ON [maint].[tblLogStoredProcedureCalls] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 130099504 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblLogStoredProcedureCalls_dss_tracking] AS [target] 
USING (SELECT [i].[LogStoredProcedureCallsID] FROM INSERTED AS [i]) AS source([LogStoredProcedureCallsID]) 
ON ([target].[LogStoredProcedureCallsID] = [source].[LogStoredProcedureCallsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[LogStoredProcedureCallsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[LogStoredProcedureCallsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );