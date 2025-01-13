--Selecting the most expensive item per order in a single query
--일종의 가상 테이블. 윈도우 함수는 SELECT나 ORDER BY 절에서 사용할 수 있어서 사용되기도 함

--Wrong Example
--이 예시는 작동되지 않음. 왜냐면 윈도우 함수는 SELECT나 ORDER BY에서만 사용가능해서
SELECT
SalesOrderID,
SalesOrderDetailID,
LineTotal,
LineTotalRanking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC

FROM dventureWorks2019.Sales.SalesOrderDetail

WHERE (ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC) = 1

--Right Example
--서브쿼리에는 alias가 꼭 필요함 ! 
--실제 비즈니스 상황/데이터분석에서 서브쿼리는 필수 
SELECT
*
FROM
(
SELECT
SalesOrderID,
SalesOrderDetailID,
LineTotal,
LineTotalRanking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail

) A

WHERE LineTotalRanking = 1
