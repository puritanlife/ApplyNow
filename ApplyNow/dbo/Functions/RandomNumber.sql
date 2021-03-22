CREATE FUNCTION [dbo].[RandomNumber] ( @randomlength int ) 
RETURNS VARCHAR(10)
AS
BEGIN

declare @rnd varchar(10) = ''
;with a as
(
select 0 x
union all
select x + 1
from a where x < 9
), b as
(
select top 10 x from a
--order by newid()
)
select @rnd += cast(x as char(1)) from b

RETURN @rnd
END