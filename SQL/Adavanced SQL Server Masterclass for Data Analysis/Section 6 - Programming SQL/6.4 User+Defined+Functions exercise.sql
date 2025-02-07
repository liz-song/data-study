-- prob1 
/* 첫 아규먼트가 두번째 아규먼트의 몇퍼센트인지 리턴하는 함수 만들기 
- STRING으로 리턴되어야하고, 정수가 들어왔을 때에도 소수점 나와야함 */
CREATE FUNCTION MyDivision(@first INT, @second INT)

RETURNS VARCHAR(10)

AS

BEGIN
	DECLARE @result FLOAT = FORMAT((@first * 1.0) / @second , 'P')
	RETURN FORMAT(@result, 'P')
END

-- prob2
-- 각 직원의 최대 휴가 시간 저장하고, 해당 스키마에서 1,2,3 컬럼 뽑고, 추가로 PercentOfMaxVacation라는 필드 추가 

DECLARE @MaxVacation INT = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

--SELECT문	
SELECT
	BusinessEntityID,
	JobTitle,
	VacationHours,
	PercentOfMaxVacation = dbo.ufnIntegerPercent(VacationHours, @MaxVacationHours)
FROM AdventureWorks2019.HumanResources.Employee

