



CREATE PROCEDURE [dbo].[spSetLeadsNonLicenseStates]
(
    @LeadsNonLicenseStatesID [int] null ,
	@ProductPlanPeriodID [int] null ,
	@UUID [nvarchar](250) null ,
	@StateID [int] null ,
    @Premium [int] null ,
	@Email [nvarchar](100) null,
	@Name [nvarchar](200) = NULL,
	@Source [nvarchar](100) = null
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
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetLeadsNonLicenseStates]' 
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
	DECLARE @StateLicenseTypeID [int] = 0

	if @LeadsNonLicenseStatesID is null 
		set @LeadsNonLicenseStatesID		= isnull(@LeadsNonLicenseStatesID,-99);

	if @UUID is null 
		set @UUID				= isnull(@UUID,-99);

	if @StateID is null 
		set @StateID			= isnull(@StateID,-99);
		set @StateLicenseTypeID = isnull((select tSLI.[StateLicenseTypeID] 
		                                from [dbo].[tblStateLicenseIndictor] tSLI with(nolock)
		                                where tSLI.[StateID] = @StateID
										and tSLI.[EffectiveDate] = (select max(tSLI1.[EffectiveDate])
																	from [dbo].[tblStateLicenseIndictor] tSLI1 with(nolock)
																	where tSLI1.[StateID] = tSLI.[StateID]
																	and tSLI1.[EffectiveDate] <= getdate())),1);

	if @Premium is null 
		set @Premium			= isnull(@Premium,0);
	--begin added by john 8-5-2020
	if @ProductPlanPeriodID is null 
		set @ProductPlanPeriodID			= isnull(@ProductPlanPeriodID,-99);
	--end added by john 8-5-2020


	if @LeadsNonLicenseStatesID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblLeadsNonLicenseStates] with(nolock) where isnull([LeadsNonLicenseStatesID],'') = isnull(@LeadsNonLicenseStatesID,'') and isnull([UUID],'') = isnull(@UUID,'') and isnull([Email],'') = isnull(@Email,'')),'No');

	SET @Parameters = '@LeadsNonLicenseStatesID ' + cast(@LeadsNonLicenseStatesID as nvarchar) + 
	                  ' @ProductPlanPeriodID ' + cast(@ProductPlanPeriodID as nvarchar) + 
	                  ' @UUID ' + cast(@UUID as nvarchar(100)) + 
	                  ' @StateID ' + cast(@StateID as nvarchar) + 
	                  ' @Premium ' + cast(@Premium as nvarchar) + 
					  ' @Email ' + cast(@Email as nvarchar) + 
					  ' @Name ' + cast(@Name as nvarchar) +
					  ' @Source ' + cast(@Source as nvarchar) +
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblLeadsNonLicenseStates]
					([ProductPlanPeriodID]
					,[UUID]
					,[StateID]
					,[Premium]
					,[StateLicenseTypeID]
					,[Email]
					,[Name]
					,[Source])
				VALUES
					(@ProductPlanPeriodID	-- ProductPlanPeriodID
					,@UUID					-- UUID
					,@StateID				-- StateID
					,@Premium				-- Premium
					,@StateLicenseTypeID	-- StateLicenseTypeID
					,@Email                 -- Email
					,@Name                  -- Name
					,@Source);				-- Source	

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

	if @Record_Exists = 'Yes'
		BEGIN
			BEGIN TRY

				update [dbo].[tblLeadsNonLicenseStates]
				set  [ProductPlanPeriodID]  = @ProductPlanPeriodID
					,[StateID]				= @StateID
					,[Premium]				= @Premium
					,[StateLicenseTypeID]	= @StateLicenseTypeID
					,[Email]				= @Email
					,[Name]					= @Name
					,[Source]				= @Source
				where isnull([LeadsNonLicenseStatesID],'') = isnull(@LeadsNonLicenseStatesID,'');

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

	set @LeadsNonLicenseStatesID = (select [LeadsNonLicenseStatesID] from [dbo].[tblLeadsNonLicenseStates] tblLNLS with(nolock) 
  																		where isnull(tblLNLS.[ProductPlanPeriodID],'') = isnull(@ProductPlanPeriodID,-99)
			                                                            and isnull(tblLNLS.[UUID],'') = isnull(@UUID,'')
			                                                            and isnull(tblLNLS.[StateID],'') = isnull(@StateID,-99)
			                                                            and isnull(tblLNLS.[Premium],'') = isnull(@Premium,'')
			                                                            and isnull(tblLNLS.[StateLicenseTypeID],'') = isnull(@StateLicenseTypeID,-99)
			                                                            and isnull(tblLNLS.[Email],'') = isnull(@Email,'')
																		and isnull(tblLNLS.[Name],'') = isnull(@Name,'')
																		and isnull(tblLNLS.[Source],'') = isnull(@Source,''))

	select @LeadsNonLicenseStatesID AS [LeadsNonLicenseStatesID];
	set @Output = '@LeadsNonLicenseStatesID '+ cast(@LeadsNonLicenseStatesID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END