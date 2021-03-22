
CREATE procedure [dbo].[spGetProductPlanPeriod]
(
    @ProductTypeID [int] Null,
    @PlanTypeID [int] Null,
    @PeriodTypeID [int] Null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/29/2020
  Description: Returns all data within the Address Type table. 
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetProductPlanPeriod]' 
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

	SET @Parameters = '@ProductTypeID ' + cast(@ProductTypeID as nvarchar) + ' @PlanTypeID ' + cast(@PlanTypeID as nvarchar) + ' @PeriodTypeID ' + cast(@PeriodTypeID as nvarchar)

	SELECT tblPPP.[ProductPlanPeriodID] AS [ProductPlanPeriodID]
		  ,tblPPP.[ProductTypeID]		AS [ProductTypeID]
		  ,tblPdT.[Descr]				AS [ProductDescr]
		  ,tblPPP.[PlanTypeID]			AS [PlanTypeID]
		  ,tblPnT.[Descr]				AS [PlanDescr]
		  ,tblPPP.[PeriodTypeID]		AS [PeriodTypeID]
		  ,tblPrT.[Descr]				AS [PeriodDescr]
		  ,tblPPP.[PremMin]				AS [PremMin]
		  ,tblPPP.[PremMax]				AS [PremMax]
		  ,tblPPP.[CreditingRate]		AS [CreditingRate]
	  FROM [dbo].[tblProductPlanPeriod] tblPPP with(nolock)
	  inner join [dbo].[tblProductType] tblPdT with(nolock) on tblPdT.[ProductTypeID] = tblPPP.[ProductTypeID]
	  inner join [dbo].[tblPlanType] tblPnT with(nolock) on tblPnT.[PlanTypeID] = tblPPP.[PlanTypeID]
	  inner join [dbo].[tblPeriodType] tblPrT with(nolock) on tblPrT.[PeriodTypeID] = tblPPP.[PeriodTypeID]
	  where tblPPP.[EffectiveDate] = (select max(tblPPP1.[EffectiveDate])
									  from [dbo].[tblProductPlanPeriod] tblPPP1 with(nolock)
									  where tblPPP1.[ProductTypeID] = tblPPP.[ProductTypeID]
									  and tblPPP1.[PlanTypeID] = tblPPP.[PlanTypeID]
									  and tblPPP1.[PeriodTypeID] = tblPPP.[PeriodTypeID]
									  and tblPPP1.[EffectiveDate] <= getdate())
      and isnull(tblPPP.[ProductTypeID],'') = isnull(@ProductTypeID,tblPPP.[ProductTypeID])
      and isnull(tblPPP.[PlanTypeID],'') = isnull(@PlanTypeID,tblPPP.[PlanTypeID])
      and isnull(tblPPP.[PeriodTypeID],'') = isnull(@PeriodTypeID,tblPPP.[PeriodTypeID])
	  order by tblPPP.[ProductTypeID] asc, tblPPP.[PlanTypeID] asc, tblPPP.[PeriodTypeID] asc
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