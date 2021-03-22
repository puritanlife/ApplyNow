CREATE TABLE [dbo].[tblAdminUser] (
    [AdminUserId]        INT          IDENTITY (1, 1) NOT NULL,
    [Email]              VARCHAR (75) NOT NULL,
    [Pass]               VARCHAR (60) NOT NULL,
    [Attempt]            INT          NULL,
    [locked]             BIT          NOT NULL,
    [Last_Login]         DATETIME     NULL,
    [PasswordChangeDate] DATETIME     NULL,
    [CreatedDate]        DATETIME     CONSTRAINT [DF_tblAdminUserCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]   DATETIME     CONSTRAINT [DF_tblAdminUserLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_AdminUsers] PRIMARY KEY CLUSTERED ([AdminUserId] ASC),
    UNIQUE NONCLUSTERED ([Email] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminUser].[Email]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminUser].[Pass]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminUser].[PasswordChangeDate]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblAdminUser_dss_update_trigger] ON [dbo].[tblAdminUser] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 386100416 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminUser_dss_tracking] AS [target] 
USING (SELECT [i].[AdminUserId] FROM INSERTED AS [i]) AS source([AdminUserId]) 
ON ([target].[AdminUserId] = [source].[AdminUserId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminUserId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminUserId],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblAdminUser_dss_insert_trigger] ON [dbo].[tblAdminUser] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 386100416 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminUser_dss_tracking] AS [target] 
USING (SELECT [i].[AdminUserId] FROM INSERTED AS [i]) AS source([AdminUserId]) 
ON ([target].[AdminUserId] = [source].[AdminUserId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminUserId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminUserId],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO


 
CREATE TRIGGER trg_tblAdminUserLastModifiedDate
ON [dbo].[tblAdminUser]
AFTER UPDATE
AS
    UPDATE [dbo].[tblAdminUser]
    SET [LastModifiedDate] = GETDATE()
    WHERE [AdminUserId] IN (SELECT [AdminUserId] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblAdminUser_dss_delete_trigger] ON [dbo].[tblAdminUser] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 386100416 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminUser_dss_tracking] AS [target] 
USING (SELECT [i].[AdminUserId] FROM DELETED AS [i]) AS source([AdminUserId]) 
ON ([target].[AdminUserId] = [source].[AdminUserId])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminUserId] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminUserId],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );