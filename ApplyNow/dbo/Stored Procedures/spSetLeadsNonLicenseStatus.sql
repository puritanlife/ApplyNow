



CREATE PROCEDURE [dbo].[spSetLeadsNonLicenseStatus]
(
    @LeadEmail [nvarchar](100) null,
	@LeadStatus [nvarchar](20) null
)
AS
BEGIN
/*************************************************
  Author:      Poonam
  Create Date: 9/23/2020
  Description: Just Update a Leads Non Licensed Status Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetLeadsNonLicenseStatus]' 
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
	declare @LeadEmailValid nvarchar(20) = null

	if @LeadEmail is null 
		set @LeadEmail	= isnull(@LeadEmail,'');

	
	if @LeadEmail <> '-99'
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblLeadsNonLicenseStates] with(nolock) where isnull([Email],'') = isnull(@LeadEmail,'')),'No');

	SET @Parameters = ' @Email ' + cast(@LeadEmail as nvarchar) +
					  ' @LeadStatus ' + cast(@LeadStatus as nvarchar) + 
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'Yes'
		BEGIN
			BEGIN TRY

				update [dbo].[tblLeadsNonLicenseStates]
				set    [LeadStatus]  = @LeadStatus
				where isnull([Email],'') = isnull(@LeadEmail,'');

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

	set @LeadEmailValid = (select [Email] from [dbo].[tblLeadsNonLicenseStates] tblLNLS with(nolock) 
  																		where isnull(tblLNLS.[Email],'') = isnull(@LeadEmail,''))
	if @LeadEmailValid is NULL
		select 'EmailId not found in LeadsNonLicenseStates table.';
	else
		select @LeadEmailValid AS [Email];
		set @Output = '@LeadEmailValid '+ cast(@LeadEmailValid as nvarchar)

		SET @Message = @Message + ' Updates Status '

		EXEC [maint].[spSetLogStoredProcedureCalls]
			@Procedure = @Procedure,
			@Message = @Message,
			@Parameters = @Parameters,
			@Output = @Output,
			@StartSPCall = @StartSPCall

END