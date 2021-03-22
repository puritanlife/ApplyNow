CREATE PROCEDURE [DataSync].[tblDocuSignDataElements_dss_insert_124b7692-e026-485b-a37b-686f68327b41]
	@P_1 Int,
	@P_2 Int,
	@P_3 Bit,
	@P_4 DateTime,
	@P_5 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblDocuSignDataElements] WHERE [DocuSignDataElementsID] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblDocuSignDataElements_dss_tracking] WHERE [DocuSignDataElementsID] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblDocuSignDataElements] ON; INSERT INTO [dbo].[tblDocuSignDataElements]([DocuSignDataElementsID], [ApplyNowID], [Signature], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblDocuSignDataElements] OFF; END 
END