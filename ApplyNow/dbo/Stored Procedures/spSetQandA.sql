
CREATE procedure [dbo].[spSetQandA]
(
	@UserId int = NULL,
	@Question1 nvarchar(255) = NULL, 
    @Answer1 nvarchar(255) = NULL, 
    @Question2 nvarchar(255) = NULL, 
    @Answer2 nvarchar(255) = NULL, 
    @Question3 nvarchar(255) = NULL, 
    @Answer3 nvarchar(255) = NULL
) AS
BEGIN
/*************************************************
	Author:      Daniel Kelleher
	Create Date: 4/21/2020
	Description: Updates question, answer and change 
	date within the user table based on the values 
	passed within the parameters. 
*************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetQandA]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null
	DECLARE @Count int = 0

	set @Count = isnull((select 1 AS [Count] from tblUser tblU where tblU.UserID = @USerID),0)

	SET @Parameters = '@UserId ' + cast(@UserId as nvarchar) + 
	                  ' @Question1 ' + cast(@Question1 as nvarchar) + 
					  ' @Answer1 ' + cast(@Answer1 as nvarchar) +
					  ' @Question2 ' + cast(@Question2 as nvarchar) +
					  ' @Answer2 ' + cast(@Answer2 as nvarchar) +
					  ' @Question3 ' + cast(@Question3 as nvarchar) +
					  ' @Answer3 ' + cast(@Answer3 as nvarchar) +
					  ' @Count ' + cast(@Count as nvarchar) 

    IF isnull(@Question1,'') <> ''
		BEGIN
			BEGIN TRY

				UPDATE u
				SET [Question1] = @Question1,
					[Question1ChangeDate] = GETDATE()
				FROM dbo.tblUSER u
				WHERE u.[UserId] = @UserId
				and isnull([Question1],'') <> isnull(@Question1,'');

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

    IF isnull(@Answer1,'') <> ''
		BEGIN
			BEGIN TRY

				UPDATE u
				SET [Answer1] = @Answer1,
					[Answer1ChangeDate] = GETDATE()
				FROM dbo.tblUSER u
				WHERE u.[UserId] = @UserId
				and isnull([Answer1],'') <> isnull(@Answer1,'');

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

	IF isnull(@Question2,'') <> ''
		BEGIN
			BEGIN TRY

				UPDATE u
				SET [Question2] = @Question2,
					[Question2ChangeDate] = GETDATE()
				FROM dbo.tblUSER u
				WHERE u.[UserId] = @UserId
				and isnull([Question2],'') <> isnull(@Question2,'');

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

	IF isnull(@Answer2,'') <> ''
		BEGIN
			BEGIN TRY

				UPDATE u
				SET [Answer2] = @Answer2,
					[Answer2ChangeDate] = GETDATE()
				FROM dbo.tblUSER u
				WHERE u.[UserId] = @UserId
				and isnull([Answer2],'') <> isnull(@Answer2,'');

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

	IF isnull(@Question3,'') <> ''
		BEGIN
			BEGIN TRY

				UPDATE u
				SET [Question3] = @Question3,
					[Question3ChangeDate] = GETDATE()
				FROM dbo.tblUSER u
				WHERE u.[UserId] = @UserId
				and isnull([Question3],'') <> isnull(@Question3,'');

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

	IF isnull(@Answer3,'') <> ''
		BEGIN
			BEGIN TRY

				UPDATE u
				SET [Answer3] = @Answer3,
					[Answer3ChangeDate] = GETDATE()
				FROM dbo.tblUSER u
				WHERE u.[UserId] = @UserId
				and isnull([Answer3],'') <> isnull(@Answer3,'');

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

     SELECT @Count as [Success]

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END