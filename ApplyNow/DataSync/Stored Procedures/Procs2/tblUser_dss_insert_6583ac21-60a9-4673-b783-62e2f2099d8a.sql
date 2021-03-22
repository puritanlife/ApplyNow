CREATE PROCEDURE [DataSync].[tblUser_dss_insert_6583ac21-60a9-4673-b783-62e2f2099d8a]
	@P_1 Int,
	@P_2 Int,
	@P_3 Int,
	@P_4 VarChar(75),
	@P_5 VarChar(60),
	@P_6 Int,
	@P_7 Bit,
	@P_8 DateTime,
	@P_9 Bit,
	@P_10 DateTime,
	@P_11 VarChar(255),
	@P_12 VarChar(255),
	@P_13 VarChar(255),
	@P_14 VarChar(255),
	@P_15 VarChar(255),
	@P_16 VarChar(255),
	@P_17 DateTime,
	@P_18 DateTime,
	@P_19 DateTime,
	@P_20 DateTime,
	@P_21 DateTime,
	@P_22 DateTime,
	@P_23 DateTime,
	@P_24 DateTime,
	@sync_row_count Int OUTPUT
AS
BEGIN
SET @sync_row_count = 0; IF (NOT EXISTS (SELECT * FROM [dbo].[tblUser] WHERE [UserId] = @P_1)
 AND NOT EXISTS (SELECT * FROM [DataSync].[tblUser_dss_tracking] WHERE [UserId] = @P_1)
)
BEGIN 
SET IDENTITY_INSERT [dbo].[tblUser] ON; INSERT INTO [dbo].[tblUser]([UserId], [PersonID], [UserTypeID], [Email], [Pass], [Attempt], [locked], [Last_Login], [IsAdmin], [PasswordChangeDate], [Question1], [Answer1], [Question2], [Answer2], [Question3], [Answer3], [Question1ChangeDate], [Answer1ChangeDate], [Question2ChangeDate], [Answer2ChangeDate], [Question3ChangeDate], [Answer3ChangeDate], [CreatedDate], [LastModifiedDate]) VALUES (@P_1, @P_2, @P_3, @P_4, @P_5, @P_6, @P_7, @P_8, @P_9, @P_10, @P_11, @P_12, @P_13, @P_14, @P_15, @P_16, @P_17, @P_18, @P_19, @P_20, @P_21, @P_22, @P_23, @P_24);  SET @sync_row_count = @@rowcount; SET IDENTITY_INSERT [dbo].[tblUser] OFF; END 
END