
CREATE procedure   [dbo].[spSetPassword]
(
	@Email varchar(75) ,
	@Password varchar(60) 
) AS
BEGIN
	/*************************************************
	 Author:      Daniel Kelleher
	 Create Date: 4/21/2020
	 Description: Sets Users password.
	*************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPassword]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @ChangeDate datetime = GETDATE() ,
	        @UserID int = (select UserID from [dbo].[tblUser] where [Email] = @Email)

	SET @Parameters = '@Email ' + cast(@Email as nvarchar) + 
	                  ' @Password ' + cast(@Password as nvarchar) + 
					  ' @ChangeDate ' + cast(@ChangeDate as nvarchar) +
					  ' @UserID ' + cast(@UserID as nvarchar) 

	BEGIN
		BEGIN TRY

			UPDATE [dbo].[tblUser]
			SET Pass = @Password,
				PasswordChangeDate = @ChangeDate ,
				[Attempt] = 0
			WHERE [UserID] = @UserID

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

	BEGIN
		BEGIN TRY

			insert into [dbo].[tblPasswordReset]
			(UserId,
			Request_Date) 
			Values
			(@UserId
			,@ChangeDate)

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
	   
	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END