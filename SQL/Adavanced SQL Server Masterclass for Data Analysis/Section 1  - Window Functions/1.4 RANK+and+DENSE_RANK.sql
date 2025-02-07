--ROW_NUMBER, RANK, AND DENSE_RANK, compared
--ROw_NUMBER에서 같은 점수 나왔을 때 어떻게 대처? (대부분 ROW_NUMBER 사용하긴함)
--1. RANK 쓰면 같은 점수에 대해서 같은 순위 나오지만, 다음 순위는 중복된 만큼 스킵함(예.12225)
--2. DENSE_RANK: 같은 점수에 같은 순위 나오고, 순위는 스킵되지 않음(예.12223)
--중요성과 필요성에 맞게 세 개 중 골라서 쓰면 됨 

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	RankingWithRank = RANK() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC),
	RankingWithDenseRank = DENSE_RANK() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY SalesOrderID, LineTotal DESC