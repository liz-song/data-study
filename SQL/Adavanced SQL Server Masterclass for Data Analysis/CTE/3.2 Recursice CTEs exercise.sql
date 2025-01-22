--Prob1
WITH NumberSeries AS
(
SELECT
 1 AS MyNumber

UNION  ALL

SELECT 
MyNumber + 2
FROM NumberSeries
WHERE MyNumber < 99
)

SELECT
MyNumber
FROM NumberSeries

--Prob2
WITH DateSeires AS
(
SELECT 
	CAST('01-01-2020' AS DATE) AS FirstDayofMonth
UNION ALL

SELECT 
	DATEADD(MONTH, 1, FirstDayofMonth)
	FROM DateSeires
	WHERE DATEADD(MONTH, 1, FirstDayofMonth) < CAST('12-01-2029' AS DATE)
)

SELECT FirstDayofMonth
FROM DateSeires
OPTION(MAXRECURSION 300)