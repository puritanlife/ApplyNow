CREATE TABLE [dbo].[tblExistingPolicy] (
    [ExistingPolicyID] INT            IDENTITY (1, 1) NOT NULL,
    [ApplyNowID]       INT            NOT NULL,
    [PolicyNumber]     NVARCHAR (255) NULL,
    [IssueDate]        DATE           NULL,
    [CarrierID]        INT            NOT NULL,
    [ChangePolicies]   BIT            NULL,
    [ExistingPolicies] BIT            NULL,
    [CreatedDate]      DATETIME       CONSTRAINT [DF_tblExistingPolicyCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME       CONSTRAINT [DF_tblExistingPolicyLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblExistingPolicyID] PRIMARY KEY CLUSTERED ([ExistingPolicyID] ASC),
    CONSTRAINT [FK_ExistingPolicyApplyNowID] FOREIGN KEY ([ApplyNowID]) REFERENCES [dbo].[tblApplyNow] ([ApplyNowID]),
    CONSTRAINT [FK_ExistingPolicyCarrierID] FOREIGN KEY ([CarrierID]) REFERENCES [dbo].[tblPerson] ([PersonID])
);


GO
CREATE TRIGGER [dbo].[tblExistingPolicy_dss_delete_trigger] ON [dbo].[tblExistingPolicy] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 594101157 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblExistingPolicy_dss_tracking] AS [target] 
USING (SELECT [i].[ExistingPolicyID] FROM DELETED AS [i]) AS source([ExistingPolicyID]) 
ON ([target].[ExistingPolicyID] = [source].[ExistingPolicyID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ExistingPolicyID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ExistingPolicyID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO

 
CREATE TRIGGER trg_tblExistingPolicyLastModifiedDate
ON [dbo].[tblExistingPolicy]
AFTER UPDATE
AS
    UPDATE [dbo].[tblExistingPolicy]
    SET [LastModifiedDate] = GETDATE()
    WHERE [ExistingPolicyID] IN (SELECT [ExistingPolicyID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblExistingPolicy_dss_update_trigger] ON [dbo].[tblExistingPolicy] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 594101157 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblExistingPolicy_dss_tracking] AS [target] 
USING (SELECT [i].[ExistingPolicyID] FROM INSERTED AS [i]) AS source([ExistingPolicyID]) 
ON ([target].[ExistingPolicyID] = [source].[ExistingPolicyID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ExistingPolicyID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ExistingPolicyID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblExistingPolicy_dss_insert_trigger] ON [dbo].[tblExistingPolicy] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 594101157 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblExistingPolicy_dss_tracking] AS [target] 
USING (SELECT [i].[ExistingPolicyID] FROM INSERTED AS [i]) AS source([ExistingPolicyID]) 
ON ([target].[ExistingPolicyID] = [source].[ExistingPolicyID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[ExistingPolicyID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[ExistingPolicyID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );