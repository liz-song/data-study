--EXIST: 데이터를 반환하지 않고 매칭되는 행이 있는지 여부만 체크하는 연산자
--상관 서브쿼리에서 자주 사용되고, SELECT 절에 어떤 값을 반환할지는 중요하지 않음. 존재여부가 중요 
--JOIN에서 일어나는 1대다 관계에서의 중복이슈를 극복 가능. 중복 방지에 유리 
--Example 1

SELECT * FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesOrderID = 43683

SELECT * FROM AdventureWorks2019.Sales.SalesOrderDetail WHERE SalesOrderID = 43683



--추가(한 주문에 최소한 하나의 항목이 10000달러 이상일 때 그 주문 출력)
--이렇게 하면, 주문의 항목이 여러 번 출력되어 중복 된 데이터가 나오게 됨 
--Total due는 한 주문의 전체 결제. Line total은 각 주문 항목의 금액임. 
SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE B.LineTotal > 10000
ORDER BY 1



--Example 2: One to many join with criteria

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE EXISTS(
	SELECT
		1

	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	
	WHERE B.LineTotal > 10000
		AND A.SalesOrderID = B.SalesOrderID
	)

ORDER BY 1





--Example 3: Using EXISTS to pick only the records we need
--EXIST는 데이터를 반환하지 않고, 있는지만 체킹해줌
--WHERE EXISTS (SELECT 1(이 자리는 아무거나 채워도 됨) FROM 테이블 WHERE 조건) 
--이 예시의 경우 매치가 되는 애들만 대상 테이블로 메인 쿼리에 가지고 감 
 
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



--Example 4: exclusionary one to many join
--결국 예시 3과 같은 결과를 내는 목적임. 하지만 구현 방법이 다름 
--EXIST는 중복을 피하고, 조건을 만족하는 주문만 필터링 할 때. JOIN은 세부 항목까지 출력해야 할 때 
SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue
	  ,B.SalesOrderDetailID
	  ,B.LineTotal

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE B.LineTotal < 10000
	AND A.SalesOrderID = 43683

ORDER BY 1



--Example 5: but this doesn't even do what we want!

SELECT
*
FROM AdventureWorks2019.Sales.SalesOrderDetail

WHERE SalesOrderID = 43683

ORDER BY LineTotal DESC




--Example 6: NOT EXISTS

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE NOT EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)
--AND A.SalesOrderID = 43683

ORDER BY 1