--Prob1

--Prob1
--서브쿼리는 스칼라 값을 반환해야하는데, 그 안에서 JOIN을 쓰면 여러 행 반환할 수 있음 그니까 WHERE써서 해결
SELECT
	PurchaseOrderID,
	VendorID,
	OrderDate,
	TotalDue,
	NonRejectedItems = (
		SELECT 
		COUNT(*)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		WHERE B.RejectedQty = 0 AND A.PurchaseOrderID = B.PurchaseOrderID
	)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

--Prob2
SELECT
	PurchaseOrderID,
	VendorID,
	OrderDate,
	TotalDue,
	NonRejectedItems = (
		SELECT 
		COUNT(*)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		WHERE B.RejectedQty = 0 AND A.PurchaseOrderID = B.PurchaseOrderID
	),
	MostExpensiveItem = (
		SELECT
		MAX(UnitPrice)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		WHERE A.PurchaseOrderID = B.PurchaseOrderID
	)
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

--