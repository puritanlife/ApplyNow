
CREATE procedure [dbo].[spSetAdminTempPass]
(
	@Email varchar(75) ,
	@Password varchar(60) 
) AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: Sets Admins Temp to access customer portal.
*************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetAdminTempPass]' 
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
	        @AdminUserID int = (select AdminUserID from [dbo].[tblAdminUser] with(nolock) where [Email] = @Email)
			
	SET @Parameters = '@Email ' + cast(@Email as nvarchar) + 
	                  ' @Password ' + cast(@Password as nvarchar) +
					  ' @ChangeDate ' + cast(@ChangeDate as nvarchar) +
					  ' @AdminUserID ' + cast(@AdminUserID as nvarchar) 

	BEGIN
		BEGIN TRY

			INSERT INTO [dbo].[tblAdminTempPass]
				([AdminUserID]
				,[Pass]
				,[PasswordUsed]
				,[ExpirationDate])
			Values
				(@AdminUserID                 -- [AdminUserID]
				,@Password                    -- [Pass]
				,0                            -- [PasswordUsed]
				,dateadd(minute, 20, @ChangeDate)) -- [ExpirationDate]

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