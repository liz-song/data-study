-- delete는 특정 조건에 맞는 행만 삭제 가능하고, truncate은 테이블 모든 행 한 번에 삭제 
-- 데이터 분석 업무에서 delete는 사실 덜 유용. 하지만 알아둘 필요는 있음 
-- DELETE [컬럼명] FROM [테이블명], 조건이 있는 경우 그냥 FROM 뒤에 WHERE절 써주면 됨 
-- DELETE는 되돌릴 수 있는 방법이 없으니까 조심해서 사용 
--Selecting from temp table with WHERE clause

SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

INTO #Sales

FROM AdventureWorks2019.Sales.SalesOrderHeader


SELECT
*
FROM #Sales
WHERE OrderRank <= 10

DROP TABLE #Sales



--Deleting all records from temp table

SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

INTO #Sales

FROM AdventureWorks2019.Sales.SalesOrderHeader


DELETE FROM #Sales 




--Using DELETE with criteria

INSERT INTO #Sales

SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Sales.SalesOrderHeader


SELECT * FROM #Sales


DELETE FROM #Sales WHERE OrderRank > 10



SELECT
*
FROM #Sales


DROP TABLE #Sales




