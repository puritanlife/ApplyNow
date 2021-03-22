
CREATE procedure [dbo].[spSetLoginAttempt]
(
	@Email varchar(75) = NULL
) AS
BEGIN
	/*************************************************
	 Author:      Daniel Kelleher
	 Create Date: 4/21/2020
	 Description: Inserts a record into tblLogin_Attempt table. 
	*************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetLoginAttempt]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @count int ,
	        @AccountStatus int

	SET @count = (SELECT COUNT(*) FROM dbo.tblUSER u with(nolock) WHERE u.Email = @Email)
	
    SET @AccountStatus = (CASE WHEN @count > 0 
	                           THEN (SELECT u.locked FROM dbo.tblUser u with(nolock) WHERE u.Email = @Email) 
			                   ELSE 2 END)

	SET @Parameters = '@Email ' + cast(@Email as nvarchar) + 
	                  ' @count ' + cast(@count as nvarchar) + 
					  ' @AccountStatus ' + cast(@AccountStatus as nvarchar)

	BEGIN
		BEGIN TRY


			INSERT INTO [dbo].[tblLoginAttempt]
						([UserID]
						,[Email]
						,[SuccessFlag]
						,[AttemptDate]
						,[AttemptMessage])
						(SELECT (SELECT u.UserID FROM dbo.tblUSER u with(nolock) WHERE u.Email = @Email) AS [UserID]
						, @Email                                                            AS [Email]
						, @AccountStatus                                                    AS [SuccessFlag]
						, getdate()                                                         AS [AttemptDate]
						, case when @AccountStatus = 0 then 'Account found & not locked.'
								when @AccountStatus = 1 then 'Account found & locked.'
								when @AccountStatus = 2 then 'Account not found. ' end      AS [AttemptMessage])

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