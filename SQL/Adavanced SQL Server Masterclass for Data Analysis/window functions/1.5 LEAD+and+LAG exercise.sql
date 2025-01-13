--Prob1

SELECT
B.PurchaseOrderID,
B.OrderDate,
B.TotalDue,
VendorName = A.Name

FROM AdventureWorks2019.Purchasing.Vendor A
	JOIN AdventureWorks2019.Purchasing.PurchaseOrderHeader B 
		ON A.BusinessEntityID = B.VendorID

WHERE YEAR(B.OrderDate) >= 2013 AND B.TotalDue > 500

--Prob2
--LAG의 파라미터 ORDER BY는 해당 랭크 안에서의 순서. 출력 전체에서의 순서를 보장하려면 마지막에 ORDER BY 꼭
/*하지만 무엇을 기준으로 마지막 ORDER BY?: 
문제에서 명시적으로 기준을 정하지 않았을 때는 PARTITION BY와 ORDER BY 에서 사용한 컬럼을 기준 결과 정렬*/ 
SELECT
B.PurchaseOrderID,
B.OrderDate,
B.TotalDue,
VendorName = A.Name,
PrevOrderFromVendorAmt = LAG(B.TotalDue, 1) OVER(PARTITION BY B.VendorID ORDER BY B.OrderDate)

FROM AdventureWorks2019.Purchasing.Vendor A
	JOIN AdventureWorks2019.Purchasing.PurchaseOrderHeader B 
		ON A.BusinessEntityID = B.VendorID

WHERE YEAR(B.OrderDate) >= 2013 AND B.TotalDue > 500
ORDER BY B.VendorID, B.OrderDate


--Prob3

SELECT
B.PurchaseOrderID,
B.OrderDate,
B.TotalDue,
VendorName = A.Name,
PrevOrderFromVendorAmt = LAG(B.TotalDue, 1) OVER(PARTITION BY B.VendorID ORDER BY B.OrderDate),
NextOrderByEmployeeVendor = LEAD(A.Name,1) OVER(PARTITION BY B.EmployeeID ORDER BY B.OrderDate)

FROM AdventureWorks2019.Purchasing.Vendor A
	JOIN AdventureWorks2019.Purchasing.PurchaseOrderHeader B 
		ON A.BusinessEntityID = B.VendorID

WHERE YEAR(B.OrderDate) >= 2013 AND B.TotalDue > 500
ORDER BY B.EmployeeID, B.OrderDate

--Prob4

SELECT
B.PurchaseOrderID,
B.OrderDate,
B.TotalDue,
VendorName = A.Name,
PrevOrderFromVendorAmt = LAG(B.TotalDue, 1) OVER(PARTITION BY B.VendorID ORDER BY B.OrderDate),
NextOrderByEmployeeVendor = LEAD(A.Name,1) OVER(PARTITION BY B.EmployeeID ORDER BY B.OrderDate),
Next2OrderByEmployeeVendor = LEAD(A.Name,2) OVER(PARTITION BY B.EmployeeID ORDER BY B.OrderDate)

FROM AdventureWorks2019.Purchasing.Vendor A
	JOIN AdventureWorks2019.Purchasing.PurchaseOrderHeader B 
		ON A.BusinessEntityID = B.VendorID

WHERE YEAR(B.OrderDate) >= 2013 AND B.TotalDue > 500
ORDER BY B.EmployeeID, B.OrderDate