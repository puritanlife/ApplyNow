


CREATE VIEW [maint].[vwGetLogExistingIDAgainstComment]
AS
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/3/2020
  Description: Gets all Apply Now Data.
*************************************************/

	SELECT tLVC.[Comment]
		  ,tLEAC.[AsOfDate]
		  ,tLEAC.[ExistingID]
	FROM [maint].[tblVerificationExistingIDAgainstComment] tLEAC with(nolock) 
	inner join [maint].[tblVerificationCommentSQL] tLVC with(nolock) on tLVC.[LogVerificationCommentSQLID] = tLEAC.[LogVerificationCommentSQLID]