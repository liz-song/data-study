-- prob1
CREATE VIEW Sales.vw_Top10MonthOverMonth AS

 WITH Sales AS
(
SELECT
OrderDate
,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
,TotalDue
,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
)
 
,Top10Sales AS
(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth
)
 
 
SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total
 
FROM Top10Sales A
LEFT JOIN Top10Sales B
ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
 
ORDER BY 1


-- prob 2
/*뷰에서는 임시테이블을 사용할 수 없다는 제한이 있음
	1. 임시테이블의 수명 제한: 뷰는 지속적으로 저장되고 쿼리해야하는데 임시테이블은 세션 종료되거나 루틴 끝나면 삭제되니까
	2. 뷰의 일관성 요구: 뷰는 어디서든 쿼리될 수 있어야 하니까 데이터 소스 항상 존재해야함. 임시테이블은 이 요구사항 충족시키지 못함
*/