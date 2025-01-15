--Prob1
--POH테이블에서 주문 내에 Order Quantity가 500이 넘는 적어도 하나의 아이템이 있는 모든 레코즈를 보여달라. 
--상관 서브쿼리 쓸 때 꼭 ID도 맞게.. 
SELECT 
	A.PurchaseOrderID,
	A.OrderDate,
	A.SubTotal,
	A.TaxAmt
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

WHERE EXISTS(
		SELECT 1
		FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		WHERE A.PurchaseOrderID = B.PurchaseOrderID AND OrderQty >= 500)


ORDER BY 1

--Prob2
--예제 1번 조건+ unit price가 50달러보다 크다는 조건
--WHERE에 계속 AND 붙여도 됨 
SELECT 
	*
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

WHERE EXISTS(
		SELECT 1
		FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		WHERE A.PurchaseOrderID = B.PurchaseOrderID 
		AND OrderQty >= 500
		AND B.UnitPrice >= 50
		)


ORDER BY 1
