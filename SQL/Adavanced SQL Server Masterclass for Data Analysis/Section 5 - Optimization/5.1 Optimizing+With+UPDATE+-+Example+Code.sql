/*
<쿼리 성능 저하의 주요 요인>: 가장 큰 원인은 대량 테이블 간의 조인. 조인 줄여야 함. 수백만의 데이터 이상이면 
<대량 조인 성능 개선 방법>
1. 초기 데이터 필터링: 데이터 처리 초반에 조건으로 데이터 필터링 해서 temp table 생성
2. 한 쿼리에 너무 많은 대량 조인 피할 것 
3. UPDATE 활용한 조인 대체 방법
- 왜?: 조인방식은 DB가 모든 매칭 후보 검사해서 추가 매칭 가능성 확인하는 과정 필요하지만, UPDATE는 조건에 맞는 첫째 값 찾으면 바로 해당테이블에 값 삽입
<쿼리 최적화 방식>
(1) temp table 및 필터링 (2) 마스터 테이블 생성 (3) 데이터 삽입 (4) UPDATE 통해 값 추가 (JOIN 사용)
<주의사항>
- 인덱스 활용: 나중에 조인할 열에 인덱스 적용하면 속도 향상 가능
- 단계적 데이터 처리: 대량 테이블 조인 피하기 위해서 UPDATE랑 INSERT 활용
- 쿼리 계획 확인: DB가 조인을 어떻게 수행하는지 파악
*/

--Starter Code:
-- 이렇게 쓰면 우리 코드에는 문제 없지만 레코드가 수백만개 넘어가면 문제 생김 
SELECT 
	   A.SalesOrderID
	  ,A.OrderDate
      ,B.ProductID
      ,B.LineTotal
	  ,C.[Name] AS ProductName
	  ,D.[Name] AS ProductSubcategory
	  ,E.[Name] AS ProductCategory


FROM AdventureWorks2019.Sales.SalesOrderHeader A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductID = C.ProductID
	JOIN AdventureWorks2019.Production.ProductSubcategory D
		ON C.ProductSubcategoryID = D.ProductSubcategoryID
	JOIN AdventureWorks2019.Production.ProductCategory E
		ON D.ProductCategoryID = E.ProductCategoryID

WHERE YEAR(A.OrderDate) = 2012


--Optimized script


--1.) Create filtered temp table of sales order header table WHERE year = 2012

CREATE TABLE #Sales2012 
(
SalesOrderID INT,
OrderDate DATE
)

INSERT INTO #Sales2012
(
SalesOrderID,
OrderDate
)

SELECT
SalesOrderID,
OrderDate

FROM AdventureWorks2019.Sales.SalesOrderHeader

WHERE YEAR(OrderDate) = 2012




--2.) Create new temp table after joining in SalesOrderDetail  table
-- 마스터 테이블에는 우리가 결과로 보고 싶은 컬럼들 일단 다 담아놓고, 초기에 필터링된 임시 테이블을 기반으로 초기 값 삽입
CREATE TABLE #ProductsSold2012
(
SalesOrderID INT,
OrderDate DATE,
LineTotal MONEY,
ProductID INT,
ProductName VARCHAR(64),
ProductSubcategoryID INT,
ProductSubcategory VARCHAR(64),
ProductCategoryID INT,
ProductCategory VARCHAR(64)
)

INSERT INTO #ProductsSold2012
(
SalesOrderID,
OrderDate,
LineTotal,
ProductID
)

SELECT 
	   A.SalesOrderID
	  ,A.OrderDate
      ,B.LineTotal
      ,B.ProductID

FROM #Sales2012 A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

SELECT * FROM #ProductsSold2012

--3.) Add product data with UPDATE

UPDATE A
SET
ProductName = B.[Name],
ProductSubcategoryID = B.ProductSubcategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID



--4.) Add product subcategory with UPDATE

UPDATE A
SET
ProductSubcategory= B.[Name],
ProductCategoryID = B.ProductCategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductSubcategory B
		ON A.ProductSubcategoryID = B.ProductSubcategoryID





--5.) Add product category data with UPDATE


UPDATE A
SET
ProductCategory= B.[Name]

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductCategory B
		ON A.ProductCategoryID = B.ProductCategoryID


SELECT * FROM #ProductsSold2012
