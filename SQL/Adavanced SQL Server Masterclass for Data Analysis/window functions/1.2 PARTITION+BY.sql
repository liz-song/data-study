
-- 행 단위의 세부 정보를 유지하면서도, 그룹별 계산 결과를 추가로 제공
--Sum of line totals, grouped by ProductID AND OrderQty, in an aggregate query
-- 그냥 SUM
SELECT
	ProductID,
	OrderQty,
	LineTotal = SUM(LineTotal)

FROM AdventureWorks2019.Sales.SalesOrderDetail

GROUP BY
	ProductID,
	OrderQty

ORDER BY 1,2 DESC



--Sum of line totals via OVER 
--OVER 파라미터 넣지 않으면, 집계 함수 결과를 '전체 데이터셋'에 대해 계산하면서도 각 행의 세부정보 유지
	ProductID,
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER()

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY ProductID, OrderQty DESC

--Sum of line totals via OVER with PARTITION BY
-- PARTITION BY 파라미터 자리에 들어간 컬럼이 같은 것을 그룹화하여 그 안에서 집계
SELECT
	ProductID,
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY ProductID, OrderQty)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY ProductID, OrderQty DESC
