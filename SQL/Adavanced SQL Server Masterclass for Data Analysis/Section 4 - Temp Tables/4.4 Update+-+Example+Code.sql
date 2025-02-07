/* UPDATE: 이미 존재하는 데이터를 수정. 여러 필드를 한 번에 업데이트 할 수 있음 
- 쿼리 최적화에 유용함 
<문법>
UPDATE [테이블 이름]
SET [바꿀 컬럼 이름]*/

CREATE TABLE #SalesOrders
(
 SalesOrderID INT,
 OrderDate DATE,
 TaxAmt MONEY,
 Freight MONEY,
 TotalDue MONEY,
 TaxFreightPercent FLOAT,
 TaxFreightBucket VARCHAR(32),
 OrderAmtBucket VARCHAR(32),
 OrderCategory VARCHAR(32),
 OrderSubcategory VARCHAR(32)
)

INSERT INTO #SalesOrders
(
 SalesOrderID,
 OrderDate,
 TaxAmt,
 Freight,
 TotalDue,
 OrderCategory
)

SELECT
 SalesOrderID,
 OrderDate,
 TaxAmt,
 Freight,
 TotalDue,
 OrderCategory = 'Non-holiday Order'

FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

WHERE YEAR(OrderDate) = 2013

-- 위의 코드는 우리 테이블에 지금까지 없던 컬럼들 만들고 특정 조건 가진 것 조회하는 것


UPDATE #SalesOrders
SET 
TaxFreightPercent = (TaxAmt + Freight)/TotalDue,
OrderAmtBucket = 
	CASE
		WHEN TotalDue < 100 THEN 'Small'
		WHEN TotalDue < 1000 THEN 'Medium'
		ELSE 'Large'
	END


UPDATE #SalesOrders
SET TaxFreightBucket = 
	CASE
		WHEN TaxFreightPercent < 0.1 THEN 'Small'
		WHEN TaxFreightPercent < 0.2 THEN 'Medium'
		ELSE 'Large'
	END

-- 조건 추가해서 특정 레코드만 수정하기 

UPDATE #SalesOrders
SET  OrderCategory = 'Holiday'
FROM #SalesOrders
WHERE DATEPART(quarter,OrderDate) = 4
--DATEPART(추출하려는 날짜부분, 컬럼):날짜 또는 시간 값의 특정 부분

DROP TABLE #SalesOrders

-- 위처럼 파생 필드를 순차적으로 업데이트 하는 방식은 데이터 분석에서 여러 단계 로직 처리할 때 매우 유용 
SELECT * FROM #SalesOrders