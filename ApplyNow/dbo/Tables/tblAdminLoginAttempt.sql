﻿CREATE TABLE [dbo].[tblAdminLoginAttempt] (
    [AdminLoginAttemptID] INT            IDENTITY (1, 1) NOT NULL,
    [AdminUserID]         INT            NOT NULL,
    [Email]               NVARCHAR (75)  NULL,
    [SuccessFlag]         INT            NULL,
    [AttemptDate]         DATETIME       NULL,
    [AttemptMessage]      NVARCHAR (255) NULL,
    [CreatedDate]         DATETIME       CONSTRAINT [DF_tblAdminLoginAttemptCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME       CONSTRAINT [DF_tblAdminLoginAttemptLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AdminLoginAttemptID] PRIMARY KEY CLUSTERED ([AdminLoginAttemptID] ASC),
    CONSTRAINT [FK_AdminLoginAttemptUserID] FOREIGN KEY ([AdminUserID]) REFERENCES [dbo].[tblAdminUser] ([AdminUserId])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminLoginAttempt].[Email]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblAdminLoginAttempt_dss_delete_trigger] ON [dbo].[tblAdminLoginAttempt] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 322100188 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminLoginAttempt_dss_tracking] AS [target] 
USING (SELECT [i].[AdminLoginAttemptID] FROM DELETED AS [i]) AS source([AdminLoginAttemptID]) 
ON ([target].[AdminLoginAttemptID] = [source].[AdminLoginAttemptID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminLoginAttemptID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminLoginAttemptID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER trg_tblAdminLoginAttemptLastModifiedDate
ON [dbo].[tblAdminLoginAttempt]
AFTER UPDATE
AS
    UPDATE [dbo].[tblAdminLoginAttempt]
    SET [LastModifiedDate] = GETDATE()
    WHERE [AdminLoginAttemptID] IN (SELECT [AdminLoginAttemptID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblAdminLoginAttempt_dss_update_trigger] ON [dbo].[tblAdminLoginAttempt] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 322100188 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminLoginAttempt_dss_tracking] AS [target] 
USING (SELECT [i].[AdminLoginAttemptID] FROM INSERTED AS [i]) AS source([AdminLoginAttemptID]) 
ON ([target].[AdminLoginAttemptID] = [source].[AdminLoginAttemptID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminLoginAttemptID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminLoginAttemptID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblAdminLoginAttempt_dss_insert_trigger] ON [dbo].[tblAdminLoginAttempt] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 322100188 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminLoginAttempt_dss_tracking] AS [target] 
USING (SELECT [i].[AdminLoginAttemptID] FROM INSERTED AS [i]) AS source([AdminLoginAttemptID]) 
ON ([target].[AdminLoginAttemptID] = [source].[AdminLoginAttemptID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminLoginAttemptID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminLoginAttemptID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );