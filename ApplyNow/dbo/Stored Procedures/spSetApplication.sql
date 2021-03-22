
CREATE procedure [dbo].[spSetApplication]
(
    @ApplicationID [int] null ,
	@ProductPlanPeriodID [int] null ,
	@UUID [nvarchar](250) null ,
	@StateID [int] null ,
    @Premium [float] null ,
    @ForCompany [bit] null ,  
    @StatusTypeID [int] null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 4/21/2020
  Description: Inserts a Application Record.
**************************************************/
	
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetApplication]' 
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

	if @ApplicationID is null 
		set @ApplicationID		= isnull(@ApplicationID,-99);

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

	if @ForCompany is null 
		set @ForCompany			= isnull(@ForCompany,0);

	if @ApplicationID <> -99
		set @Record_Exists		= isnull((select 'Yes' from [dbo].[tblApplication] with(nolock) where isnull([ApplicationID],'') = isnull(@ApplicationID,'')),'No');

	SET @Parameters = '@ApplicationID ' + cast(@ApplicationID as nvarchar) + 
	                  ' @ProductPlanPeriodID ' + cast(@ProductPlanPeriodID as nvarchar) + 
	                  ' @UUID ' + cast(@UUID as nvarchar(100)) + 
	                  ' @StateID ' + cast(@StateID as nvarchar) + 
	                  ' @Premium ' + cast(@Premium as nvarchar) + 
	                  ' @ForCompany ' + cast(@ForCompany as nvarchar) + 
	                  ' @StatusTypeID ' + cast(@StatusTypeID as nvarchar) + 
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar)

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblApplication]
					([ProductPlanPeriodID]
					,[UUID]
					,[StateID]
					,[Premium]
					,[ForCompany]
					,[StatusTypeID]
					,[CanvasPolicyNumber]
					,[StateLicenseTypeID])
				VALUES
					(@ProductPlanPeriodID	-- ProductPlanPeriodID
					,@UUID					-- UUID
					,@StateID				-- StateID
					,@Premium				-- Premium
					,@ForCompany			-- ForCompany
					,@StatusTypeID			-- StatusTypeID
					,null					-- CanvasPolicyNumber
					,@StateLicenseTypeID);	-- StateLicenseTypeID	

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

				update [dbo].[tblApplication]
				set [ProductPlanPeriodID] = @ProductPlanPeriodID
				,[StateID]			  = @StateID
				,[Premium]			  = @Premium
				,[ForCompany]		  = @ForCompany
				,[StatusTypeID]		  = @StatusTypeID
				--,[CanvasPolicyNumber] = @CanvasPolicyNumber 
				where ApplicationID			  = @ApplicationID;	

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
	
	set @ApplicationID = (select [ApplicationID] from [dbo].[tblApplication] tblA with(nolock) 
  													where isnull(tblA.[UUID],'') = isnull(@UUID,'')
													and tblA.[LastModifiedDate] = (select max(tblA1.[LastModifiedDate])
																		from [dbo].[tblApplication] tblA1 with(nolock)
																		where isnull(tblA1.[UUID],'') = isnull(tblA.[UUID],'')
																		and tblA1.[LastModifiedDate] <= getdate()))

	select [ApplicationID] AS [ApplicationID], isnull([CanvasPolicyNumber],'No Policy Number Yet') AS [CanvasPolicyNumber] from [dbo].[tblApplication] with(nolock) where [ApplicationID] = @ApplicationID;
	SET @Output = '@ApplicationID ' + cast(@ApplicationID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END