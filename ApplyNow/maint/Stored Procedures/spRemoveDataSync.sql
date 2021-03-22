

CREATE procedure [maint].[spRemoveDataSync]
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/30/2020
  Description: Deletes an ApplyNow Record.
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[maint].[spRemoveDataSync]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	declare @n char(1)
	set @n = char(10)

	declare @triggers nvarchar(max)
	declare @procedures nvarchar(max)
	declare @constraints nvarchar(max)
	declare @FKs nvarchar(max)
	declare @tables nvarchar(max)
	declare @udt nvarchar(max)

	-- triggers
	select @triggers = isnull( @triggers + @n, '' ) + 'drop trigger [' + schema_name(schema_id) + '].[' + name + ']'
	from sys.objects
	where type in ( 'TR') and name like '%_dss_%'

	-- procedures
	select @procedures = isnull( @procedures + @n, '' ) + 'drop procedure [' + schema_name(schema_id) + '].[' + name + ']'
	from sys.procedures
	where schema_name(schema_id) = 'dss' or schema_name(schema_id) = 'TaskHosting' or schema_name(schema_id) = 'DataSync'

	-- check constraints
	select @constraints = isnull( @constraints + @n, '' ) + 'alter table [' + schema_name(schema_id) + '].[' + object_name( parent_object_id ) + ']    drop constraint [' + name + ']'
	from sys.check_constraints
	where schema_name(schema_id) = 'dss' or schema_name(schema_id) = 'TaskHosting' or schema_name(schema_id) = 'DataSync'

	-- foreign keys
	select @FKs = isnull( @FKs + @n, '' ) + 'alter table [' + schema_name(schema_id) + '].[' + object_name( parent_object_id ) + '] drop constraint [' + name + ']'
	from sys.foreign_keys
	where schema_name(schema_id) = 'dss' or schema_name(schema_id) = 'TaskHosting' or schema_name(schema_id) = 'DataSync'

	-- tables
	select @tables = isnull( @tables + @n, '' ) + 'drop table [' + schema_name(schema_id) + '].[' + name + ']'
	from sys.tables
	where schema_name(schema_id) = 'dss' or schema_name(schema_id) = 'TaskHosting' or schema_name(schema_id) = 'DataSync'

	-- user defined types
	select @udt = isnull( @udt + @n, '' ) + 'drop type [' + schema_name(schema_id) + '].[' + name + ']'
	from sys.types
	where is_user_defined = 1
	and schema_name(schema_id) = 'dss' or schema_name(schema_id) = 'TaskHosting' or schema_name(schema_id) = 'DataSync'
	order by system_type_id desc

	print @triggers
	print @procedures 
	print @constraints 
	print @FKs 
	print @tables
	print @udt 

	exec sp_executesql @triggers
	exec sp_executesql @procedures 
	exec sp_executesql @constraints 
	exec sp_executesql @FKs 
	exec sp_executesql @tables
	exec sp_executesql @udt 

	declare @functions nvarchar(max)

	-- functions
	select @functions = isnull( @functions + @n, '' ) + 'drop function [' + schema_name(schema_id) + '].[' + name + ']'
	from sys.objects
	where type in ( 'FN', 'IF', 'TF' )
	and schema_name(schema_id) = 'dss' or schema_name(schema_id) = 'TaskHosting' or schema_name(schema_id) = 'DataSync'

	print @functions 
	exec sp_executesql @functions 

	DROP SCHEMA IF EXISTS [dss]
	DROP SCHEMA IF EXISTS [TaskHosting]
	DROP SCHEMA IF EXISTS [DataSync]
	DROP USER IF EXISTS [##MS_SyncAccount##]
	DROP USER IF EXISTS [##MS_SyncResourceManager##]
	DROP ROLE IF EXISTS [DataSync_admin]
	DROP ROLE IF EXISTS [DataSync_executor]
	DROP ROLE IF EXISTS [DataSync_reader]

	--symmetric_keys
	declare @symmetric_keys nvarchar(max)
	select @symmetric_keys = isnull( @symmetric_keys + @n, '' ) + 'drop symmetric key [' + name + ']'
	from sys.symmetric_keys
	where name like 'DataSyncEncryptionKey%'

	print @symmetric_keys 
	exec sp_executesql @symmetric_keys 

	-- certificates
	declare @certificates nvarchar(max)
	select @certificates = isnull( @certificates + @n, '' ) + 'drop certificate [' + name + ']'
	from sys.certificates
	where name like 'DataSyncEncryptionCertificate%'

	print @certificates 
	exec sp_executesql @certificates 

	print 'Data Sync clean up finished' 

	-- Triggers
	DECLARE @TRIGGERS_SQL VARCHAR(MAX) = (
		SELECT
			'DROP TRIGGER [' + SCHEMA_NAME(so.uid) + '].[' +  [so].[name] + '] ' 
			FROM sysobjects AS [so]
			INNER JOIN sysobjects AS so2 ON so.parent_obj = so2.Id
			WHERE   [so].[type] = 'TR'
			AND     [so].name LIKE '%_dss_%_trigger'
		FOR XML PATH ('')
	)
	PRINT @TRIGGERS_SQL
	IF LEN(@TRIGGERS_SQL) > 0
	BEGIN
		EXEC (@TRIGGERS_SQL)
	END     


	-- Tables
	DECLARE @TABLES_SQL VARCHAR(MAX) = (
		SELECT
			'DROP TABLE [' + table_schema + '].[' + table_name + '] ' 
		FROM 
			information_schema.tables where table_schema in ('DataSync','dss','TaskHosting')
		FOR XML PATH ('')
	)
	PRINT @TABLES_SQL
	IF LEN(@TABLES_SQL) > 0
	BEGIN
		EXEC (@TABLES_SQL)
	END    

	-- Stored Procedures
	DECLARE @PROC_SQL VARCHAR(MAX) = (
		SELECT 'DROP PROCEDURE [' + routine_schema + '].[' + routine_name + '] ' 
		FROM    INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA in ('DataSync','dss','TaskHosting') and routine_type = 'PROCEDURE'
		FOR XML PATH ('')
	)
	PRINT @PROC_SQL
	IF LEN(@PROC_SQL) > 0
	BEGIN
		EXEC (@PROC_SQL)
	END    


	-- Types
	DECLARE @TYPE_SQL VARCHAR(MAX) = (
	  SELECT
	  'DROP TYPE [' + SCHEMA_NAME(so.uid) + '].[' + [so].[name] + '] ' 
	  FROM systypes AS [so]
	  where [so].name LIKE '%_dss_bulktype%'
	  AND SCHEMA_NAME(so.uid) in ('DataSync','dss','TaskHosting')
	  FOR XML PATH ('')
	)
	PRINT @TYPE_SQL
	IF LEN(@TYPE_SQL) > 0
	BEGIN
	  EXEC (@TYPE_SQL)
	END    


	-- Schema
	DROP SCHEMA DataSync  


    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = 'None',
		@Output = @Output,
		@StartSPCall = @StartSPCall

END