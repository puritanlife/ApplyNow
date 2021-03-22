
CREATE procedure [dbo].[spSetUnlockAccount]
(
	@UserId int = null,
	@Email varchar(75) = null
) AS
BEGIN
/*************************************************
    Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: Unlocks a user by setting the locked 
	            and Attempt fields to 0.
*************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetUnlockAccount]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null

	SET @Parameters = '@UserId ' + cast(@UserId as nvarchar) + 
	                  ' @Email ' + cast(@Email as nvarchar) 

	BEGIN
		BEGIN TRY

			UPDATE u SET
				u.locked = 0,
				u.Attempt = 0
			FROM dbo.tblUSER		AS u with(nolock)
			WHERE u.[UserID] = isnull(@UserId, u.[UserID] )
			AND  u.[Email] = isnull(@Email, u.[Email] )

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

			INSERT INTO [dbo].[tblUnlockAttempt]
			(
				 [UserID]
				,[Email]
				,[SuccessFlag]
				,[AttemptDate]
				,[AttemptMessage]
			)
			SELECT
				 u.UserId                   -- [UserID]
				,u.Email                    -- [Email]
				,1                          -- [SuccessFlag]
				,GETDATE()                  -- [AttemptDate]
				,'Unlocked user account.'   -- [AttemptMessage]
			FROM dbo.tblUSER u with(nolock)
			WHERE u.[UserID] = isnull(@UserId, u.[UserID] )
			AND  u.[Email] = isnull(@Email, u.[Email] )	

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