-- prob 1
/*- FROM에서 먼저 테이블 이어준 다음에 SELECT문 작성하는 습관
  - JOIN, ON시에 줄바꿈 및 들여쓰기
  - 깔끔한 코드 작성법*/

SELECT 
B.FirstName,
B.LastName,
C.JobTitle,
AVG(A.RATE) OVER() AS AverageRate

FROM AdventureWorks2019.HumanResources.EmployeePayHistory A
	JOIN AdventureWorks2019.Person.Person B 
		ON A.BusinessEntityID = B.BusinessEntityID
	JOIN AdventureWorks2019.HumanResources.Employee C
		ON A.BusinessEntityID = C.BusinessEntityID ;

-- prob 2

SELECT 
B.FirstName,
B.LastName,
C.JobTitle,
AVG(A.RATE) OVER() AS AverageRate,
MAX(A.RATE) OVER() AS MaximumRate

FROM AdventureWorks2019.HumanResources.EmployeePayHistory A
	JOIN AdventureWorks2019.Person.Person B 
		ON A.BusinessEntityID = B.BusinessEntityID
	JOIN AdventureWorks2019.HumanResources.Employee C
		ON A.BusinessEntityID = C.BusinessEntityID ;

--prob 3
/* - SELECT문 작성 시에는 이미 있는 컬럼만 가능. 앞 줄에서 만들었다고 가능한 것 아님 
   - AS 말고 '변수 명 =' 으로 표현 가능 */

SELECT 
B.FirstName,
B.LastName,
C.JobTitle,
AverageRate = AVG(A.RATE) OVER(),
MaximumRate = MAX(A.RATE) OVER(),
DiffFromAvgRate = A.Rate - AVG(A.RATE) OVER()

FROM AdventureWorks2019.HumanResources.EmployeePayHistory A
	JOIN AdventureWorks2019.Person.Person B 
		ON A.BusinessEntityID = B.BusinessEntityID
	JOIN AdventureWorks2019.HumanResources.Employee C
		ON A.BusinessEntityID = C.BusinessEntityID ;

--prob 4

SELECT 
B.FirstName,
B.LastName,
C.JobTitle,
AverageRate = AVG(A.RATE) OVER(),
MaximumRate = MAX(A.RATE) OVER(),
DiffFromAvgRate = A.Rate - AVG(A.RATE) OVER(),
PercentofMaxRate = (A.Rate - MAX(A.Rate) OVER()) * 100  

FROM AdventureWorks2019.HumanResources.EmployeePayHistory A
	JOIN AdventureWorks2019.Person.Person B 
		ON A.BusinessEntityID = B.BusinessEntityID
	JOIN AdventureWorks2019.HumanResources.Employee C
		ON A.BusinessEntityID = C.BusinessEntityID ;
