/*
<룩업테이블 챕터>
- DDL(Data Definition Language):  create, drop, truncate처럼 데이터 구조와 정의 가능
- DML(Data Manipulating Language): insert, update, delete처럼 데이터 값을 조종함
*/
--Create Table

CREATE TABLE Adventureworks2019.dbo.Calendar
(
DateValue DATE,
DayOfWeekNumber INT,
DayOfWeekName VARCHAR(32),
DayOfMonthNumber INT,
MonthNumber INT,
YearNumber INT,
WeekendFlag TINYINT, -- 1=weekendyes, 0=no  
HolidayFlag TINYINT
)


--Insert values manually

INSERT INTO Adventureworks2019.dbo.Calendar
(
DateValue,
DayOfWeekNumber,
DayOfWeekName,
DayOfMonthNumber,
MonthNumber,
YearNumber,
WeekendFlag,
HolidayFlag
)

VALUES
(CAST('01-01-2011' AS DATE),7,'Saturday',1,1,2011,1,1),
(CAST('01-02-2011' AS DATE),1,'Sunday',2,1,2011,1,0)


SELECT * FROM Adventureworks2019.dbo.Calendar


--Truncate manually inserted values


TRUNCATE TABLE Adventureworks2019.dbo.Calendar




--Insert dates to table with recursive CTE
-- SQL내의 재귀 개념 다시. 
/*
WITH [CTE 이름] AS(
	SELECT [시작 데이터값]
	UNION ALL
	-- 재귀쿼리
	SELECT [다음 데이터값]
	FROM [CTE 이름]
	WHERE [조건]
)
SELECT * FROM [CTE 이름]
*/
WITH Dates AS
(
SELECT
 CAST('01-01-2011' AS DATE) AS MyDate

UNION ALL

SELECT
DATEADD(DAY, 1, MyDate)
FROM Dates
WHERE MyDate < CAST('12-31-2030' AS DATE)
)

INSERT INTO AdventureWorks2019.dbo.Calendar
(
DateValue
)
SELECT
MyDate

FROM Dates
OPTION (MAXRECURSION 10000)

SELECT * FROM AdventureWorks2019.dbo.Calendar




