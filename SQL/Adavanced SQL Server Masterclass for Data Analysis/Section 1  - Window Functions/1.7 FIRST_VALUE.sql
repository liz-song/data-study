--firstvalue: 주어진 정렬 기준으로 각 파티션 내에서 첫번째 값 반환하는데 사용 + 아규먼트 필요 + OVER
--데이터를 정렬하여 각 그룹 내에서 첫번째 값을 쉽게 추출할 수 있게 도와줌
/*ROW_NUMBER 사용하게 되면, 그룹화/파티셔닝 된 집단 안의 모든 순위가 나오는데, 
비즈니스 상황에서는 보통 가장 높은/낮은 값을 보길 원할 때가 있음. */
--Highest and lowest line totals per customer

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	HighestTotal = FIRST_VALUE(LineTotal) OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	LowestTotal = FIRST_VALUE(LineTotal) OVER(PARTITION BY SalesOrderID ORDER BY LineTotal)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY
	SalesOrderID, LineTotal DESC


--First/oldest order per customer

SELECT 
	CustomerID,
	OrderDate,
	TotalDue,
	FirstOrderAmt = FIRST_VALUE(TotalDue) OVER(PARTITION BY CustomerID ORDER BY OrderDate)
 
FROM AdventureWorks2019.Sales.SalesOrderHeader

ORDER BY CustomerID, OrderDate


