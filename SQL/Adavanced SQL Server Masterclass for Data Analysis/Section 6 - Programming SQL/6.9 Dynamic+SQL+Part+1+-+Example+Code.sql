/*
- if문의 경우 조건이 2~3개 이상일 경우 if문이 길어지고 유지보수 어려움 
- dynamic sql: 실행 시점에 SQL쿼리를 동적으로 생성하는 방식이라, SQL 코드가 실제로 실행될 때 비로소 완성됨 
- 디버깅이 어렵고, 문자열기반이라 인젝션 취약하니 사용자가 입력값 검수 필수
- 문자열로 값을 줄거라서 VARCHAR(MAX)가 필수
*/

DECLARE @DynamicSQL VARCHAR(MAX)

SET @DynamicSQL = 'SELECT TOP 100 * FROM AdventureWorks2019.Production.Product' -- 이 텍스트를 EXEC function에 그대로 넣어주는 것 

EXEC(@DynamicSQL)
