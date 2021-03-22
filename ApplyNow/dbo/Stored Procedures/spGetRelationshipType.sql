
CREATE PROCEDURE [dbo].[spGetRelationshipType]
(
    @TypeID [int] Null,
    @Descr nvarchar(255) Null,
	@GenderTypeID [int] Null,
	@Natural nvarchar(25) NULL
)
AS
BEGIN
/*************************************************
  Author:      Daniel Kelleher
  Create Date: 4/21/2020
  Description: Returns data within the Relationship Type table. 


  Author:	John Weaver
  Modification Date: 3/2/2021
  Description: Update proc for Natural Relationship Type.
**************************************************/

	-- Declaring variables for try and catch error handling
	SET CONCAT_NULL_YIELDS_NULL OFF;
	DECLARE @StartSPCall datetime = getdate()
	DECLARE @Procedure nvarchar(max) = '[dbo].[spGetRelationshipType]' 
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
	DECLARE @Parameters nvarchar(max) = null

	SET @Parameters = '@TypeID ' + cast(@TypeID as nvarchar) + ' @Descr ' + cast(@Descr as nvarchar) + ' @GenderTypeID ' + cast(@GenderTypeID as nvarchar)+ ' @Natural ' + cast(@Natural as nvarchar)

	SELECT 
	  tblT.[RelationshipTypeID] as [TypeID]
	, tblT.[Descr] as [Descr]
	, tblT.[GenderTypeID] as [GenderTypeID]
	, tblT.[Natural] as [Natural]
	, tblT.[Order] as [Order]
	FROM [dbo].[tblRelationshipType] tblT with(nolock) 
	where isnull(tblT.[RelationshipTypeID],'') = isnull(@TypeID,tblT.[RelationshipTypeID])
	and isnull(tblT.[Descr],'') = isnull(@Descr,tblT.[Descr])
	and isnull(tblT.[GenderTypeID],'') = isnull(@GenderTypeID,tblT.[GenderTypeID])
	and isnull(tblT.[Natural],'') = isnull(@Natural,tblT.[Natural])
	ORDER BY [Order]

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