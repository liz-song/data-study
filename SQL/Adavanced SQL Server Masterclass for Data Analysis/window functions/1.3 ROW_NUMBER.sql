-- Row_number: 그룹 내에서 고유한 순서 부여. OVER, 그 안에서 ORDER BY 사용되어야함 
--Ranking all records within each group of sales order IDs
-- SalesOrder의 고유한 ID별로 line total 다 더한 값
-- line total 값을 내림차순으로 해서 각 ID의 다른 Order 내에서 랭킹 매기기 
SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY SalesOrderID),
	Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY
SalesOrderID

-- Partition by 부분을 없앤 ver.
--그루핑 없이 기준이 되는 LineTotal값만을 기반으로 랭킹 매김
-- Row_number은 항상 연속적 값이어야하므로, 같은 값에 대해서 무작위적으로 순위를 매김 -> 이건 dense rank에서 해결
--Ranking ALL records by line total - no groups!
SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY SalesOrderID),
	Ranking = ROW_NUMBER() OVER(ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY 5