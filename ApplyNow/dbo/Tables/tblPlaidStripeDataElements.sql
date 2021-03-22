CREATE TABLE [dbo].[tblPlaidStripeDataElements] (
    [PlaidStripeDataElementsID] INT            IDENTITY (1, 1) NOT NULL,
    [ApplyNowID]                INT            NOT NULL,
    [Charged]                   BIT            NULL,
    [PlaidStripeID]             NVARCHAR (250) NULL,
    [PaymentAmount]             FLOAT (53)     NULL,
    [PaymentMethodTypeID]       INT            NOT NULL,
    [CreatedDate]               DATETIME       CONSTRAINT [DF_tblPlaidStripeDataElementsCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate]          DATETIME       CONSTRAINT [DF_tblPlaidStripeDataElementsLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPlaidStripeDataElementsID] PRIMARY KEY CLUSTERED ([PlaidStripeDataElementsID] ASC),
    CONSTRAINT [FK_PlaidStripeDataElementsApplyNowID] FOREIGN KEY ([ApplyNowID]) REFERENCES [dbo].[tblApplyNow] ([ApplyNowID]),
    CONSTRAINT [FK_PlaidStripeDataElementsPaymentMethodTypeID] FOREIGN KEY ([PaymentMethodTypeID]) REFERENCES [dbo].[tblPaymentMethodType] ([PaymentMethodTypeID])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPlaidStripeDataElements].[PaymentAmount]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Financial', INFORMATION_TYPE_ID = 'C44193E1-0E58-4B2A-9001-F7D6E7BC1373', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPlaidStripeDataElements].[PaymentMethodTypeID]
    WITH (LABEL = 'Confidential', LABEL_ID = '331F0B13-76B5-2F1B-A77B-DEF5A73C73C2', INFORMATION_TYPE = 'Financial', INFORMATION_TYPE_ID = 'C44193E1-0E58-4B2A-9001-F7D6E7BC1373', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblPlaidStripeDataElements_dss_update_trigger] ON [dbo].[tblPlaidStripeDataElements] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1042102753 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPlaidStripeDataElements_dss_tracking] AS [target] 
USING (SELECT [i].[PlaidStripeDataElementsID] FROM INSERTED AS [i]) AS source([PlaidStripeDataElementsID]) 
ON ([target].[PlaidStripeDataElementsID] = [source].[PlaidStripeDataElementsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PlaidStripeDataElementsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PlaidStripeDataElementsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblPlaidStripeDataElements_dss_insert_trigger] ON [dbo].[tblPlaidStripeDataElements] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1042102753 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPlaidStripeDataElements_dss_tracking] AS [target] 
USING (SELECT [i].[PlaidStripeDataElementsID] FROM INSERTED AS [i]) AS source([PlaidStripeDataElementsID]) 
ON ([target].[PlaidStripeDataElementsID] = [source].[PlaidStripeDataElementsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PlaidStripeDataElementsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PlaidStripeDataElementsID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER [dbo].[trg_tblPlaidStripeDataElementsLastModifiedDate]
ON [dbo].[tblPlaidStripeDataElements]
AFTER UPDATE
AS
    UPDATE [dbo].[tblPlaidStripeDataElements]
    SET [LastModifiedDate] = GETDATE()
    WHERE [PlaidStripeDataElementsID] IN (SELECT [PlaidStripeDataElementsID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblPlaidStripeDataElements_dss_delete_trigger] ON [dbo].[tblPlaidStripeDataElements] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 1042102753 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPlaidStripeDataElements_dss_tracking] AS [target] 
USING (SELECT [i].[PlaidStripeDataElementsID] FROM DELETED AS [i]) AS source([PlaidStripeDataElementsID]) 
ON ([target].[PlaidStripeDataElementsID] = [source].[PlaidStripeDataElementsID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PlaidStripeDataElementsID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PlaidStripeDataElementsID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );