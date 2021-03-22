-- =============================================
-- Author:      Meister, John
-- Create Date: 2/16/2021
-- Description: inserts a new transaction Status record
-- =============================================
CREATE PROCEDURE spSetACHTransactionStatus
(
@TransactRefID nvarchar(100) NULL,
@Description nvarchar(100)NULL,
@EventName nvarchar(100)NULL,
@EventDate nvarchar(100)NULL,
@EventTime nvarchar(100)NULL,
@ResultingStatus nvarchar(100)NULL
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here

INSERT INTO dbo.tblACHTransactionStatus 
(
TransactRefID,
[Description],
EventName,
EventDate,
EventTime,
ResultingStatus
)
values(
@TransactRefID,
@Description,
@EventName,
@EventDate,
@EventTime,
@ResultingStatus
)    
END