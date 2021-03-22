
CREATE procedure [dbo].[spSetSourceOfFunds]
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
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetSourceOfFunds]' 
	DECLARE @ErrorNumber nvarchar(max) = null 
	DECLARE @ErrorSeverity nvarchar(max) = null 
	DECLARE @ErrorState nvarchar(max) = null 
	DECLARE @ErrorProcedure nvarchar(max) = null 
	DECLARE @ErrorMessage nvarchar(max) = null 
	DECLARE @Message nvarchar(max) = null 
	DECLARE @Output nvarchar(max) = null 

	-- Declaring variables for stored procedure's execution
	DECLARE @Record_Exists nvarchar(3) = 'No'
	DECLARE @Parameters nvarchar(max) = null

	if @ApplicationID is null 
		set @ApplicationID = isnull(@ApplicationID,-99)

	if @FundsTypeID is null 
		set @FundsTypeID = isnull(@FundsTypeID,-99)

	if @Contribution is null 
		set @Contribution = isnull(@Contribution,0)

	if @ContributionYear is null 
		set @ContributionYear = isnull(@ContributionYear,0)

	if @Transfer is null 
		set @Transfer = isnull(@Transfer,0)

	if @Rollover is null 
		set @Rollover = isnull(@Rollover,0)

	if @Conversion is null 
		set @Conversion = isnull(@Conversion,0)

	if @ConversionYear is null 
		set @ConversionYear = isnull(@ConversionYear,0)

	if @SourceOfFundsID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblSourceOfFunds] tSOF with(nolock) where isnull([SourceOfFundsID],'') = isnull(@SourceOfFundsID,'')),'No');
	
	SET @Parameters = '@ApplicationID ' + cast(@ApplicationID as nvarchar) + 
	                  ' @FundsTypeID ' + cast(@FundsTypeID as nvarchar) + 
	                  ' @Contribution ' + cast(@Contribution as nvarchar) + 
	                  ' @ContributionYear ' + cast(@ContributionYear as nvarchar) + 
	                  ' @Transfer ' + cast(@Transfer as nvarchar) + 
	                  ' @Rollover ' + cast(@Rollover as nvarchar) + 
	                  ' @Conversion ' + cast(@Conversion as nvarchar) + 
					  ' @ConversionYear ' + cast(@ConversionYear as nvarchar) +
					  ' @Record_Exists '  + cast(@Record_Exists as nvarchar)
	
	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

				INSERT INTO [dbo].[tblSourceOfFunds]
					([ApplicationID]
					,[FundsTypeID]
					,[Contribution]
					,[ContributionYear]
					,[Transfer]
					,[Rollover]
					,[Conversion]
					,[ConversionYear])
				VALUES
					(@ApplicationID		-- ApplicationID
					,@FundsTypeID       -- FundsTypeID
					,@Contribution		-- Contribution
					,@ContributionYear	-- ContributionYear
					,@Transfer			-- Transfer
					,@Rollover			-- Rollover
					,@Conversion		-- Conversion
					,@ConversionYear)	-- ConversionYear

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

				update [dbo].[tblSourceOfFunds]
				set [ApplicationID] = @ApplicationID
					,[FundsTypeID] = @FundsTypeID
					,[Contribution] = @Contribution
					,[ContributionYear] = @ContributionYear
					,[Transfer] = @Transfer
					,[Rollover] = @Rollover
					,[Conversion] = @Conversion
					,[ConversionYear] = @ConversionYear
				where [SourceOfFundsID] = @SourceOfFundsID;

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

    set @SourceOfFundsID = isnull((select [SourceOfFundsID] as [SourceOfFundsID] from [dbo].[tblSourceOfFunds] tblSOF with(nolock) where isnull([ApplicationID],'') = isnull(@ApplicationID,'')
				                                                                                    and isnull([FundsTypeID],'') = isnull(@FundsTypeID,'')
				                                                                                    and isnull([Contribution],'') = isnull(@Contribution,'')
				                                                                                    and isnull([ContributionYear],'') = isnull(@ContributionYear,'')
				                                                                                    and isnull([Transfer],'') = isnull(@Transfer,'')
				                                                                                    and isnull([Rollover],'') = isnull(@Rollover,'')
				                                                                                    and isnull([Conversion],'') = isnull(@Conversion,'')
				                                                                                    and isnull([ConversionYear],'') = isnull(@ConversionYear,'')),0);

	select @SourceOfFundsID AS 'SourceOfFundsID'
	set @Output = '@SourceOfFundsID ' + cast(@SourceOfFundsID as nvarchar)

	SET @Message = @Message + 'Inserts and updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall

END