--상관 서브쿼리: 외부 쿼리의 각 행에 대해 한 번 씩 실행되는 서브쿼리.  스칼라 아웃풋 뱉어냄
--select절이나 where절에서 사용할 수 있음 
/*언제 필요하냐?
-> 한 행당 특정 계산이 필요할 때, 조건 기반 데이터 필터링, 복잡한 로직 간단히 표현 */
--왜 SELF JOIN이 아니라 상관 서브쿼리를 사용?: 간결, 불필요한 데이터 증가 방지, 의도 명확
SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,MultiOrderCount = --correlated subquery
	  (
		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail B
		  WHERE A.SalesOrderID = B.SalesOrderID
		  AND B.OrderQty > 1
	  )

  FROM AdventureWorks2019.Sales.SalesOrderHeader A


  /*만약에 아래처럼 쓰면, 아이디 43659의 각기 다른 주문들이 나옴 
  우리는 위의 상관 서브쿼리에서 각 id에 where 절만 적용해 메인 쿼리에 이 필터링된 행들을 돌려보내주는 것임 
  */

  SELECT
  SalesOrderID,
  OrderQTY
  FROM AdventureWorks2019.Sales.SalesOrderDetail
  WHERE  SalesOrderID = 43659
 