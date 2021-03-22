

CREATE procedure  [maint].[spSetLogVerficationData]
(
    @MyDate nvarchar(10) = null 
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 6/3/2020
  Description: Inserts a Application Record.
**************************************************/
	DECLARE @MySQL nvarchar(max) = null
	DECLARE @cnt INT = 1

	--DECLARE 
	DECLARE @Addtbl1ModifiedDateFilterHere nvarchar(max) = ' cast(tbl1.[LastModifiedDate] as date) >= cast('''+@MyDate+''' as date) and '
	DECLARE @Addtbl2ModifiedDateFilterHere nvarchar(max) = ' cast(tbl2.[LastModifiedDate] as date) >= cast('''+@MyDate+''' as date) and '
	DECLARE @Column1And2 nvarchar(max) = ''

	if @MyDate = null
		begin
		set @MyDate = '2020-06-03'
		end

	WHILE @cnt < 89
	BEGIN
		SET @Column1And2 = cast(@cnt as varchar)+' AS [LogVerificationCommentSQLID], '''+@MyDate+''' AS [AsOfDate]'
		SET @MySQL = (SELECT [SQL] FROM [maint].[tblLogVerificationCommentSQL] where [LogVerificationCommentSQLID] = @cnt)
		SET @MySQL = replace(replace(replace(replace(@MySQL,'{Addtbl1ModifiedDateFilterHere}',@Addtbl1ModifiedDateFilterHere),'{Addtbl2ModifiedDateFilterHere}',@Addtbl2ModifiedDateFilterHere),'{Column1And2}',@Column1And2),'  ',' ')
		print (@MySQL)
		EXEC (@MySQL)

		SET @cnt = @cnt + 1;
		SET @Column1And2 = '';
		SET @MySQL = '';

	END;

END