-- Prob 1
UPDATE AdventureWorks2019.dbo.Calendar
SET 
	HolidayFlag =
		CASE
			WHEN DayOfMonthNumber = 1 AND MonthNumber = 1 THEN 1
			WHEN DayOfMonthNumber = 12 AND MonthNumber = 25 THEN 1
			ELSE 0
		END 

-- Prob 2
SELECT 
	A.*
FROM AdventureWorks2019.dbo.Calendar A
	JOIN AdventureWorks2019.dbo.Calendar B
		ON A.OrderDate = B.DateValue
		
WHERE B.HolidayFlag = 1

-- Prob 3
SELECT
A.*

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
	JOIN AdventureWorks2019.dbo.Calendar B
		ON A.OrderDate = B.DateValue

WHERE B.HolidayFlag = 1
	AND B.WeekendFlag = 1