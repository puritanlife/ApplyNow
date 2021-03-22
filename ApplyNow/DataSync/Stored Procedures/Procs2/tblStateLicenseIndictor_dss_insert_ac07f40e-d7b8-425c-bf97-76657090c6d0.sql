CREATE PROCEDURE [DataSync].[tblStateLicenseIndictor_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 DateTime,
	@P_5 DateTime,
	@P_6 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblStateLicenseIndictor] WHERE [StateLicenseIndictorID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblStateLicenseIndictor_dss_tracking] WHERE [StateLicenseIndictorID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblStateLicenseIndictor] ON; INSERT INTO [dbo].[tblStateLicenseIndictor]([StateLicenseIndictorID], [StateID], [StateLicenseTypeID], [EffectiveDate], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblStateLicenseIndictor] OFF; END 
END