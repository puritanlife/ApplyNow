
CREATE procedure [dbo].[spSetPlaidStripeCharged]
(
    @CanvasPolicyNumber nvarchar(100) null,
    @Charged [bit] null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/19/2020
  Description: Inserts a Plaid Stripe Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetPlaidStripeCharged]' 
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
	DECLARE @PlaidStripeDataElementsID [int] = null

	if @Charged is null 
		set @Charged = 0

    if @CanvasPolicyNumber <> '-99'
		BEGIN
		  set @Record_Exists = isnull((select 'Yes'  
										from [dbo].[tblApplication] tblA with(nolock)
										inner join [dbo].[tblApplyNow] tblAN with(nolock) on tblAN.[ApplicationID] = tblA.[ApplicationID]
																						  and tblAN.[PersonTypeID] = 6
										inner join [dbo].[tblPlaidStripeDataElements] tblLN with(nolock) on tblLN.[ApplyNowID] = tblAN.[ApplyNowID]
										where isnull(tblA.[CanvasPolicyNumber],'') = isnull(@CanvasPolicyNumber,'')),'No')

		  set @PlaidStripeDataElementsID = isnull((select tblLN.[PlaidStripeDataElementsID]
										from [dbo].[tblApplication] tblA with(nolock)
										inner join [dbo].[tblApplyNow] tblAN with(nolock) on tblAN.[ApplicationID] = tblA.[ApplicationID]
																						  and tblAN.[PersonTypeID] = 6
										inner join [dbo].[tblPlaidStripeDataElements] tblLN with(nolock) on tblLN.[ApplyNowID] = tblAN.[ApplyNowID]
										where isnull(tblA.[CanvasPolicyNumber],'') = isnull(@CanvasPolicyNumber,'')),-99)
		END

	SET @Parameters = '@PlaidStripeDataElementsID ' + cast(@PlaidStripeDataElementsID as nvarchar) + 
	                  ' @CanvasPolicyNumber ' + cast(@CanvasPolicyNumber as nvarchar) + 
	                  ' @Charged ' + cast(@Charged as nvarchar) + 
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'Yes'
		BEGIN
			BEGIN TRY

				update [dbo].[tblPlaidStripeDataElements]
				set [Charged] = @Charged
				where isnull([PlaidStripeDataElementsID],'') = isnull(@PlaidStripeDataElementsID,'');

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

	SELECT @PlaidStripeDataElementsID AS [PlaidStripeDataElementsID]
	set @Output = '@PlaidStripeDataElementsID ' + cast(@PlaidStripeDataElementsID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

	EXEC [maint].[spSetLogStoredProcedureCalls]
	@Procedure = @Procedure,
	@Message = @Message,
	@Parameters = @Parameters,
	@Output = @Output,
	@StartSPCall = @StartSPCall

END