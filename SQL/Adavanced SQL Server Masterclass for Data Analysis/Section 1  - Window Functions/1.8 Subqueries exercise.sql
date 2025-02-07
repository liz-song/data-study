--Prob1
--서브쿼리에 별칭 잊지말기

SELECT 
	B.PurchaseOrderID,
	B.VendorID,
	B.OrderDate,
	B.TaxAmt,
	B.Freight,
	B.TotalDue

FROM (
	SELECT
	A.PurchaseOrderID,
	A.VendorID,
	A.OrderDate,
	A.TaxAmt,
	A.Freight,
	A.TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY A.VendorID ORDER BY A.TotalDue DESC)
	FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
	) B
WHERE OrderRank <= 3

--Prob2

SELECT 
	B.PurchaseOrderID,
	B.VendorID,
	B.OrderDate,
	B.TaxAmt,
	B.Freight,
	B.TotalDue

FROM (
	SELECT
	A.PurchaseOrderID,
	A.VendorID,
	A.OrderDate,
	A.TaxAmt,
	A.Freight,
	A.TotalDue,
	OrderRank = DENSE_RANK() OVER(PARTITION BY A.VendorID ORDER BY A.TotalDue DESC)
	FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
	) B
WHERE OrderRank <= 3