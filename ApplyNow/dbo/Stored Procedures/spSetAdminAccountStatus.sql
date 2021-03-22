

CREATE procedure [dbo].[spSetAdminAccountStatus]
(
	@Pass varchar(75) = NULL
) AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: Returns an integer that represents the status of an admin account.  For every time
	            this procedure is called, the Admin Temp Pass [tblAdminTempPass] table is updated 
				with Password used value. 
				0 = Account found & not locked UserID and Password are returned.
	            1 = Account found & locked UserID is returned.
	            2 = Account not found
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetAdminAccountStatus]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	Declare @count int
	Set @count = (SELECT COUNT(*) FROM [dbo].[tblAdminTempPass] u with(nolock) 
	              WHERE u.[Pass] = @Pass
				  AND (u.[PasswordUsed] = 0 AND getdate() <= [ExpirationDate]))

	DECLARE @Parameters nvarchar(max) = '@Pass ' + cast(@Pass as nvarchar)+' @count ' + cast(@count as nvarchar)

	BEGIN
		BEGIN TRY

			update [dbo].[tblAdminTempPass]
			set [PasswordUsed] = 1
			, [PasswordUsedDate] = getdate()
			WHERE [Pass] = @Pass
			and @count = 1

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

	Select @count AS [Success]
	
	set @Output = '@Success ' + cast(@count as nvarchar)
	SET @Message = @Message + 'Inserts and updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END