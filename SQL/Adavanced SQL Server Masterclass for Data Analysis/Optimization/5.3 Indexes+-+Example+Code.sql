/*
- 인덱스: 데이터베이스 객체로, 테이블에 쿼리 실행할 때 속도 향상시킴
- 테이블의 특정 열에 인덱스를 적용해서 데이터 정렬하고, 데이터 검색 속도 빠르게 함 
- 테이블을 정렬함으로써 데이터베이스 엔진이 테이블 전체를 행 단위로 순회하지 않고도 원하는 데이터를 빠르게 찾을 수 있도록 도와줌
1. clustered indexes
- 테이블의 물리적 인덱스가 인덱스 필드 기준으로 정렬됨 
- 테이블당 하나의 클러스터드 인덱스만 가질 수 있음 
- primary key 있는 테이블은 자동으로 클러스터드 인덱스 부여받음
2. non clustered indexes
- 테이블의 물리적 데이터는 정렬되지 않지만, 정렬된 정보가 외부 데이터 구조에 저장됨 
- 테이블당 여러 개의 비클러스터드 인덱스를 생성할 수 있음 
- 전화번호부처럼 외부 데이터 구조에서 검색해 원하는 데이터 위치를 찾아가는 방식 
<인덱스 적용 시 최적화 전략>
1. 테이블 설계 단계에서 조인 패턴 분석: 자주 조인되는 필드에 (비)클러스터드 인덱스 추가
2. 클러스터드 인덱스 먼저 추가 후 필요 시 비클러스터드 인덱스 추가 
3. 데이터 삽입 후 인덱스 생성: 인덱스는 테이블에 데이터 삽입 속도 저하시킴
4. 필요하지 않은 인덱스는 추가하지 않음 
*/
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


--1.) Add clustered index to #Sales2012
-- CREATE CLUSTERED INDEX [인덱스명] ON [테이블명](컬럼 명)
CREATE CLUSTERED INDEX Sales2012_idx ON #Sales2012(SalesOrderID)


--2.) Add sales order detail ID
-- SalesOrderDetailID 라는 컬럼은 조인 해야해서 많이 나올 것임 그래서 인덱스 사용하는 것 

CREATE TABLE #ProductsSold2012
(
SalesOrderID INT,
SalesOrderDetailID INT, --Add for clustered index
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
SalesOrderDetailID,
OrderDate,
LineTotal,
ProductID
)

SELECT 
	   A.SalesOrderID
	  ,B.SalesOrderDetailID
	  ,A.OrderDate
      ,B.LineTotal
      ,B.ProductID

FROM #Sales2012 A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

SELECT * FROM #ProductsSold2012 -- 확인용


--3.) Add clustered index on SalesOrderDetailID

CREATE CLUSTERED INDEX ProductsSold2012_idx ON #ProductsSold2012(SalesOrderID,SalesOrderDetailID)


--4.) Add nonclustered index on product Id

CREATE NONCLUSTERED INDEX ProductsSold2012_idx2 ON #ProductsSold2012(ProductID)



--3.) Add product data with UPDATE


UPDATE A
SET
ProductName = B.[Name],
ProductSubcategoryID = B.ProductSubcategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID


--4.) Add nonclustered index on product subcategory ID

CREATE NONCLUSTERED INDEX ProductsSold2012_idx3 ON #ProductsSold2012(ProductSubcategoryID)






UPDATE A
SET
ProductSubcategory= B.[Name],
ProductCategoryID = B.ProductCategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductSubcategory B
		ON A.ProductSubcategoryID = B.ProductSubcategoryID


--5) Add nonclustered index on category Id

CREATE NONCLUSTERED INDEX ProductsSold2012_idx4 ON #ProductsSold2012(ProductCategoryID)



UPDATE A
SET
ProductCategory= B.[Name]

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductCategory B
		ON A.ProductCategoryID = B.ProductCategoryID


SELECT * FROM #ProductsSold2012
