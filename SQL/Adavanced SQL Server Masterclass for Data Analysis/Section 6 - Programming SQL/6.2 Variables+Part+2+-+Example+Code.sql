-- 변수는 복잡한 로직을 단계적으로 작성하며, 코드 가독성과 유지 보수성 높이는 데 유용함 
--Variables for complex date math: 이전 달의 첫째 날과 마지막 날을 구하는 과정 변수로 처리 

DECLARE @Today DATE = CAST(GETDATE() AS DATE)

SELECT @Today

DECLARE @BOM DATE = DATEFROMPARTS(YEAR(@Today),MONTH(@Today),1)

SELECT @BOM 

DECLARE @PrevEOM DATE = DATEADD(DAY,-1,@BOM)

SELECT @PrevEOM

DECLARE @PrevBOM DATE = DATEADD(MONTH,-1,@BOM)

SELECT @PrevBOM



SELECT
*
FROM AdventureWorks2019.dbo.Calendar
WHERE DateValue BETWEEN @PrevBOM AND @PrevEOM



-- 내 연습
DECLARE @Today DATE
SET @Today = CAST(GETDATE() AS DATE) --getdate 사용해서 현재 날짜와 시간 반환되면 CAST 통해서 날짜만 반환

DECLARE @BOM DATE
SET @BOM = DATEFROMPARTS(YEAR(@Today),MONTH(@Today),1) --DATEFROMPARTS()로 특정 연, 월, 일 조합해서 날짜값 만듦. 일자는 1로 고정

DECLARE @PrevBOM DATE
SET @PrevBOM = DATEADD(MONTH,-1,@BOM) -- @today변수가 있는 달의 이전 달의 1일 출력 

DECLARE @PrevEOM DATE
SET @PrevEOM = DATEADD(DAY, -1, @BOM)


SELECT
*
FROM AdventureWorks2019.dbo.Calendar
WHERE DateValue BETWEEN @PrevBOM AND @PrevEOM