
CREATE procedure  [maint].[spGetLogApplicationNotificationResults]
AS 
BEGIN
	/*************************************************
	 Author:      Daniel Kelleher
	 Create Date: 4/20/2020
	 Description: Obtains data that is needed for 
	              notification results. 
	**************************************************/

	DECLARE @CRLF char(5)
			,@bodyText nvarchar(max)
			,@TableNotUpToDateHTML nvarchar(MAX)
			,@TableUpToDateHTML nvarchar(MAX)
			,@TableUpToDate nvarchar(MAX)
			,@TableNotUpToDate nvarchar(MAX);

	set @TableNotUpToDate = '
						select FullName, Email, PhoneNumberPrimary, Reason, Message, ContactTime, SubmitDate from [dbo].[tblContact]
							'

	set @TableUpToDate =    '
					    select [FirstName] + '' '' + [LastName] AS [FullName], [UpdateDate], UpdatedValue, Orders
							from (SELECT --tblC.[UserID]
									cast(tblC.[UpdateDate] as date) AS [UpdateDate]
								  , tblC.[FirstName]
								  --,tblCH.[FirstName]
								  , case when tblC.[FirstName] = tblCH.[FirstName] then ''Equal'' else ''Different'' end AS [MatchFirstname]
								  --,tblC.[MiddleName]
								  --,tblCH.[MiddleName]
							   , case when tblC.[MiddleName] = tblCH.[MiddleName] then ''Equal'' else ''Different'' end AS [MatchMiddleName]
								  ,tblC.[LastName]
								  --,tblCH.[LastName]
							   , case when tblC.[LastName] = tblCH.[LastName] then ''Equal'' else ''Different'' end AS [MatchLastName]
								  --,tblC.[PhoneNumberPrimary]
								  --,tblCH.[PhoneNumberPrimary]
							   , case when tblC.[PhoneNumberPrimary] = tblCH.[PhoneNumberPrimary] then ''Equal'' else ''Different'' end AS [MatchPhoneNumberPrimary]
								  --,tblC.[Street]
								  --,tblCH.[Street]
							   , case when tblC.[Street] = tblCH.[Street] then ''Equal'' else ''Different'' end AS [MatchStreet]
								  --,tblC.[Street2]
								  --,tblCH.[Street2]
							   , case when tblC.[Street2] = tblCH.[Street2] then ''Equal'' else ''Different'' end AS [MatchStreet2]
								  --,tblC.[City]
								  --,tblCH.[City]
							   , case when tblC.[City] = tblCH.[City] then ''Equal'' else ''Different'' end AS [MatchCity]
								  --,tblC.[State]
								  --,tblCH.[State]
							   , case when tblC.[State] = tblCH.[State] then ''Equal'' else ''Different'' end AS [MatchState]
								  --,tblC.[Zip]
								  --,tblCH.[Zip]
							   , case when tblC.[Zip] = tblCH.[Zip] then ''Equal'' else ''Different'' end AS [MatchZip]
								  --,tblC.[Country]
								  --,tblCH.[Country]
							   , case when tblC.[Country] = tblCH.[Country] then ''Equal'' else ''Different'' end AS [MatchCountry]
								  --,tblC.[DOB]
								  --,tblCH.[DOB]
							   , case when tblC.[DOB] = tblCH.[DOB] then ''Equal'' else ''Different'' end AS [MatchDOB]
								  --,tblC.[ElectronicConsent]
								  --,tblCH.[ElectronicConsent]
							   , case when tblC.[ElectronicConsent] = tblCH.[ElectronicConsent] then ''Equal'' else ''Different'' end AS [MatchElectronicConsent]
								  --,tblC.[OptOut]
								  --,tblCH.[OptOut]
							   , case when tblC.[OptOut] = tblCH.[OptOut] then ''Equal'' else ''Different'' end AS [MatchOptOut]
							  FROM [dbo].[tblCustomer] tblC
							  inner join [dbo].[tblCustomerHistory] tblCH on tblC.UserID = tblCH.UserID
																		  and tblCH.[CustHistID] = (select max(tblCH1.[CustHistID])
																									from [dbo].[tblCustomerHistory] tblCH1
																									where tblCH1.UserID = tblCH.UserID)
							where not (tblC.[FirstName] = tblCH.[FirstName]
							and tblC.[MiddleName] = tblCH.[MiddleName]
							and tblC.[LastName] = tblCH.[LastName]
							and tblC.[PhoneNumberPrimary] = tblCH.[PhoneNumberPrimary]
							and tblC.[Street] = tblCH.[Street]
							and tblC.[Street2] = tblCH.[Street2]
							and tblC.[City] = tblCH.[City]
							and tblC.[State] = tblCH.[State]
							and tblC.[Zip] = tblCH.[Zip]
							and tblC.[Country] = tblCH.[Country]
							and tblC.[DOB] = tblCH.[DOB]
							and tblC.[ElectronicConsent] = tblCH.[ElectronicConsent]
							and tblC.[OptOut] = tblCH.[OptOut])) p
							UNPIVOT
								 (Orders FOR UpdatedValue IN
								 ( [MatchFirstname]
								  ,[MatchMiddleName]
								  ,[MatchLastName]
								  ,[MatchPhoneNumberPrimary]
								  ,[MatchStreet]
								  ,[MatchStreet2]
								  ,[MatchCity]
								  ,[MatchState]
								  ,[MatchZip]
								  ,[MatchCountry]
								  ,[MatchDOB]
								  ,[MatchElectronicConsent]
								  ,[MatchOptOut])
								 ) AS unpvt
								 where Orders = ''Different''
					        '

	SET @CRLF='</BR>'
 
	EXEC dbo.[spQueryToHtmlTable] @html = @TableNotUpToDateHTML OUTPUT,  @query= @TableNotUpToDate, @orderBy = N'ORDER BY [SubmitDate] desc';
	EXEC dbo.[spQueryToHtmlTable] @html = @TableUpToDateHTML OUTPUT,  @query= @TableUpToDate, @orderBy = N'ORDER BY [UpdateDate] desc';
	 
	SET @TableNotUpToDateHTML =  isnull(@TableNotUpToDateHTML,'Nothing to Report Today')
	SET @TableUpToDateHTML =  isnull(@TableUpToDateHTML,'Nothing to Report Today')

	select                 N'Greetings,'
                +@CRLF+@CRLF+  N'Please find below the results for the PCP Contact and Customer notification.'
                +@CRLF+@CRLF+  N'The results below refer you to recent emails sent from PCP Contact and changes made within Contact form.'
                +@CRLF+@CRLF+  N'Any questions, comments or observations regarding this email, please contact the Verde Capital IT Team.'
                +@CRLF+@CRLF+  N'Recent Contact Form submissions: -'
                +@CRLF+@CRLF+  @TableNotUpToDateHTML
                +@CRLF+@CRLF+  N'Recent Customer Form submissions: -'
                +@CRLF+@CRLF+  @TableUpToDateHTML 
                +@CRLF+@CRLF+  N'Thank you, '
                +@CRLF+@CRLF+  N'Puritan Life IT' AS [HTMLOutput]


END