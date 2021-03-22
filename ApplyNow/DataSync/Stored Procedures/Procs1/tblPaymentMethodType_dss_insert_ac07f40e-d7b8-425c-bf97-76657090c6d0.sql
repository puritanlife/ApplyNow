﻿CREATE PROCEDURE [DataSync].[tblPaymentMethodType_dss_insert_ac07f40e-d7b8-425c-bf97-76657090c6d0]
	@P_1 Int,
	@P_2 NVarChar(max),
	@P_3 NVarChar(max),
	@P_4 DateTime,
	@P_5 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblPaymentMethodType] WHERE [PaymentMethodTypeID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblPaymentMethodType_dss_tracking] WHERE [PaymentMethodTypeID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblPaymentMethodType] ON; INSERT INTO [dbo].[tblPaymentMethodType]([PaymentMethodTypeID], [Type], [Descr], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblPaymentMethodType] OFF; END 
END