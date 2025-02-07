--상관 서브쿼리 고급 사용법: 한 테이블의 여러 레코드를 다른 테이블의 단일 레코드로 펼치는 기술. 
--예를 들면 12,45555,656 이렇게 한 줄로 합쳐주는 것 
--주로 데이터 분석에서 유용하게 사용됨 

--이 예제에서 하고 싶은 것: 모든 LineTotal을 한 줄로 모아주고 싶음 
--Step 1
		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659

--Step 2:

		  SELECT
		  *
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659

--Step 3:

		  SELECT
		  LineTotal
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659


--Step 4:
--XML: 데이터를 구조화해서 저장하기 위한 마크업 언어.주로 데이터를 저장하거나 웹 애플리케이션 간 데이터를 교환할 때 많이 사용
--모든 데이터를 한줄로, <></> 형식으로 저장해줌 
		  SELECT
		  LineTotal
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')

--Step 5-1: concatenate
--LineTotal 컬럼은 숫자여서 cast 해줘야 함
--이렇게만 하면 소수점때문에 보기 불편함 

		  SELECT
		  ',' + CAST(LineTotal AS VARCHAR)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')
--Step 5-1: concatenate
--MONEY: SQL에서 금액 또는 통화를 표현할 때 사용하는, 정확한 소수점을 나타내는 데이터 타입 
		  SELECT
		  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')
--Step 6:
--STUFF: 문자열의 특정 부분을 다른 문자열로 덮어쓰는 기능 제공. 주로 문자열 일부 삭제하고 다른 문자열로 덮어쓰는 기능 제공 ㅇ
--STUFF(수정할 원본 문자열, 덮어쓸 시작위치(첫번째 문자는 1), 덮어쓸 문자열 길이, 삽입할 새 문자열)
--첫번째 문자에서 쉼표 삭제하고, 나머지에는 맨 앞에 쉼표 붙임
--왜 SELECT를 붙여야하나?: 서브쿼리나 함수의 결과를 반환하려면 그 값을 반드시 SELECT 통해 반환해야 하기 때문
SELECT
	STUFF(
		  (
			  SELECT
			  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
			  FROM AdventureWorks2019.Sales.SalesOrderDetail A
			  WHERE A.SalesOrderID = 43659
			  FOR XML PATH('')
		  ),
		  1,1,'')



--Step 7:
--SELECT 앞에 보여줄 나머지 컬럼 가져오기. 그러려면 테이블 참조해야하니까 alias 붙이고, WHERE에서 ID가 같다는 조건 붙여주기
SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,LineTotals = 
		STUFF(
			  (
				  SELECT
				  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
				  FROM AdventureWorks2019.Sales.SalesOrderDetail B
				  WHERE A.SalesOrderID = B.SalesOrderID 
				  FOR XML PATH('')
			  ),
			  1,1,''
		  )

FROM AdventureWorks2019.Sales.SalesOrderHeader A

