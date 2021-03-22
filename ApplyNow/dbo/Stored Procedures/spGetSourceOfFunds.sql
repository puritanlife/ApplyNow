
CREATE procedure [dbo].[spGetSourceOfFunds]
(
    @SourceOfFundsID [int] null ,
	@ApplicationID [int] null ,
    @FundsTypeID [int] null ,
    @Contribution [bit] null ,
    @ContributionYear [int] null ,
    @Transfer [bit] null ,
    @Rollover [bit] null ,
    @Conversion [bit] null ,
    @ConversionYear [int] null,
	@Qualified nvarchar(50) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/12/2020
  Description: Inserts a Source Of Funds Data Elements Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetSourceOfFunds]' 
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
	DECLARE @Record_Exists nvarchar(3) = 'No'
	DECLARE @Parameters nvarchar(max) = null

	SET @Parameters = '@ApplicationID ' + cast(@ApplicationID as nvarchar) + 
	                  ' @FundsTypeID ' + cast(@FundsTypeID as nvarchar) + 
	                  ' @Contribution ' + cast(@Contribution as nvarchar) + 
	                  ' @ContributionYear ' + cast(@ContributionYear as nvarchar) + 
	                  ' @Transfer ' + cast(@Transfer as nvarchar) + 
	                  ' @Rollover ' + cast(@Rollover as nvarchar) + 
	                  ' @Conversion ' + cast(@Conversion as nvarchar) + 
					  ' @ConversionYear ' + cast(@ConversionYear as nvarchar) +
					  ' @Record_Exists '  + cast(@Record_Exists as nvarchar)
	
		SELECT 
			 tblS.[SourceOfFundsID] AS [SourceOfFundsID]
			,tblS.[ApplicationID] AS [ApplicationID]
			,tblS.[FundsTypeID] AS [FundsTypeID]
			,tblF.[Type] AS [Type]
			,tblF.[Descr] AS [Descr]
			,tblS.[Contribution] AS [Contribution]
			,tblS.[ContributionYear] AS [ContributionYear]
			,tblS.[Transfer] AS [Transfer]
			,tblS.[Rollover] AS [Rollover]
			,tblS.[Conversion] AS [Conversion]
			,tblS.[ConversionYear] AS [ConversionYear]
		FROM [dbo].[tblSourceOfFunds] tblS with(nolock)
		inner join [dbo].[tblFundsType] tblF with(nolock) on tblF.[FundsTypeID] = tblS.[FundsTypeID]
		where isnull(tblS.[SourceOfFundsID],'') = isnull(@SourceOfFundsID,tblS.[SourceOfFundsID])
		and isnull(tblS.[ApplicationID],'') = isnull(@ApplicationID,tblS.[ApplicationID])
		and isnull(tblS.[FundsTypeID],'') = isnull(@FundsTypeID,tblS.[FundsTypeID])
		and isnull(tblS.[Contribution],'') = isnull(@Contribution,tblS.[Contribution])
		and isnull(tblS.[ContributionYear],'') = isnull(@ContributionYear,tblS.[ContributionYear])
		and isnull(tblS.[Transfer],'') = isnull(@Transfer,tblS.[Transfer])
		and isnull(tblS.[Rollover],'') = isnull(@Rollover,tblS.[Rollover])
		and isnull(tblS.[Conversion],'') = isnull(@Conversion,tblS.[Conversion])
		and isnull(tblS.[ConversionYear],'') = isnull(@ConversionYear,tblS.[ConversionYear])
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