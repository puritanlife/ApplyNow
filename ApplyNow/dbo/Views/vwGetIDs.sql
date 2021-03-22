
CREATE VIEW [dbo].[vwGetIDs]
AS
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 4/21/2020
  Description: Gets all IDs Data.
*************************************************/

	SELECT ta.[ApplyNowID]		AS [ApplyNowIDtblApplyNow]					-- 50000
	     , tblDSDE.[ApplyNowID]	AS [ApplyNowIDtblDocuSignDataElements]		-- 50000
		 , tblLNDE.[ApplyNowID]	AS [ApplyNowIDtblLexisNexisDataElements]	-- 50000
		 , tblEP.[ApplyNowID]	AS [ApplyNowIDtblExistingPolicy]			-- 50000
		 , tblPSDE.[ApplyNowID]	AS [ApplyNowIDtblPlaidStripeDataElements]	-- 50000
		 , tapp.[ApplicationID] AS [ApplicationIDtblApplication]			-- Normal
		 , ta.[ApplicationID]	AS [ApplicationIDtblApplyNow]				-- Normal
		 , SOF.[ApplicationID]  AS [ApplicationIDtblSourceOfFunds]			-- Normal
		 , tblP.[PersonID]		AS [PersonIDtblPerson]						-- 25000
		 , ta.[PersonID]		AS [PersonIDtblApplyNow]					-- 25000
		 , tblA.[PersonID]		AS [PersonIDtblAddress]						-- 25000
		 , tblPP.[PersonID]		AS [PersonIDtblPersonPhone]					-- 25000
		 , tblPE.[PersonID]		AS [PersonIDtblPersonEmail]					-- 25000
		 , tblU.[PersonID]		AS [PersonIDtblUser]						-- 25000
		 , tblEP.[CarrierID]	AS [CarrierIDtblExistingPolicy]				-- 25000
	  FROM [dbo].[tblApplyNow] ta with(nolock) 
	  left outer join [dbo].[tblDocuSignDataElements] tblDSDE with(nolock) on tblDSDE.[ApplyNowID] = ta.[ApplyNowID]
	  left outer join [dbo].[tblLexisNexisDataElements] tblLNDE with(nolock) on tblLNDE.[ApplyNowID] = ta.[ApplyNowID]
	  left outer join [dbo].[tblExistingPolicy] tblEP with(nolock) on tblEP.[ApplyNowID] = ta.[ApplyNowID]
	  left outer join [dbo].[tblPlaidStripeDataElements] tblPSDE with(nolock) on tblPSDE.[ApplyNowID] = ta.[ApplyNowID]
	  left outer join [dbo].[tblApplication] tapp with(nolock) on tapp.[ApplicationID] = ta.[ApplicationID]
	  left outer join [dbo].[tblSourceOfFunds] SOF with(nolock) on SOF.[ApplicationID] = tapp.[ApplicationID]  
	  left outer join [dbo].[tblPerson] tblP with(nolock) on tblP.[PersonID] = ta.[PersonID]
	  left outer join [dbo].[tblAddress] tblA with(nolock) on tblA.[PersonID] = tblP.[PersonID]
	  left outer join [dbo].[tblPersonPhone] tblPP with(nolock) on tblPP.[PersonID] = tblP.[PersonID]  
	  left outer join [dbo].[tblPersonEmail] tblPE with(nolock) on tblPE.[PersonID] = tblP.[PersonID]  
	  left outer join [dbo].[tblUser] tblU with(nolock) on tblU.[PersonID] = tblP.[PersonID]
	  left outer join [dbo].[tblState] tblSP with(nolock) on tblSP.[StateID] = tblP.[BirthStateID]
	  left outer join [dbo].[tblPerson] tblP1 with(nolock) on tblP.[PersonID] = tblEP.[CarrierID]
	  --order by ta.[ApplicationID] asc, ta.[PersonID] asc