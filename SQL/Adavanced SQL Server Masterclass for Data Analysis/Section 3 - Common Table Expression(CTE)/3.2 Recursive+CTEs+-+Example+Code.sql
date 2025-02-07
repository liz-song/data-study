-- Recursion(재귀): 함수 또는 구문이 스스로를 참조하며 반복적으로 문제 해결하는 프로그래밍 기법
-- SQL에서 재귀 CTE 사용하면 특정 값들의 시리즈(숫자, 날짜 등)을 손쉽게 처리 가능 
/* <구성요소>
1. Anchor Member: 시리즈의 시작점으로 작용하는 부분. 반드시 SELECT구문으로 작성해야함
UNION ALL
2. Recursive Member: Anckor Member에 반복적으로 연산 수행해 시리즈를 확장하는 부분
3. Termination Condition: 재귀호출 종료되는 조건
*/

--Example 1: generate number series with recursive CTE

WITH NumberSeries AS
(
SELECT
 1 AS MyNumber

UNION  ALL

SELECT 
MyNumber + 1
FROM NumberSeries
WHERE MyNumber < 100 /*stop할 조건 WHERE로 꼭 정해줘야함, 조건의 반복 횟수에 주의 100을 포함하면 100까지 포함되어서 101까지 출력됨*/
)

SELECT
MyNumber
FROM NumberSeries



--Example 2: generate date series with recursive CTE

WITH DateSeries AS
(
SELECT
 CAST('01-01-2021' AS DATE) AS MyDate

UNION ALL

SELECT
DATEADD(DAY, 1, MyDate)
FROM DateSeries
WHERE MyDate < CAST('12-31-2021' AS DATE) /*이렇게만 달으면 max recursion 넘어버림 그래서 옵션 달아줘야함 */
)

SELECT
MyDate

FROM DateSeries
OPTION (MAXRECURSION 365)

