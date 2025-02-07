--LEAD: 현재 행 기준으로 다음 행 반환 LEAD(컬럼 이름, 몇 번째 다음 행 값 가져올지, 다음 행 없을 때 기본값) OVER
--LEAD는 시계열 계산할 때 유용함
--LAG: 현재 행 기준으로 이전 행의 값 반환
--Basic LEAD/LAG example

SELECT
       SalesOrderID
      ,OrderDate
      ,CustomerID
      ,TotalDue
	  ,NextTotalDue = LEAD(TotalDue, 3) OVER(ORDER BY SalesOrderID)
	  ,PrevTotalDue = LAG(TotalDue, 3) OVER(ORDER BY SalesOrderID)

FROM AdventureWorks2019.Sales.SalesOrderHeader

ORDER BY SalesOrderID

--Using PARTITION with LEAD and LAG
--Customer Id 별로 그룹화하여 각 고객의 order ID를 기준으로 이전 및 다음 주문의 Total Due 값 표시
SELECT
       SalesOrderID
      ,OrderDate
      ,CustomerID
      ,TotalDue
	  ,NextTotalDue = LEAD(TotalDue, 1) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID)
	  ,PrevTotalDue = LAG(TotalDue, 1) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID)

FROM AdventureWorks2019.Sales.SalesOrderHeader

ORDER BY CustomerID, SalesOrderID