




CREATE PROCEDURE [dbo].[spSetACHToken]
(
	    @ACHTokenID int = null,
		@ACHTokenNumber [nvarchar](1000)NULL,
		@AppID [nvarchar](100) NULL
     
)
AS
BEGIN
/*************************************************
  Author:      Poonam K
  Create Date: 11/23/2020
  Description: Inserts a ACHToken  Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetACHToken]' 
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

	if @ACHTokenNumber is null 
		set @ACHTokenNumber = 0

	if @AppID is null 
		set @AppID = 0	


    set @Record_Exists = isnull((select 'Yes' from [dbo].[tblACHToken] tblACH with(nolock) where isnull(tblACH.[AppID],'') = isnull(@AppID,'')),'No')

	SET @Parameters = ' @ACHTokenNumber ' + cast(@ACHTokenNumber as nvarchar) + 
	                  ' @AppID ' + cast(@AppID as nvarchar) + 
	                  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblACHToken]
					([ACHTokenNumber]
					  ,[AppID]
					 )
				VALUES
					(@ACHTokenNumber				-- Token
					,@AppID		-- AppID
					)	

						SET @ACHTokenID = isnull((SELECT [ACHTokenID]
											FROM [dbo].[tblACHToken] with(nolock)
											where isnull([ACHTokenNumber],'') = isnull(@ACHTokenNumber,'')
											and isnull([AppID],'') = isnull(@AppID,'')),0)
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

				update [dbo].[tblACHToken]
				set [ACHTokenNumber] = @ACHTokenNumber
					,[AppID] = @AppID
					,[LastModifiedDate] = getdate()
				where [AppID] = @AppID;

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

	SET @ACHTokenID = isnull((SELECT [ACHTokenID]
											FROM [dbo].[tblACHToken] with(nolock)
											where isnull([ACHTokenNumber],'') = isnull(@ACHTokenNumber,'')
											and isnull([AppID],'') = isnull(@AppID,'')),0)


	SELECT @ACHTokenID AS [ACHTokenID]
	set @Output = '@ACHTokenID ' + cast(@ACHTokenID as nvarchar)
	

	SET @Message = @Message + 'Inserts or updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END