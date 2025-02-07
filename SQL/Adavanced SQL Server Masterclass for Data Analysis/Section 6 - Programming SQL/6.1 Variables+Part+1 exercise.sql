--Starter code:
DECLARE @MaxVacation FLOAT = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)
SELECT
	   BusinessEntityID
      ,JobTitle
      ,VacationHours
	  ,MaxVacationHours = @MaxVacation
	  ,PercentOfMaxVacationHours = (VacationHours * 1.0) / @MaxVacation

FROM AdventureWorks2019.HumanResources.Employee

WHERE (VacationHours * 1.0) / @MaxVacation >= 0.8

