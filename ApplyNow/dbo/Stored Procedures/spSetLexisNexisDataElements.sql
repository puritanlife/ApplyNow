
CREATE procedure [dbo].[spSetLexisNexisDataElements]
(
    @LexisNexisDataElementsID [int] null ,
    @LexisNexisCallTypeID [int] null ,
	@ApplyNowID [int] null ,
    @ConversationID [bigint] null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/12/2020
  Description: Inserts a Lexis Nexis Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetLexisNexisDataElements]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Record_Exists nvarchar(3) = 'No'

	if @LexisNexisDataElementsID is null 
		set @LexisNexisDataElementsID = isnull(@LexisNexisDataElementsID,-99)

	if @LexisNexisCallTypeID is null 
		set @LexisNexisCallTypeID = isnull(@LexisNexisCallTypeID,-99)

	if @ApplyNowID is null 
		set @ApplyNowID = isnull(@ApplyNowID,-99)

	if @ConversationID is null 
		set @ConversationID = isnull(@ConversationID,'-99')

	--if @ConversationID is null 
	--	set @ConversationID = isnull(@ConversationID,0)
					
	if @LexisNexisDataElementsID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblLexisNexisDataElements] with(nolock) where isnull([LexisNexisDataElementsID],'') = isnull(@LexisNexisDataElementsID,'')),'No');

	DECLARE @Parameters nvarchar(max) = '@LexisNexisDataElementsID ' + cast(@LexisNexisDataElementsID as nvarchar) + 
	                                    ' @LexisNexisCallTypeID ' + cast(@LexisNexisCallTypeID as nvarchar) +
	                                    ' @ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
										' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblLexisNexisDataElements]
					([LexisNexisCallTypeID]
					,[ApplyNowID]
					,[ConversationID])
				VALUES
					(@LexisNexisCallTypeID	-- LexisNexisCallTypeID
					,@ApplyNowID			-- ApplyNowID
					,@ConversationID)		-- ConversationID

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
		END

	if @Record_Exists = 'Yes'
		BEGIN
			BEGIN TRY

				Update [dbo].[tblLexisNexisDataElements]
					set [LexisNexisCallTypeID] = @LexisNexisCallTypeID
					,[ApplyNowID] = @ApplyNowID
					,[ConversationID] = @ConversationID
				where [LexisNexisDataElementsID] = @LexisNexisDataElementsID

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

	set @LexisNexisDataElementsID = isnull((select cast([LexisNexisDataElementsID] as nvarchar) 
	                                        from [dbo].[tblLexisNexisDataElements] with(nolock) 
	                                        where [LexisNexisCallTypeID] = @LexisNexisCallTypeID 
											and [ApplyNowID] = @ApplyNowID 
											and [ConversationID] = @ConversationID),-99);

	select @LexisNexisDataElementsID as [LexisNexisDataElementsID];
	set @Output = '@LexisNexisDataElementsID ' + cast(@LexisNexisDataElementsID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END