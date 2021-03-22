
CREATE procedure [dbo].[spGetState]
(
	@StateID [int] Null,
	@StateShort nvarchar(2) Null,
	@StateLong nvarchar(50) Null,
	@StateLicenseTypeID int Null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/7/2020
  Description: Returns licensed and non licensed states. 
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetState]' 
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

	SET @Parameters = '@StateID ' + cast(@StateID as nvarchar) + 
	                  ' @StateShort ' + cast(@StateShort as nvarchar) + 
	                  ' @StateLong ' + cast(@StateLong as nvarchar) + 
					  ' @StateLicenseTypeID ' + cast(@StateLicenseTypeID as nvarchar)

	SELECT tblS.[StateID]				AS [StateID]
		  ,tblS.[StateShort]			AS [StateShort]
		  ,tblS.[StateLong]				AS [StateLong]
		  ,tblSLI.[StateLicenseTypeID]	AS [StateLicenseTypeID]
		  ,tSLT.[Type]					AS [LicenseType]
          ,tSLT.[Descr]					AS [LicenseTypeDescr]
	  FROM [dbo].[tblState] tblS with(nolock)
	  inner join [dbo].[tblStateLicenseIndictor] tblSLI with(nolock) on tblSLI.[StateID] = tblS.[StateID]
	  inner join [dbo].[tblStateLicenseType] tSLT with(nolock) on tSLT.[StateLicenseTypeID] = tblSLI.[StateLicenseTypeID]
	  where tblSLI.[EffectiveDate] = (select max(tblSLI1.[EffectiveDate])
	                                from [dbo].[tblStateLicenseIndictor] tblSLI1
									where tblSLI1.[StateID] = tblS.[StateID]
									and tblSLI1.[EffectiveDate] <= getdate())
  		and  isnull(tblS.[StateID],'') = isnull(@StateID,tblS.[StateID])
		and isnull(tblS.[StateShort],'') = isnull(@StateShort,tblS.[StateShort])
		and isnull(tblS.[StateLong],'') = isnull(@StateLong,tblS.[StateLong])
		and isnull(tblSLI.[StateLicenseTypeID],'') = isnull(@StateLicenseTypeID,tblSLI.[StateLicenseTypeID])
     order by tblS.[StateLong] asc
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