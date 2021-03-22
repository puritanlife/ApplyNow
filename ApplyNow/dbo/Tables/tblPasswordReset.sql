CREATE TABLE [dbo].[tblPasswordReset] (
    [PasswordResetId]  INT      IDENTITY (1, 1) NOT NULL,
    [UserId]           INT      NOT NULL,
    [Request_Date]     DATETIME NOT NULL,
    [PasswordUsedDate] DATETIME NULL,
    [PasswordUsed]     BIT      NULL,
    [CreatedDate]      DATETIME CONSTRAINT [DF_tblPasswordResetCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME CONSTRAINT [DF_tblPasswordResetLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPasswordReset] PRIMARY KEY CLUSTERED ([PasswordResetId] ASC),
    CONSTRAINT [FK_PasswordReset_UserID] FOREIGN KEY ([UserId]) REFERENCES [dbo].[tblUser] ([UserId])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPasswordReset].[PasswordResetId]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPasswordReset].[PasswordUsedDate]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblPasswordReset_dss_insert_trigger] ON [dbo].[tblPasswordReset] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 786101841 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPasswordReset_dss_tracking] AS [target] 
USING (SELECT [i].[PasswordResetId] FROM INSERTED AS [i]) AS source([PasswordResetId]) 
ON ([target].[PasswordResetId] = [source].[PasswordResetId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PasswordResetId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PasswordResetId],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

 
CREATE TRIGGER trg_tblPasswordResetLastModifiedDate
ON [dbo].[tblPasswordReset]
AFTER UPDATE
AS
    UPDATE [dbo].[tblPasswordReset]
    SET [LastModifiedDate] = GETDATE()
    WHERE [PasswordResetId] IN (SELECT [PasswordResetId] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblPasswordReset_dss_delete_trigger] ON [dbo].[tblPasswordReset] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 786101841 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPasswordReset_dss_tracking] AS [target] 
USING (SELECT [i].[PasswordResetId] FROM DELETED AS [i]) AS source([PasswordResetId]) 
ON ([target].[PasswordResetId] = [source].[PasswordResetId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PasswordResetId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PasswordResetId],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblPasswordReset_dss_update_trigger] ON [dbo].[tblPasswordReset] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 786101841 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPasswordReset_dss_tracking] AS [target] 
USING (SELECT [i].[PasswordResetId] FROM INSERTED AS [i]) AS source([PasswordResetId]) 
ON ([target].[PasswordResetId] = [source].[PasswordResetId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PasswordResetId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PasswordResetId],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );