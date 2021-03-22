
CREATE procedure [dbo].[spSetAdminTempPassUsage]
(
	 @AdminUserID int = NULL
) AS
BEGIN
	/*************************************************
	 Author:      Daniel Kelleher
	 Create Date: 4/20/2020
	 Description: Updates Password Used and Password Used 
	                Date value within tblAdminTempPass table 
					and updated locked, last login and attempt 
					values within the tblAdminUser table. 
	*************************************************/
	   
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetAdminTempPassUsage]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Record_Exists nvarchar(3) = 'No'
	DECLARE @UsedDate datetime = GETDATE()
	DECLARE @Parameters nvarchar(max) = '@AdminUserID ' + cast(@AdminUserID as nvarchar)

	BEGIN
		BEGIN TRY

			UPDATE u
				SET PasswordUsed = 1 ,
				[PasswordUsedDate] = @UsedDate
			FROM [dbo].[tblAdminTempPass] AS u
			where u.AdminUserID = @AdminUserID
			and @UsedDate <= [ExpirationDate];

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
		BEGIN TRY

			UPDATE s
				SET [locked] = 0 ,
				[Last_Login] = @UsedDate ,
			[Attempt] = 0
			FROM [dbo].[tblAdminUser] AS s
			where s.AdminUserID = @AdminUserID;

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

	set @Output = '@AdminUserID ' + cast(@AdminUserID as nvarchar)
	SET @Message = @Message + 'Inserts and updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END