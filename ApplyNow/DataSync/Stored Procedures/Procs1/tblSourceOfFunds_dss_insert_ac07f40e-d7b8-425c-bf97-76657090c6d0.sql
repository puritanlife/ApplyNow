CREATE PROCEDURE [DataSync].[tblSourceOfFunds_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 Bit,
	@P_5 Int,
	@P_6 Bit,
	@P_7 Bit,
	@P_8 Bit,
	@P_9 Int,
	@P_10 DateTime,
	@P_11 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblSourceOfFunds] WHERE [SourceOfFundsID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblSourceOfFunds_dss_tracking] WHERE [SourceOfFundsID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblSourceOfFunds] ON; INSERT INTO [dbo].[tblSourceOfFunds]([SourceOfFundsID], [ApplicationID], [FundsTypeID], [Contribution], [ContributionYear], [Transfer], [Rollover], [Conversion], [ConversionYear], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblSourceOfFunds] OFF; END 
END