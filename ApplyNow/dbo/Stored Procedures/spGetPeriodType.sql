
CREATE procedure [dbo].[spGetPeriodType]
(
    @TypeID [int] Null,
    @Type nvarchar(3) Null,
    @Descr nvarchar(255) Null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 4/21/2020
  Description: Returns all data within the Period Type table. 
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetPeriodType]' 
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

	SET @Parameters = '@TypeID ' + cast(@TypeID as nvarchar) + ' @Type ' + cast(@Type as nvarchar) + ' @Descr ' + cast(@Descr as nvarchar)

	SELECT 
	  tblT.[PeriodTypeID] as [TypeID]
	, tblT.[Type] as [Type]
	, tblT.[Descr] as [Descr]
	FROM [dbo].[tblPeriodType] tblT with(nolock) 
	where isnull(tblT.[PeriodTypeID],'') = isnull(@TypeID,tblT.[PeriodTypeID])
	and isnull(tblT.[Type],'') = isnull(@Type,tblT.[Type])
	and isnull(tblT.[Descr],'') = isnull(@Descr,tblT.[Descr])
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