






CREATE procedure [dbo].[spGetLeadsNonLicenseStates]
(
    @LeadsNonLicenseStatesID [int] null ,
	@ProductPlanPeriodID [int] null ,
	@StateID [int] null ,
	@Email [nvarchar](100) null,
	@Name [nvarchar](200) null,
	@Source [nvarchar](100) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/2/2020
  Description: Inserts a Leads Non Licensed States Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetLeadsNonLicenseStates]' 
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
	DECLARE @Record_Exists nvarchar(3) = 'No'
	DECLARE @StateLicenseTypeID [int] = 0

	--if @LeadsNonLicenseStatesID is null 
	--	set @LeadsNonLicenseStatesID		= isnull(@LeadsNonLicenseStatesID,-99);

	if @LeadsNonLicenseStatesID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblLeadsNonLicenseStates] with(nolock) where isnull([LeadsNonLicenseStatesID],'') = isnull(@LeadsNonLicenseStatesID,'')),'No');

	SET @Parameters = '@LeadsNonLicenseStatesID ' + cast(@LeadsNonLicenseStatesID as nvarchar) + 
	                  ' @ProductPlanPeriodID ' + cast(@ProductPlanPeriodID as nvarchar) + 
	                  ' @StateID ' + cast(@StateID as nvarchar) + 
					  ' @Email ' + cast(@Email as nvarchar) + 
					  ' @Name ' + cast(@Name as nvarchar) +
					  ' @Source ' + cast(@Source as nvarchar) +
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	SELECT 
		 tblLNLS.[LeadsNonLicenseStatesID]
		,tblLNLS.[ProductPlanPeriodID]
		,tblLNLS.[StateID]
		,tblS.[StateShort]
		,tblS.[StateLong]
		,tblLNLS.[Premium]
		,tblLNLS.[StateLicenseTypeID]
		,tblSLT.Descr AS [StateLicenseTypeDescr]
		,tblLNLS.[Email]
		,tblLNLS.[Name]
		,tblLNLS.[Source]
	FROM [dbo].[tblLeadsNonLicenseStates] tblLNLS with(nolock)
	inner join [dbo].[tblStateLicenseType] tblSLT with(nolock) on tblSLT.[StateLicenseTypeID] = tblLNLS.[StateLicenseTypeID]
	inner join [dbo].[tblState] tblS with(nolock) on tblS.[StateID] = tblLNLS.[StateID]
	where isnull(tblLNLS.[LeadsNonLicenseStatesID],'') = isnull(@LeadsNonLicenseStatesID,tblLNLS.[LeadsNonLicenseStatesID])
	and isnull(tblLNLS.[ProductPlanPeriodID],'') = isnull(@ProductPlanPeriodID,tblLNLS.[ProductPlanPeriodID])
	and isnull(tblLNLS.[StateID],'') = isnull(@StateID,tblLNLS.[StateID])
	and isnull(tblLNLS.[Email],'') = isnull(@Email,tblLNLS.[Email])
	SET @SP_RowCount = @@ROWCOUNT;

	--select @LeadsNonLicenseStatesID AS [LeadsNonLicenseStatesID];
	SET @Message = @Message + 'Select only, not inserts or updates. '
	SET @Output = @Output + 'Record Count ' + cast(@SP_RowCount as varchar)

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END