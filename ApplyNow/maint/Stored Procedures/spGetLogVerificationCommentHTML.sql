
CREATE procedure  [maint].[spGetLogVerificationCommentHTML]
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/4/2020
  Description: Inserts a Application Record.
**************************************************/
    DECLARE @cnt int = 0
	DECLARE @MyHTML nvarchar(max) = null
	DECLARE @PersonType nvarchar(max) = null
	DECLARE @PersonTypeFirstName nvarchar(max) = null
	DECLARE @PersonTypeMiddleInitial nvarchar(max) = null
	DECLARE @PersonTypeLastName nvarchar(max) = null
	DECLARE @PersonTypeAddress1 nvarchar(max) = null
	DECLARE @PersonTypeAddress2 nvarchar(max) = null
	DECLARE @PersonTypeSSNTIN nvarchar(max) = null
	DECLARE @PersonTypeCity nvarchar(max) = null
	DECLARE @PersonTypeState nvarchar(max) = null
	DECLARE @PersonTypeZIP nvarchar(max) = null
	DECLARE @PersonTypeEmailAddress nvarchar(max) = null
	DECLARE @PersonTypePhoneNumber nvarchar(max) = null
	DECLARE @PersonTypeGender nvarchar(max) = null
	DECLARE @PersonTypeDOB nvarchar(max) = null
	DECLARE @PersonTypeBirthState nvarchar(max) = null


	SET @PersonType					= 'Owner'
	SET @PersonTypeFirstName		= 'Tyron'
	SET @PersonTypeMiddleInitial	= 'D'
	SET @PersonTypeLastName			= 'Smith'
	SET @PersonTypeAddress1			= '604 W Debra St'
	SET @PersonTypeAddress2			= 'Appt 121'
	SET @PersonTypeSSNTIN			= '897-78-3333'
	SET @PersonTypeCity				= 'Chandler'
	SET @PersonTypeState			= 'AZ'
	SET @PersonTypeZIP				= '85222'
	SET @PersonTypeEmailAddress		= 'tyron.d.smith@gmail.com'
	SET @PersonTypePhoneNumber		= '(602) 874-7854'
	SET @PersonTypeGender			= 'Male'
	SET @PersonTypeDOB				= '5/20/1965'
	SET @PersonTypeBirthState		= 'CO'
	SET @MyHTML = (select [HTML] from [maint].[tblLogVerificationCommentHTML])

	SET @MyHTML = replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	@MyHTML,'{PersonType}',@PersonType),'{PersonTypeFirstName}',@PersonTypeFirstName),'{PersonTypeMiddleInitial}',@PersonTypeMiddleInitial)
	       ,'{PersonTypeLastName}',@PersonTypeLastName),'{PersonTypeAddress1}',@PersonTypeAddress1),'{PersonTypeAddress2}',@PersonTypeAddress2)
		   ,'{PersonTypeSSNTIN}',@PersonTypeSSNTIN),'{PersonTypeCity}',@PersonTypeCity),'{PersonTypeState}',@PersonTypeState)
	       ,'{PersonTypeZIP}',@PersonTypeZIP),'{PersonTypeEmailAddress}',@PersonTypeEmailAddress),'{PersonTypePhoneNumber}',@PersonTypePhoneNumber)
	       ,'{PersonTypeGender}',@PersonTypeGender),'{PersonTypeDOB}',@PersonTypeDOB),'{PersonTypeBirthState}',@PersonTypeBirthState)

    SELECT @MyHTML AS [MyHTML]

END