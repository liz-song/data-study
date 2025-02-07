/*내가 스스로 함수 정의하고 싶을 때(User Defined Function)
- UDF는 데이터베이스 서버에 저장되며, 다른 테이블이나 기본 함수처럼 재사용 가능 
- UDF 정의에서는 데이터베이스 이름을 명시할 수 없음(SQL Server 제한사항). 대신 현재 세션에서 사용 중인 DB에서만 함수 생성되니까 지정을 잘해주어야 함 
<함수 정의 구조>
CREATE FUNCTION [스키마명].[함수명]()
RETURNS [반환 데이터 타입]
AS
BEGIN
	RETURN [논리 또는 값]
END;
*/
--Code to create user defined function:
USE AdventureWorks2019 --해당 DB 선택하겠음 
GO
CREATE FUNCTION dbo.ufnCurrentDate()

RETURNS DATE

AS

BEGIN

	RETURN CAST(GETDATE() AS DATE)

END
GO -- 항상 함수 정의 뒤에 반드시 GO 명령어로 배치 구분해줘야함 

--Query that calls user defined function

SELECT
	   SalesOrderID
      ,OrderDate
      ,DueDate
      ,ShipDate
	  ,Today = dbo.ufnCurrentDate()

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE YEAR(A.OrderDate) = 2011

--연습
USE AdventureWorks2019 --해당 DB 선택하겠음 
GO --SQL Server에서 배치 구문 구분자. 여기까지 하나의 명령 블록으로 묶인다고 보면 됨 
CREATE FUNCTION dbo.ufnCurrentDate() --함수이름은 ufn~. dbo는 함수가 속할 스키마

RETURNS DATE --중간은 RETURNS 함수 내부는 RETURN 

AS 

BEGIN --함수 코드블록 시작
	RETURN CAST(GETDATE() AS DATE) 
END --함수 코드블록 끝