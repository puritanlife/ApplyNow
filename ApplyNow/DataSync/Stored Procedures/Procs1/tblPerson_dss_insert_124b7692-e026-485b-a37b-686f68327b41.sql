CREATE PROCEDURE [DataSync].[tblPerson_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 NVarChar(max),
	@P_5 NVarChar(max),
	@P_6 Date,
	@P_7 Bit,
	@P_8 Bit,
	@P_9 Int,
	@P_10 Int,
	@P_11 Int,
	@P_12 NVarChar(100),
	@P_13 NVarChar(100),
	@P_14 NVarChar(250),
	@P_15 DateTime,
	@P_16 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblPerson] WHERE [PersonID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblPerson_dss_tracking] WHERE [PersonID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblPerson] ON; INSERT INTO [dbo].[tblPerson]([PersonID], [BusinessName], [FirstName], [MiddleName], [LastName], [DOB], [ResidentAlien], [USCitizen], [GenderTypeID], [SSNTINTypeID], [BirthStateID], [IDNumber], [SSNTIN], [UUID], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblPerson] OFF; END 
END