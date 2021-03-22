CREATE TABLE [dbo].[tblPerson] (
    [PersonID]         INT            IDENTITY (1, 1) NOT NULL,
    [BusinessName]     NVARCHAR (MAX) NULL,
    [FirstName]        NVARCHAR (MAX) NULL,
    [MiddleName]       NVARCHAR (MAX) NULL,
    [LastName]         NVARCHAR (MAX) NULL,
    [DOB]              DATE           NULL,
    [ResidentAlien]    BIT            NULL,
    [USCitizen]        BIT            NULL,
    [GenderTypeID]     INT            NOT NULL,
    [SSNTINTypeID]     INT            NOT NULL,
    [BirthStateID]     INT            NOT NULL,
    [IDNumber]         NVARCHAR (100) NULL,
    [SSNTIN]           NVARCHAR (100) NULL,
    [UUID]             NVARCHAR (250) NULL,
    [CreatedDate]      DATETIME       CONSTRAINT [DF_tblPersonCreatedDate] DEFAULT (getdate()) NOT NULL,
    [LastModifiedDate] DATETIME       CONSTRAINT [DF_tblPersonLastModifiedDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tblPerson] PRIMARY KEY CLUSTERED ([PersonID] ASC),
    CONSTRAINT [FK_PersonBirthStateID] FOREIGN KEY ([BirthStateID]) REFERENCES [dbo].[tblState] ([StateID]),
    CONSTRAINT [FK_PersonGenderTypeID] FOREIGN KEY ([GenderTypeID]) REFERENCES [dbo].[tblGenderType] ([GenderTypeID]),
    CONSTRAINT [FK_PersonSSNTINTypeID] FOREIGN KEY ([SSNTINTypeID]) REFERENCES [dbo].[tblSSNTINType] ([SSNTINTypeID])
);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPerson].[FirstName]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '989ADC05-3F3F-0588-A635-F475B994915B', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22F5-9659-15B24AEB125E', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPerson].[LastName]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '989ADC05-3F3F-0588-A635-F475B994915B', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22F5-9659-15B24AEB125E', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPerson].[DOB]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '989ADC05-3F3F-0588-A635-F475B994915B', INFORMATION_TYPE = 'Date Of Birth', INFORMATION_TYPE_ID = '3DE7CC52-710D-4E96-7E20-4D5188D2590C', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [dbo].[tblPerson].[IDNumber]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '989ADC05-3F3F-0588-A635-F475B994915B', INFORMATION_TYPE = 'National ID', INFORMATION_TYPE_ID = '6F5A11A7-08B1-19C3-59E5-8C89CF4F8444', RANK = MEDIUM);


GO
CREATE TRIGGER [dbo].[tblPerson_dss_insert_trigger] ON [dbo].[tblPerson] FOR INSERT AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 882102183 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPerson_dss_tracking] AS [target] 
USING (SELECT [i].[PersonID] FROM INSERTED AS [i]) AS source([PersonID]) 
ON ([target].[PersonID] = [source].[PersonID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonID],NULL, NULL, NULL, 0, CAST(@@DBTS AS BIGINT) + 1, NULL, 0, 0, GETDATE() );
GO
CREATE TRIGGER [dbo].[tblPerson_dss_update_trigger] ON [dbo].[tblPerson] FOR UPDATE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 882102183 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPerson_dss_tracking] AS [target] 
USING (SELECT [i].[PersonID] FROM INSERTED AS [i]) AS source([PersonID]) 
ON ([target].[PersonID] = [source].[PersonID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 0, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 0, GETDATE() );
GO

CREATE TRIGGER trg_tblPersonLastModifiedDate
ON [dbo].[tblPerson]
AFTER UPDATE
AS
    UPDATE [dbo].[tblPerson]
    SET [LastModifiedDate] = GETDATE()
    WHERE [PersonID] IN (SELECT [PersonID] FROM Inserted);
GO
CREATE TRIGGER [dbo].[tblPerson_dss_delete_trigger] ON [dbo].[tblPerson] FOR DELETE AS
SET NOCOUNT ON
DECLARE @marker_create_scope_local_id INT
DECLARE @marker_scope_create_peer_timestamp BIGINT
DECLARE @marker_scope_create_peer_key INT
DECLARE @marker_local_create_peer_timestamp BIGINT
DECLARE @marker_local_create_peer_key INT
DECLARE @marker_state INT
SELECT TOP 1 @marker_create_scope_local_id = [provision_scope_local_id], @marker_local_create_peer_timestamp = [provision_timestamp], @marker_local_create_peer_key = [provision_local_peer_key], @marker_scope_create_peer_timestamp = [provision_scope_peer_timestamp], @marker_scope_create_peer_key = [provision_scope_peer_key], @marker_state = [state]
FROM [DataSync].[provision_marker_dss]
WHERE [object_id] = 882102183 
 AND [owner_scope_local_id] = 0

MERGE [DataSync].[tblPerson_dss_tracking] AS [target] 
USING (SELECT [i].[PersonID] FROM DELETED AS [i]) AS source([PersonID]) 
ON ([target].[PersonID] = [source].[PersonID])
WHEN MATCHED THEN
UPDATE SET [sync_row_is_tombstone] = 1, 
[local_update_peer_key] = 0, 
[update_scope_local_id] = NULL, [last_change_datetime] = GETDATE()
WHEN NOT MATCHED THEN
INSERT (
[PersonID] ,
[create_scope_local_id], [scope_create_peer_key], [scope_create_peer_timestamp], [local_create_peer_key], [local_create_peer_timestamp], [update_scope_local_id], [local_update_peer_key], [sync_row_is_tombstone], [last_change_datetime]) 
VALUES (
[source].[PersonID],@marker_create_scope_local_id, @marker_scope_create_peer_key, @marker_scope_create_peer_timestamp, 0, @marker_local_create_peer_timestamp , NULL, 0, 1, GETDATE() );