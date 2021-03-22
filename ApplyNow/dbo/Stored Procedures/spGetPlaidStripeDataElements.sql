
CREATE procedure [dbo].[spGetPlaidStripeDataElements]
(
    @PlaidStripeDataElementsID [int] null,
    @ApplyNowID [int] null,
	@ApplicationID [int] null,
	@PersonID [int] null, 
	@Charged [bit] null,
    @PaymentMethodTypeID [int] null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/5/2020
  Description: Returns all person's associated with application data. 
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetPlaidStripeDataElements]' 
	DECLARE @Error nvarchar(max) = null 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 
	DECLARE @SP_RowCount int = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Parameters nvarchar(max) = null

	SET @Parameters = '@PlaidStripeDataElementsID ' + cast(@PlaidStripeDataElementsID as nvarchar) + 
	                  ' @ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
	                  ' @ApplicationID ' + cast(@ApplicationID as nvarchar) + 
	                  ' @PersonID ' + cast(@PersonID as nvarchar) + 
	                  ' @Charged ' + cast(@Charged as nvarchar) + 
					  ' @PaymentMethodTypeID ' + cast(@PaymentMethodTypeID as nvarchar)

	SELECT tPSDE.[PlaidStripeDataElementsID]	as	 [PlaidStripeDataElementsID]
		  ,tPSDE.[ApplyNowID]					as	 [ApplyNowID]
		  ,tblAN.[ApplicationID]				as   [ApplicationID]
		  ,tblAN.[PersonID]						as   [PersonID]
		  ,tPSDE.[Charged]						as	 [Charged]
		  ,tPSDE.[PlaidStripeID]				as	 [PlaidStripeID]
		  ,tPSDE.[PaymentAmount]				as	 [PaymentAmount]
		  ,tPSDE.[PaymentMethodTypeID]			as	 [PaymentMethodTypeID]
		  ,tblPMT.[Type]						as	 [PaymentMethodType]
		  ,tblPMT.[Descr]						as	 [PaymentMethodTypeDescr]
	  FROM [dbo].[tblPlaidStripeDataElements] tPSDE with(nolock)
	  inner join [dbo].[tblPaymentMethodType] tblPMT with(nolock) on tPSDE.[PaymentMethodTypeID] = tblPMT.[PaymentMethodTypeID]
	  inner join [dbo].[tblApplyNow] tblAN with(nolock) on tPSDE.[ApplyNowID] = tblAN.[ApplyNowID] 
	  where tblAN.PersonTypeID = 6
	  and isnull(tPSDE.[PlaidStripeDataElementsID],'') = isnull(@PlaidStripeDataElementsID, tPSDE.[PlaidStripeDataElementsID])
	  and isnull(tPSDE.[ApplyNowID],'') = isnull(@ApplyNowID, tPSDE.[ApplyNowID])
	  and isnull(tblAN.[ApplicationID],'') = isnull(@ApplicationID, tblAN.[ApplicationID])
	  and isnull(tblAN.[PersonID],'') = isnull(@PersonID, tblAN.[PersonID])
	  and isnull(tPSDE.[Charged],'') = isnull(@Charged,tPSDE.[Charged])
	  and isnull(tPSDE.[PaymentMethodTypeID],'') = isnull(@PaymentMethodTypeID, tPSDE.[PaymentMethodTypeID])
	SET @SP_RowCount = @@ROWCOUNT;

	SET @Message = @Message + 'Select only, not inserts or updates. '
	SET @Output = @Output + 'Record Count ' + cast(@SP_RowCount as varchar)

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END