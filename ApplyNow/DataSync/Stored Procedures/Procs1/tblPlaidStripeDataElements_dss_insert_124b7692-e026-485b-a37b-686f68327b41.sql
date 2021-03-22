CREATE PROCEDURE [DataSync].[tblPlaidStripeDataElements_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 Bit,
	@P_4 NVarChar(250),
	@P_5 Float,
	@P_6 Int,
	@P_7 DateTime,
	@P_8 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblPlaidStripeDataElements] WHERE [PlaidStripeDataElementsID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblPlaidStripeDataElements_dss_tracking] WHERE [PlaidStripeDataElementsID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblPlaidStripeDataElements] ON; INSERT INTO [dbo].[tblPlaidStripeDataElements]([PlaidStripeDataElementsID], [ApplyNowID], [Charged], [PlaidStripeID], [PaymentAmount], [PaymentMethodTypeID], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblPlaidStripeDataElements] OFF; END 
END