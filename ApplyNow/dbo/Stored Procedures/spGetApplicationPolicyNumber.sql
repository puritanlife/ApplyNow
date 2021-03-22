

CREATE PROCEDURE [dbo].[spGetApplicationPolicyNumber]
(
    @ApplicationID [int] null
   ,@PolicyNum [nvarchar](100) NULL
)
AS
BEGIN
/*************************************************
  Author:      Poonam Kushwaha
  Create Date: 11/2/2020
  Description: Returns an application's policy number, purchase date, term, product, premium.. 
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetApplicationPolicyNumber]' 
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
	DECLARE @Parameters nvarchar(max) = '@ApplicationID ' + cast(@ApplicationID as nvarchar) +
									    '@PolicyNum ' + cast(@PolicyNum as nvarchar)

	SELECT tblA.[ApplicationID]
		  ,tblA.[CanvasPolicyNumber]
		  ,CONVERT(VARCHAR(10),tblA.[CreatedDate],110) as [CreatedDate]
		  ,tblA.[StateID]
		  ,tblA.[Premium]
		  ,tblPlT.[Type] aS [PlanType]
		  ,tblPrT.[Type]
		  ,tblPrT.[Descr]
	FROM [dbo].[tblApplication] tblA with(nolock)
	left outer join [dbo].[tblProductPlanPeriod] tblPPP with(nolock) on tblPPP.[ProductPlanPeriodID] = tblA.[ProductPlanPeriodID]
	left outer join [dbo].[tblPlanType] tblPlT with(nolock) on tblPlT.[PlanTypeID] = tblPPP.[PlanTypeID]
	left outer join [dbo].[tblPeriodType] tblPrT with(nolock) on tblPrT.[PeriodTypeID] = tblPPP.[PeriodTypeID]
	where isnull(tblA.[ApplicationID],'') = isnull(@ApplicationID, tblA.[ApplicationID])
	and isnull(tblA.[CanvasPolicyNumber],'') = isnull(@PolicyNum, tblA.[CanvasPolicyNumber])
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