﻿CREATE TABLE [dbo].[tblTransposeApplyNowApplication] (
    [TransposeApplyNowApplicationID] INT      IDENTITY (1, 1) NOT NULL,
    [ApplicationID]                  INT      NULL,
    [ApplyNowIDOwner]                INT      NULL,
    [ApplyNowIDJointOwner]           INT      NULL,
    [ApplyNowIDAnnuitant]            INT      NULL,
    [ApplyNowIDJointAnnuitant]       INT      NULL,
    [ApplyNowIDBeneficiary1]         INT      NULL,
    [ApplyNowIDBeneficiary2]         INT      NULL,
    [ApplyNowIDBeneficiary3]         INT      NULL,
    [ApplyNowIDBeneficiary4]         INT      NULL,
    [ApplyNowIDBeneficiary5]         INT      NULL,
    [ApplyNowIDReplacementCompany]   INT      NULL,
    [ApplyNowIDUnknown]              INT      NULL,
    [ApplyNowIDAgent]                INT      NULL,
    [CreatedDate]                    DATETIME DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]               DATETIME DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblTransposeApplyNowApplication] PRIMARY KEY CLUSTERED ([TransposeApplyNowApplicationID] ASC)
);


GO
CREATE TRIGGER [dbo].[tblTransposeApplyNowApplication_dss_update_trigger] ON [dbo].[tblTransposeApplyNowApplication] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 2029966308 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblTransposeApplyNowApplication_dss_tracking] AS [target] 
USING (SELECT [i].[TransposeApplyNowApplicationID] FROM INSERTED AS [i]) AS source([TransposeApplyNowApplicationID]) 
ON ([target].[TransposeApplyNowApplicationID] = [source].[TransposeApplyNowApplicationID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[TransposeApplyNowApplicationID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[TransposeApplyNowApplicationID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblTransposeApplyNowApplication_dss_insert_trigger] ON [dbo].[tblTransposeApplyNowApplication] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 2029966308 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblTransposeApplyNowApplication_dss_tracking] AS [target] 
USING (SELECT [i].[TransposeApplyNowApplicationID] FROM INSERTED AS [i]) AS source([TransposeApplyNowApplicationID]) 
ON ([target].[TransposeApplyNowApplicationID] = [source].[TransposeApplyNowApplicationID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[TransposeApplyNowApplicationID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[TransposeApplyNowApplicationID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblTransposeApplyNowApplication_dss_delete_trigger] ON [dbo].[tblTransposeApplyNowApplication] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 2029966308 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblTransposeApplyNowApplication_dss_tracking] AS [target] 
USING (SELECT [i].[TransposeApplyNowApplicationID] FROM DELETED AS [i]) AS source([TransposeApplyNowApplicationID]) 
ON ([target].[TransposeApplyNowApplicationID] = [source].[TransposeApplyNowApplicationID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[TransposeApplyNowApplicationID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[TransposeApplyNowApplicationID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );