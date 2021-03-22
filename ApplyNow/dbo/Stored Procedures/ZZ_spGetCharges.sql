

CREATE PROCEDURE [dbo].[ZZ_spGetCharges]

AS
BEGIN
/*************************************************
  Author:      Poonam Kushwaha
  Create Date: 11/24/2020
  Description: Returns all data within the Charges & Payout Schedule table. 
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetUserType]' 
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

	--SET @Parameters = '@ChargeID ' + cast(@ChargeID as int) + ' @BalanceTransactionID ' + cast(@BalanceTransactionID as nvarchar) 

	SELECT 
	   tblCR.[ChargeID]
      ,tblCR.[Status]
      ,tblCR.[StripeChargeID]
      ,CONVERT(VARCHAR(20), tblCR.[ChargeDate], 23) as ChargeDate
	  ,CONVERT(VARCHAR(20), tblCR.[ChargeSuccessDate], 23) as ChargeSuccessDate
	  ,CONVERT(VARCHAR(20), tblCR.[ChargeFailureDate], 23) as ChargeFailureDate
      ,tblCR.[ChargeFailureReason]
      ,cast(tblCR.[Amount] as int) as Amount
	  ,tblPS.[PayoutScheduleID]
      ,tblPS.[PolicyNumber]
      ,tblPS.[StripePayoutID]
      ,tblPS.[BalanceTransactionID]      
  	FROM [dbo].[tblCharge] tblCR with(nolock) 
	INNER JOIN [dbo].[tblPayoutSchedule] tblPS with(nolock)
	on tblCR.[StripeChargeID] = tblPS.[StripeChargeID] 
	where isnull(tblCR.[Status],'') = 'Charged-Succeeded' AND tblPS.[StripePayoutID] IS NULL
	ORDER BY tblCR.[CreatedDate] ASC;


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