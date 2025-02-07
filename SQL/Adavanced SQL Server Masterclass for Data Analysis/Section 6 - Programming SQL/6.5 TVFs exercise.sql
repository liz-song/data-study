
CREATE FUNCTION Production.ufn_ProductsByPriceRange(@MinVal INT, @MaxVal INT)

RETURNS TABLE

AS

RETURN(
	SELECT
		ProductID,
		Name,
		ListPrice
	FROM Production.Product
	WHERE ListPrice BETWEEN @MinVal AND @MaxVal
)
