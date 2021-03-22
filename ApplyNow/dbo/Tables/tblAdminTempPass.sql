CREATE TABLE [dbo].[tblAdminTempPass] (
    [AdminTempPassID]  INT          IDENTITY (1, 1) NOT NULL,
    [AdminUserID]      INT          NOT NULL,
    [Pass]             VARCHAR (60) NULL,
    [PasswordUsed]     BIT          NULL,
    [ExpirationDate]   DATETIME     NOT NULL,
    [PasswordUsedDate] DATETIME     NULL,
    [CreatedDate]      DATETIME     CONSTRAINT [DF_tblAdminTempPassCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME     CONSTRAINT [DF_tblAdminTempPassLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblAdminTempPass] PRIMARY KEY CLUSTERED ([AdminTempPassID] ASC),
    CONSTRAINT [FK_AdminTempPassUserID] FOREIGN KEY ([AdminUserID]) REFERENCES [dbo].[tblAdminUser] ([AdminUserId])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminTempPass].[AdminTempPassID]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminTempPass].[Pass]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminTempPass].[ExpirationDate]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credit Card', INFORMATION_TYPE_ID = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblAdminTempPass].[PasswordUsedDate]
    WITH (LABEL = 'Confidential', LABEL_ID = '34a8b4cd-07bb-4681-a104-04b974736123', INFORMATION_TYPE = 'Credentials', INFORMATION_TYPE_ID = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblAdminTempPass_dss_update_trigger] ON [dbo].[tblAdminTempPass] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 354100302 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminTempPass_dss_tracking] AS [target] 
USING (SELECT [i].[AdminTempPassID] FROM INSERTED AS [i]) AS source([AdminTempPassID]) 
ON ([target].[AdminTempPassID] = [source].[AdminTempPassID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminTempPassID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminTempPassID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblAdminTempPass_dss_insert_trigger] ON [dbo].[tblAdminTempPass] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 354100302 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminTempPass_dss_tracking] AS [target] 
USING (SELECT [i].[AdminTempPassID] FROM INSERTED AS [i]) AS source([AdminTempPassID]) 
ON ([target].[AdminTempPassID] = [source].[AdminTempPassID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminTempPassID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminTempPassID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

 



 
CREATE TRIGGER trg_tblAdminTempPassLastModifiedDate
ON [dbo].[tblAdminTempPass]
AFTER UPDATE
AS
    UPDATE [dbo].[tblAdminTempPass]
    SET [LastModifiedDate] = GETDATE()
    WHERE [AdminTempPassID] IN (SELECT [AdminTempPassID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblAdminTempPass_dss_delete_trigger] ON [dbo].[tblAdminTempPass] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 354100302 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblAdminTempPass_dss_tracking] AS [target] 
USING (SELECT [i].[AdminTempPassID] FROM DELETED AS [i]) AS source([AdminTempPassID]) 
ON ([target].[AdminTempPassID] = [source].[AdminTempPassID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[AdminTempPassID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[AdminTempPassID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );