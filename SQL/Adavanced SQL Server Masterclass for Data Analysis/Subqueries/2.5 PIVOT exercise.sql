--Prob1
SELECT
*
FROM
(
	SELECT
		JobTitle,
		VacationHours
	FROM AdventureWorks2019.HumanResources.Employee
	) A

	PIVOT (
		AVG(VacationHours)
		FOR JobTitle IN ([Sales Representative],[Buyer],[Janitor])
	) B


--Prob2
--만약에 gender 구분으로 break down하고 싶으면 pivot과 관련없는 gender컬럼을 서브쿼리에 넣어주기. 
SELECT
[Employee Gender] = Gender,
[Sales Representative],
[Buyer],
[Janitor]
FROM
(
	SELECT
		JobTitle,
		VacationHours,
		Gender
	FROM AdventureWorks2019.HumanResources.Employee
	) A

	PIVOT (
		AVG(VacationHours)
		FOR JobTitle IN ([Sales Representative],[Buyer],[Janitor])
	) B
