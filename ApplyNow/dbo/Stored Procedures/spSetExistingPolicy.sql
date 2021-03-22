
CREATE procedure [dbo].[spSetExistingPolicy]
(
    @ExistingPolicyID [int] null ,
	@ApplyNowID [int] null ,
	@PolicyNumber nvarchar(255) null ,
	@IssueDate date null ,
	@CarrierID [int] null ,
	@ChangePolicies [bit] null ,
	@ExistingPolicies [bit] null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/21/2020
  Description: Inserts a Existing Policy Record.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spSetExistingPolicy]' 
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

	if @ExistingPolicyID is null 
		set @ExistingPolicyID = isnull(@ExistingPolicyID,-99);

	if @ApplyNowID is null 
		set @ApplyNowID = isnull(@ApplyNowID,-99);

	if @PolicyNumber is null 
		set @PolicyNumber = isnull(@PolicyNumber,'');

    if @IssueDate is null 
		set @IssueDate = isnull(@IssueDate,'1900-01-01');

	if @CarrierID is null 
		set @CarrierID = isnull(@CarrierID,0);

	if @ExistingPolicyID <> -99
		set @Record_Exists = isnull((select 'Yes' from [dbo].[tblExistingPolicy] tblEP with(nolock) where isnull(tblEP.[ExistingPolicyID],'') = isnull(@ExistingPolicyID,'')),'No');

	SET @Parameters = '@ExistingPolicyID ' + cast(@ExistingPolicyID as nvarchar) + 
	                  ' @ApplyNowID ' + cast(@ApplyNowID as nvarchar) + 
	                  ' @PolicyNumber ' + cast(@PolicyNumber as nvarchar) + 
	                  ' @IssueDate ' + cast(@IssueDate as nvarchar) + 
	                  ' @CarrierID ' + cast(@CarrierID as nvarchar) + 
					  ' @ChangePolicies ' + cast(@ChangePolicies as nvarchar) + 
					  ' @ExistingPolicies ' + cast(@ExistingPolicies as nvarchar) +
					  ' @Record_Exists ' + cast(@Record_Exists as nvarchar) 

	if @Record_Exists = 'No'
		BEGIN
			BEGIN TRY

			INSERT INTO [dbo].[tblExistingPolicy]
						([ApplyNowID]
						,[PolicyNumber]
						,[IssueDate]
						,[CarrierID]
						,[ChangePolicies]
						,[ExistingPolicies])
				 VALUES
					   (@ApplyNowID			-- ApplyNowID
					   ,@PolicyNumber		-- PolicyNumber
					   ,@IssueDate			-- IssueDate
					   ,@CarrierID			-- CarrierID
					   ,@ChangePolicies 	-- ChangePolicies
					   ,@ExistingPolicies);	-- ExistingPolicies	

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

				Update [dbo].[tblExistingPolicy]
				set [ApplyNowID] = @ApplyNowID
				, [PolicyNumber] = @PolicyNumber
				, [IssueDate] = @IssueDate
				, [CarrierID] = @CarrierID
				, [ChangePolicies] = @ChangePolicies
				, [ExistingPolicies] = @ExistingPolicies
				where isnull([ExistingPolicyID],'') = isnull(@ExistingPolicyID,'');

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

	set @ExistingPolicyID = (select [ExistingPolicyID] from [dbo].[tblExistingPolicy] with(nolock) where isnull([ApplyNowID],'') = isnull(@ApplyNowID,'')
						                                                                           and isnull([PolicyNumber],'') = isnull(@PolicyNumber,'')
						                                                                           and isnull([IssueDate],'') = isnull(@IssueDate,'')
						                                                                           and isnull([CarrierID],'') = isnull(@CarrierID,'')
						                                                                           and isnull([ChangePolicies],'') = isnull(@ChangePolicies,'')
						                                                                           and isnull([ExistingPolicies],'') = isnull(@ExistingPolicies,''))

	select @ExistingPolicyID AS 'ExistingPolicyID'
	set @Output = '@ExistingPolicyID ' + cast(@ExistingPolicyID as nvarchar)

	SET @Message = @Message + 'Inserts or updates. '

    EXEC [maint].[spSetLogStoredProcedureCalls]
		@Procedure = @Procedure,
		@Message = @Message,
		@Parameters = @Parameters,
		@Output = @Output,
		@StartSPCall = @StartSPCall
		
END