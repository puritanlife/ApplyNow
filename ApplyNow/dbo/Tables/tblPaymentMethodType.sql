CREATE TABLE [dbo].[tblPaymentMethodType] (
    [PaymentMethodTypeID] INT            IDENTITY (1, 1) NOT NULL,
    [Type]                NVARCHAR (MAX) NULL,
    [Descr]               NVARCHAR (MAX) NULL,
    [CreatedDate]         DATETIME       CONSTRAINT [DF_tblPaymentMethodTypeCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]    DATETIME       CONSTRAINT [DF_tblPaymentMethodTypeLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPaymentMethodType] PRIMARY KEY CLUSTERED ([PaymentMethodTypeID] ASC)
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPaymentMethodType].[PaymentMethodTypeID]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Financial', INFORMATION_TYPE_ID = 'C44193E1-0E58-4B2A-9001-F7D6E7BC1373', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblPaymentMethodType_dss_update_trigger] ON [dbo].[tblPaymentMethodType] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 818101955 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPaymentMethodType_dss_tracking] AS [target] 
USING (SELECT [i].[PaymentMethodTypeID] FROM INSERTED AS [i]) AS source([PaymentMethodTypeID]) 
ON ([target].[PaymentMethodTypeID] = [source].[PaymentMethodTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PaymentMethodTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PaymentMethodTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblPaymentMethodTypeLastModifiedDate
ON [dbo].[tblPaymentMethodType]
AFTER UPDATE
AS
    UPDATE [dbo].[tblPaymentMethodType]
    SET [LastModifiedDate] = GETDATE()
    WHERE [PaymentMethodTypeID] IN (SELECT [PaymentMethodTypeID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblPaymentMethodType_dss_delete_trigger] ON [dbo].[tblPaymentMethodType] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 818101955 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPaymentMethodType_dss_tracking] AS [target] 
USING (SELECT [i].[PaymentMethodTypeID] FROM DELETED AS [i]) AS source([PaymentMethodTypeID]) 
ON ([target].[PaymentMethodTypeID] = [source].[PaymentMethodTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PaymentMethodTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PaymentMethodTypeID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblPaymentMethodType_dss_insert_trigger] ON [dbo].[tblPaymentMethodType] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 818101955 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPaymentMethodType_dss_tracking] AS [target] 
USING (SELECT [i].[PaymentMethodTypeID] FROM INSERTED AS [i]) AS source([PaymentMethodTypeID]) 
ON ([target].[PaymentMethodTypeID] = [source].[PaymentMethodTypeID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PaymentMethodTypeID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PaymentMethodTypeID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );