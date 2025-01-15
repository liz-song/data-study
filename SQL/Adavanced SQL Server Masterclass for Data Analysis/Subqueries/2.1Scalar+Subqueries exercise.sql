--Prob1

SELECT 
A.BusinessEntityID,
A.JobTitle,
A.VacationHours,
MaxVacationHours = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)
FROM AdventureWorks2019.HumanResources.Employee A

--Prob2

SELECT 
A.BusinessEntityID,
A.JobTitle,
A.VacationHours,
MaxVacationHours = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee),
PercentVacation = (A.VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

FROM AdventureWorks2019.HumanResources.Employee A

--Prob3

SELECT 
A.BusinessEntityID,
A.JobTitle,
A.VacationHours,
MaxVacationHours = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee),
PercentVacation = (A.VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

FROM AdventureWorks2019.HumanResources.Employee A

WHERE (A.VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee) >= 0.8 