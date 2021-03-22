
CREATE procedure [dbo].[spSetUser]
(
    @UserID int null ,
	@PersonID int null ,
	@UserTypeID int null ,
    @Email varchar(75) null ,
    @Pass varchar(60) null ,
    @Attempt int null ,
    @locked bit null ,
    @Last_Login datetime null ,
    @IsAdmin bit null ,
    @PasswordChangeDate datetime null ,
    @Question1 varchar(255) null ,
    @Answer1 varchar(255) null ,
    @Question2 varchar(255) null ,
    @Answer2 varchar(255) null ,
    @Question3 varchar(255) null ,
    @Answer3 varchar(255) null ,
    @Question1ChangeDate datetime null ,
    @Answer1ChangeDate datetime null ,
    @Question2ChangeDate datetime null ,
    @Answer2ChangeDate datetime null ,
    @Question3ChangeDate datetime null ,
    @Answer3ChangeDate datetime null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/21/2020
  Description: Inserts a User Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetUser]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @Record_Exists nvarchar(3) = 'No'

	if @UserID is null 
		set @UserID = isnull(@UserID,-99);

	if @PersonID is null 
		set @PersonID = isnull(@PersonID,-99);

	if @UserTypeID is null 
		set @UserTypeID = isnull(@UserTypeID,-99);

    if @Email is null 
		set @Email = isnull(@Email,'');

	if @Pass is null 
		set @Pass = isnull(@Pass,'');

	if @Attempt is null 
		set @Attempt = isnull(@Attempt,0);

    if @locked is null 
		set @locked = isnull(@locked,0);

	if @Last_Login is null 
		set @Last_Login = isnull(@Last_Login,getdate());

	if @IsAdmin is null 
		set @IsAdmin = isnull(@IsAdmin,0);

    if @PasswordChangeDate is null 
		set @PasswordChangeDate = null;
		
	if @Question1 is null 
		set @Question1 = isnull(@Question1,'');
		
	if @Answer1 is null 
		set @Answer1 = isnull(@Answer1,'');
				
	if @Question2 is null 
		set @Question2 = isnull(@Question2,'');
		
	if @Answer2 is null 
		set @Answer2 = isnull(@Answer2,'');
				
	if @Question3 is null 
		set @Question3 = isnull(@Question3,'');
		
	if @Answer3 is null 
		set @Answer3 = isnull(@Answer3,'');

	if @Question1ChangeDate is null 
		set @Question1ChangeDate = null;

	if @Answer1ChangeDate is null 
		set @Answer1ChangeDate = null;
		
	if @Question2ChangeDate is null 
		set @Question2ChangeDate = null;

    if @Answer2ChangeDate is null 
		set @Answer2ChangeDate = null;

	if @Question3ChangeDate is null 
		set @Question3ChangeDate = null;

	if @Answer3ChangeDate is null 
		set @Answer3ChangeDate = null;

	set @Record_Exists = isnull((select 'Yes' from [dbo].[tblUser] with(nolock) where PersonID = @PersonID and UserTypeID = @UserTypeID),'No')

	SET @Parameters = '@UserID ' + cast(@UserID as nvarchar) + 
	                  ' @PersonID ' + cast(@PersonID as nvarchar) + 
	                  ' @UserTypeID ' + cast(@UserTypeID as nvarchar) + 
	                  ' @Email ' + cast(@Email as nvarchar) + 
	                  ' @Pass ' + cast(@Pass as nvarchar) + 
	                  ' @Attempt ' + cast(@Attempt as nvarchar) + 
	                  ' @locked ' + cast(@locked as nvarchar) + 
	                  ' @Last_Login ' + cast(@Last_Login as nvarchar) + 
	                  ' @IsAdmin ' + cast(@IsAdmin as nvarchar) + 
	                  ' @PasswordChangeDate ' + cast(@PasswordChangeDate as nvarchar) + 
	                  ' @Question1 ' + cast(@Question1 as nvarchar) + 
	                  ' @Answer1 ' + cast(@Answer1 as nvarchar) + 
	                  ' @Question2 ' + cast(@Question2 as nvarchar) + 
	                  ' @Answer2 ' + cast(@Answer2 as nvarchar) + 
	                  ' @Question3 ' + cast(@Question3 as nvarchar) + 
	                  ' @Answer3 ' + cast(@Answer3 as nvarchar) + 
	                  ' @Question1ChangeDate ' + cast(@Question1ChangeDate as nvarchar) + 
	                  ' @Answer1ChangeDate ' + cast(@Answer1ChangeDate as nvarchar) + 
	                  ' @Question2ChangeDate ' + cast(@Question2ChangeDate as nvarchar) + 
	                  ' @Answer2ChangeDate ' + cast(@Answer2ChangeDate as nvarchar) + 
	                  ' @Question3ChangeDate ' + cast(@Question3ChangeDate as nvarchar) + 
	                  ' @Answer3ChangeDate ' + cast(@Answer3ChangeDate as nvarchar) + 
	                  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)
	
	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblUser]
								   ([PersonID]
								   ,[UserTypeID]
								   ,[Email]
								   ,[Pass]
								   ,[Attempt]
								   ,[locked]
								   ,[Last_Login]
								   ,[IsAdmin]
								   ,[PasswordChangeDate]
								   ,[Question1]
								   ,[Answer1]
								   ,[Question2]
								   ,[Answer2]
								   ,[Question3]
								   ,[Answer3]
								   ,[Question1ChangeDate]
								   ,[Answer1ChangeDate]
								   ,[Question2ChangeDate]
								   ,[Answer2ChangeDate]
								   ,[Question3ChangeDate]
								   ,[Answer3ChangeDate])
							 VALUES
								   (@PersonID 					--  PersonID 
								   ,@UserTypeID 				--  UserTypeID 
								   ,@Email 						--  Email 
								   ,@Pass 						--  Pass 
								   ,@Attempt 					--  Attempt 
								   ,@locked 					--  locked 
								   ,@Last_Login  				--  Last_Login 
								   ,@IsAdmin  					--  IsAdmin 
								   ,@PasswordChangeDate  		--  PasswordChangeDate 
								   ,@Question1  				--  Question1 
								   ,@Answer1  					--  Answer1 
								   ,@Question2 					--  Question2 
								   ,@Answer2 					--  Answer2 
								   ,@Question3 					--  Question3 
								   ,@Answer3 					--  Answer3 
								   ,@Question1ChangeDate 		--  Question1ChangeDate 
								   ,@Answer1ChangeDate 			--  Answer1ChangeDate 
								   ,@Question2ChangeDate 		--  Question2ChangeDate 
								   ,@Answer2ChangeDate 			--  Answer2ChangeDate 
								   ,@Question3ChangeDate 		--  Question3ChangeDate 
								   ,@Answer3ChangeDate);		--  Answer3ChangeDate 	

			END TRY
			BEGIN CATCH  

				SELECT  
					@ErrorNumber = ERROR_NUMBER()
				,@ErrorSeverity = ERROR_SEVERITY()
				,@ErrorState = ERROR_STATE()
				,@ErrorProcedure = ERROR_PROCEDURE()
				,@ErrorMessage = ERROR_MESSAGE();

				EXEC [maint].[spSetLogCatchingErrors]
				@ErrorNumber = @ErrorNumber,
				@ErrorSeverity = @ErrorSeverity,
				@ErrorState = @ErrorState,
				@ErrorProcedure = @Procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorParameters = @Parameters

			END CATCH;  

		END;

	if @Record_Exists = 'Yes'
		BEGIN
			BEGIN TRY

				Update [dbo].[tblUser]
				set [PersonID]				= @PersonID
				   ,[UserTypeID]			= @UserTypeID
				   ,[Email]					= @Email
				   ,[Pass]					= @Pass
				   ,[Attempt]				= @Attempt
				   ,[locked]				= @locked
				   ,[Last_Login]			= @Last_Login
				   ,[IsAdmin]				= @IsAdmin
				   ,[PasswordChangeDate]	= @PasswordChangeDate
				   ,[Question1]				= @Question1
				   ,[Answer1]				= @Answer1
				   ,[Question2]				= @Question2
				   ,[Answer2]				= @Answer2
				   ,[Question3]				= @Question3
				   ,[Answer3]				= @Answer3
				   ,[Question1ChangeDate]	= @Question1ChangeDate
				   ,[Answer1ChangeDate]		= @Answer1ChangeDate
				   ,[Question2ChangeDate]	= @Question2ChangeDate
				   ,[Answer2ChangeDate]		= @Answer2ChangeDate
				   ,[Question3ChangeDate]	= @Question3ChangeDate
				   ,[Answer3ChangeDate]		= @Answer3ChangeDate
				where UserID = @UserID and PersonID = @PersonID and UserTypeID = @UserTypeID; 

			END TRY
			BEGIN CATCH  

				SELECT  
					@ErrorNumber = ERROR_NUMBER()
				,@ErrorSeverity = ERROR_SEVERITY()
				,@ErrorState = ERROR_STATE()
				,@ErrorProcedure = ERROR_PROCEDURE()
				,@ErrorMessage = ERROR_MESSAGE();

				EXEC [maint].[spSetLogCatchingErrors]
				@ErrorNumber = @ErrorNumber,
				@ErrorSeverity = @ErrorSeverity,
				@ErrorState = @ErrorState,
				@ErrorProcedure = @Procedure,
				@ErrorMessage = @ErrorMessage,
				@ErrorParameters = @Parameters

			END CATCH;  

		END;

	set @UserID = (select [UserID] from [dbo].[tblUser] with(nolock) where PersonID = @PersonID and UserTypeID = @UserTypeID)
	select @UserID AS 'UserID'

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall
	
END