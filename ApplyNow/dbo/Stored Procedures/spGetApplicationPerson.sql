


CREATE procedure [dbo].[spGetApplicationPerson]
(
    @ApplicationID [int] null,
    @PersonID [int] null,
    @PersonTypeID [int] null,
    @RelationshipTypeID [int] null,
    @GenderTypeID [int] null,
    @SSNTINTypeID [int] null,
    @BirthStateID [int] null,
    @SSNTIN [nvarchar](100) null,
	@DOB [date] null,
	@Email [nvarchar](max) null
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 5/21/2020
  Description: Returns all person's associated data with application data. 
**************************************************/
		
	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetApplicationPerson]' 
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
	DECLARE @Parameters nvarchar(max) = '@ApplicationID ' + cast(@ApplicationID as nvarchar) + 
	                                    ' @PersonID ' + cast(@PersonID as nvarchar) + 
										' @PersonTypeID ' + cast(@PersonTypeID as nvarchar) + 
										' @RelationshipTypeID ' + cast(@RelationshipTypeID as nvarchar) + 
										' @GenderTypeID ' + cast(@GenderTypeID as nvarchar) + 
										' @SSNTINTypeID ' + cast(@SSNTINTypeID as nvarchar) + 
										' @BirthStateID ' + cast(@BirthStateID as nvarchar) + 
										' @SSNTIN ' + cast(@SSNTIN as nvarchar) +
										' @DOB ' + cast(@DOB as nvarchar) +
	                                    ' @Email ' + cast(@Email as nvarchar) 

	SELECT isnull(tblAN.[ApplyNowID],'')			AS [ApplyNowID]
		  ,isnull(tblAN.[ApplicationID],'')			AS [ApplicationID]
		  ,isnull(tblAN.[PersonID],'')				AS [PersonID]
		  ,isnull(tblAN.[PersonTypeID],'')			AS [PersonTypeID]
		  ,isnull(tblPT.[Type],'')					AS [PersonType]
		  ,isnull(tblPT.[Descr],'')					AS [PersonTypeDescr]
		  ,isnull(tblPlT.[PlanTypeID],'')			AS [PlanTypeID]
		  ,isnull(tblPlT.[Type],'')					AS [PlanType]
		  ,isnull(tblPlT.[Descr],'')				AS [PlanTypeDescr]
		  ,isnull(tblAN.[Percentage],'')			AS [Percentage]
		  ,isnull(tblAN.[RelationshipTypeID],'')	AS [RelationshipTypeID]
		  ,isnull(tblAPP.[CanvasPolicyNumber],'')   AS [CanvasPolicyNumber]
		  ,isnull(tblAPP.[Premium],0.0)				AS [Premium]
		  ,isnull(tblPrT.[Descr],'')				AS [PeriodDescr]
		  ,isnull(tblEP.[ExistingPolicies],0)		AS [ExistingPolicies]
		  ,isnull(tblRT.[Descr],'')					AS [RelationshipTypeDescr]
		  ,isnull(tblP.[FirstName],'')				AS [FirstName]
		  ,isnull(tblP.[MiddleName],'')				AS [MiddleName]
		  ,isnull(tblP.[LastName],'')				AS [LastName]
		  ,cast(tblP.[DOB] as nvarchar)				AS [DOB]
		  ,isnull(tblP.[ResidentAlien],'')			AS [ResidentAlien]
		  ,isnull(tblP.[USCitizen],'')				AS [USCitizen]
		  ,isnull(tblP.[GenderTypeID],'')			AS [GenderTypeID]
		  ,isnull(tblG.[Type],'')					AS [GenderType]
		  ,isnull(tblG.[Descr],'')					AS [GenderTypeDescr]
		  ,isnull(tblP.[SSNTINTypeID],'')			AS [SSNTINTypeID]
		  ,isnull(tblSTT.[Type],'')					AS [Type]
		  ,isnull(tblSTT.[Descr],'')				AS [Descr]
		  ,isnull(tblP.[BirthStateID],'')			AS [BirthStateID]
		  ,isnull(tblBS.[StateShort],'')			AS [BirthStateShort] 
		  ,isnull(tblBS.[StateLong],'')				AS [BirthStateLong] 
		  ,isnull(tblP.[IDNumber],'')				AS [IDNumber]
		  ,isnull(tblP.[SSNTIN],'')					AS [SSNTIN]
		  ,isnull(tblA.[AddressID],'')				AS [AddressID]
		  ,isnull(tblAT.[AddressTypeID],'')			AS [AddressTypeID]
		  ,isnull(tblAT.[Type],'')					AS [AddressType]
		  ,isnull(tblAT.[Descr],'')					AS [AddressTypeDescr]
		  ,isnull(tblA.[Address1],'')				AS [Address1]
		  ,isnull(tblA.[Address2],'')				AS [Address2]
		  ,isnull(tblA.[City],'')					AS [City]
		  ,isnull(tblA.[StateID],'')				AS [StateID]
		  ,isnull(tblAS.[StateShort],'')			AS [AddressStateShort] 
		  ,isnull(tblAS.[StateLong],'')				AS [AddressStateLong] 
		  ,isnull(tblA.[ZipCode],'')				AS [ZipCode]
		  ,isnull(tblPE.[PersonEmailID],'')			AS [PersonEmailID]
		  ,isnull(tblPE.[EmailAddress],'')			AS [EmailAddress]
		  ,isnull(tblPP.[PersonPhoneID],'')			AS [PersonPhoneID]
          ,isnull(tblPP.[PhoneNumber],'')			AS [PhoneNumber]
		  ,isnull(tblU.[UserID],'')					AS [UserID]
          ,isnull(tblU.[Email],'')					AS [UserName]
		  ,isnull(tblU.[Pass],'')					AS [Password]
		  ,isnull(tblU.[Attempt],'')				AS [LoginAttempts]
		  ,isnull(tblU.[Locked],'')					AS [AccountLocked]
	FROM [dbo].[tblApplyNow] tblAN with(nolock)
	left outer join [dbo].[tblApplication] tblAPP with(nolock) on tblAPP.ApplicationID = tblAN.ApplicationID
	left outer join [dbo].[tblProductPlanPeriod] tblPPP with(nolock) on tblPPP.[ProductPlanPeriodID] = tblAPP.[ProductPlanPeriodID]
	left outer join [dbo].[tblPlanType] tblPlT with(nolock) on tblPlT.[PlanTypeID] = tblPPP.[PlanTypeID]	
	left outer join [dbo].[tblPeriodType] tblPrT with(nolock) on tblPrT.[PeriodTypeID] = tblPPP.[PeriodTypeID]
	left outer join [dbo].[tblExistingPolicy] tblEP with(nolock) on tblEP.ApplyNowID = tblAN.ApplyNowID
	left outer join [dbo].[tblUser] tblU with(nolock) on tblU.[PersonID] = tblAN.[PersonID]
												     and tblU.UserTypeID = 2 -- User
	left outer join [dbo].[tblPerson] tblP with(nolock) on tblP.[PersonID] = tblAN.[PersonID] 
	left outer join [dbo].[tblPersonType] tblPT with(nolock) on tblAN.[PersonTypeID] = tblPT.[PersonTypeID]
	left outer join [dbo].[tblRelationshipType] tblRT with(nolock) on tblAN.[RelationshipTypeID] = tblRT.[RelationshipTypeID]
	left outer join [dbo].[tblGenderType] tblG with(nolock) on tblP.[GenderTypeID] = tblG.[GenderTypeID]
	left outer join [dbo].[tblSSNTINType] tblSTT with(nolock) on tblP.[SSNTINTypeID] = tblSTT.[SSNTINTypeID]
															and tblSTT.SSNTINTypeID = 2			-- Social Security Number
	left outer join [dbo].[tblState] tblBS with(nolock) on tblP.[BirthStateID] = tblBS.[StateID] 
	left outer join [dbo].[tblAddress] tblA with(nolock) on tblA.[PersonID] = tblAN.[PersonID] 
														 and tblA.AddressTypeID = 4				-- Residential
	left outer join [dbo].[tblAddressType] tblAT with(nolock) on tblA.AddressTypeID = tblAT.AddressTypeID 
	left outer join [dbo].[tblState] tblAS with(nolock) on tblAS.[StateID] = tblA.[StateID] 
	left outer join [dbo].[tblPersonEmail] tblPE with(nolock) on tblPE.[PersonID] = tblAN.[PersonID] 
											                  and tblPE.EmailTypeID = 1			-- Primary						  
	left outer join [dbo].[tblPersonPhone] tblPP with(nolock) on tblPP.[PersonID] = tblAN.[PersonID] 
											                  and tblPP.PhoneTypeID = 1			-- Primary
	where isnull(tblAN.[ApplicationID],'') = isnull(@ApplicationID,tblAN.[ApplicationID])
	and isnull(tblAN.[PersonID],'') = isnull(@PersonID,tblAN.[PersonID])
    and isnull(tblAN.[PersonTypeID],'') = isnull(@PersonTypeID,tblAN.[PersonTypeID])
    and isnull(tblAN.[RelationshipTypeID],'') = isnull(@RelationshipTypeID,tblAN.[RelationshipTypeID])
    and isnull(tblP.[GenderTypeID],'') = isnull(@GenderTypeID,tblP.[GenderTypeID])
    and isnull(tblP.[SSNTINTypeID],'') = isnull(@SSNTINTypeID,tblP.[SSNTINTypeID])
    and isnull(tblP.[BirthStateID],'') = isnull(@BirthStateID,tblP.[BirthStateID])
    and isnull(tblP.[SSNTIN],'') = isnull(@SSNTIN,tblP.[SSNTIN])
	and isnull(tblP.DOB,'') = isnull(@DOB,tblP.DOB)
    and case when @Email is null 
	         then '1' 
			 else @Email end = (case when @Email is null 
	                                 then '1' 
								     else tblPE.EmailAddress end)  
   order by isnull(tblAN.[ApplicationID],0) asc
		  ,case when isnull(tblAN.[PersonTypeID],0) = 6 then 1 
				when isnull(tblAN.[PersonTypeID],0) = 5 then 2 
				when isnull(tblAN.[PersonTypeID],0) = 1 then 3
				when isnull(tblAN.[PersonTypeID],0) = 4 then 4
				when isnull(tblAN.[PersonTypeID],0) = 3 then 5
				when isnull(tblAN.[PersonTypeID],0) = 2 then 6
				when isnull(tblAN.[PersonTypeID],0) = 7 then 7 end asc
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