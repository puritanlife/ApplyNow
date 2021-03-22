
CREATE procedure [dbo].[spSetUserEmailReset]
(
    @OldEmail	varchar(75) ,
	@NewEmail	varchar(75) ,
	@Token	varchar(60) 
)
AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: Updates user (tblUser) and email reset (tblEmailReset) tables. 
*************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetUserEmailReset]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	Declare @Result int = 0

	SET @Parameters = '@OldEmail ' + cast(@OldEmail as nvarchar) + 
	                  ' @NewEmail ' + cast(@NewEmail as nvarchar) + 
					  ' @Token ' + cast(@Token as nvarchar)
	
	BEGIN
		BEGIN TRY

			update [dbo].[tblUser]
			set [Email] = @NewEmail
			where [Email] = @OldEmail

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

			update [dbo].[tblEmailReset]
			set [UsedToken] = 1
			where [OldEmail] = @OldEmail
			and [NewEmail] = @NewEmail
			and [Token] = @Token

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

    set @Result = isnull((select [UsedToken]
    from [dbo].[tblEmailReset]
	where [OldEmail] = @OldEmail
	and [NewEmail] = @NewEmail
	and [Token] = @Token),0)

	select @Result As [Success]

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END