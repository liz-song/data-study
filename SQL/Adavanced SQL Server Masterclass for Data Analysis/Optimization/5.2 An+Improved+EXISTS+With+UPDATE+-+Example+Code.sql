/*
- EXIST: 특정 테이블에서 매칭되는 레코드가 있는지 확인할 때 사용함. 다대일 관계에서 존재여부만 확인할 때 중복 데이터가 생성되지 않음
- JOIN: 테이블 간 데이터 직접 연결해서 정보 가져오지만, 다대일 관계에서 하나의 레코드가 여러 번 중복될 수 있음
<일대다 관계에서 뭘 써야할까?>
- JOIN: 모든 매칭 레코드 보고 싶을 때 
- EXIST: 단순히 레코드 존재 여부만 확인하고 싶을 때, 중복 없는 존재 여부 확인에 적합
- UPDATE: 매칭 레코드 중 하나의 정보만 가져오고 싶을 때, 중복 없이 하나의 값만 업데이트하고 데이터 반환 가능
*/
--Select all orders with at least one item over 10K, using EXISTS

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)

ORDER BY 1



--5.) Select all orders with at least one item over 10K, including a line item value, using UPDATE

--Create a table with Sales data, including a field for line total:
CREATE TABLE #Sales
(
SalesOrderID INT,
OrderDate DATE,
TotalDue MONEY,
LineTotal MONEY
)


--Insert sales data to temp table
INSERT INTO #Sales
(
SalesOrderID,
OrderDate,
TotalDue
)

SELECT
SalesOrderID,
OrderDate,
TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader


--Update temp table with > 10K line totals

UPDATE A
SET LineTotal = B.LineTotal

FROM #Sales A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID
WHERE B.LineTotal > 10000


--Recreate EXISTS:

SELECT * FROM #Sales WHERE LineTotal IS NOT NULL


--Recreate NOT EXISTS:

SELECT * FROM #Sales WHERE LineTotal IS NULL



