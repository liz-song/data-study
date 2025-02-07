/*급여일은 매달 15일. 
현재가 만약 15일 이상이라면, 이전 급여 기간은 이전 달 15일부터 이번 달 14일까지
현재가 만약 15일 미만이라면, 이전 급여 기간은 두 달 전 15일부터 이전 달 14일까지 */

-- 현재 날짜 뽑아내는 변수 케이스 나눠서 

DECLARE @Today DATE = CAST(GETDATE() AS DATE)

DECLARE @Current14 DATE = DATEFROMPARTS(YEAR(@Today), MONTH(@Today), 14)

DECLARE @PayEnd DATE = 
	CASE
		WHEN DAY(@Today)< 15 THEN DATEADD(MONTH, -1, @Current14)
		ELSE @Current14
	END

DECLARE @PayStart DATE = DATEADD(DAY,1,DATEADD(MONTH,-1,@PayEnd))

SELECT @PayStart
SELECT @PayEnd