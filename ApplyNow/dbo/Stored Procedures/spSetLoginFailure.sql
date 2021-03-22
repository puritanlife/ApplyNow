
CREATE procedure [dbo].[spSetLoginFailure]
(
	@UserId int
) AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: This is called after a failed login attempt. It updates the attempt counter,
				conditionally sets the locked flag, then returns the new value of the lock flag:
				0 = Not Locked
				1 = Locked
*************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetLoginFailure]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null

	SET @Parameters = '@UserId ' + cast(@UserId as nvarchar) 

	BEGIN
		BEGIN TRY

			UPDATE dbo.tblUSER SET
				Attempt = Attempt + 1
			WHERE UserId = @UserId

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

			UPDATE dbo.tblUSER SET
				locked = 1
			WHERE UserId = @UserId
				AND Attempt >= 5

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

	SELECT
       u.[Attempt]
      ,u.[locked] As [Locked]
	FROM dbo.tblUSER u with(nolock)
	WHERE UserId = @UserId

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END