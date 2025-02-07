/*Table-Valued Funtion(TVF): 테이블 형태의 데이터를 반환하는 사용자 정의 함수 
- 기존 스칼라 함수는 단일 값을 반환하지만 TVF는 테이블 형태의 행 집합 반환함
- 모듈성 및 재사용성, 유지 보수 용이성, 파라미터 지원 등에서 장점 있음
<사용 방법>
CREATE FUNCTION [스키마 이름][함수 이름](@파라미터 이름 데이터타입)
RETURNS TABLE
AS
RETURN(
	SELECT [원하는 컬럼]
	FROM [테이블이름]
	WHERE [조건]
)
*/
-- 내 연습
--ufn: user function name
--NVARCHAR: 유니코드 문자 저장하기 위해 사용됨 최대 n개문자 저장가능. 다국어 사용시 유용
-- 특정 색을 가진 데이터들을 다 불러오고 싶음(하드코딩하는 방식이 아니라 유저가 지정하는 방식으로 조건 걸어서)
CREATE FUNCTION Production.ufn_ProductsByColor(@Color NVARCHAR(15))

RETURNS TABLE

AS

RETURN
(
	SELECT
		 Name
		,ProductNumber
		,Color
	FROM Production.Product

	WHERE LOWER(Color) = LOWER(@Color) -- 
)



--Calling the TVF:

SELECT
*
FROM Production.ufn_ProductsByColor('RED') --FROM 내 함수(파라미터) 


SELECT
*
FROM Production.ufn_ProductsByColor('RED')