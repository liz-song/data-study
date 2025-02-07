
SELECT
       A.PurchaseOrderID,
	   A.OrderDate,
	   A.TotalDue

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
	WHERE A.PurchaseOrderID = B.PurchaseOrderID
		AND B.RejectedQty > 5
)

ORDER BY 1


-- 내 답
-- (1) 데이터 조회에 필요한 모든 컬럼이 들어있는 임시 테이블 만들기 
CREATE TABLE #PurchaseHead(
	PurchaseOrderID INT,
	OrderDate DATE,
	TotalDue MONEY,
	RejectedQty INT
)

INSERT INTO #PurchaseHead(
	PurchaseOrderID,
	OrderDate,
	TotalDue
)

SELECT 
	PurchaseOrderID,
	OrderDate,
	TotalDue
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader

UPDATE A
	SET RejectedQty = B.RejectedQty
FROM #PurchaseHead A
	JOIN AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		ON A.PurchaseOrderID = B.PurchaseOrderID
WHERE B.RejectedQty > 5

SELECT * FROM #PurchaseHead WHERE RejectedQty IS NOT NULL

DROP TABLE #PurchaseHead