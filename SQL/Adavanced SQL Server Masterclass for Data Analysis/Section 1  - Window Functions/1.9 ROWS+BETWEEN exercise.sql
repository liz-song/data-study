--Prob1,2,3,4
SELECT
OrderMonth,
OrderYear,
SubTotal,
Rolling3MonthTotal = SUM(A.SubTotal) OVER(ORDER BY OrderYear,OrderMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
MovingAvg6Month = AVG(A.SubTotal) OVER(ORDER BY OrderYear,OrderMonth ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING),
MovingAvgNext2Months = AVG(A.SubTotal) OVER(ORDER BY OrderYear,OrderMonth ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING )
FROM 
	(
	SELECT 
	OrderMonth = MONTH(OrderDate),
	OrderYear = YEAR(OrderDate),
	SubTotal = SUM(SubTotal)
	FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
	GROUP BY MONTH(OrderDate),YEAR(OrderDate)
	) A
