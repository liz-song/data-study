/*CTE와 Temp Table의 차이점과 활용 
<CTE 한계>
- 범위 제한: 현재 적용되는 쿼리 범위에서만 사용 가능, 쿼리 종료되면 CTE 사라지고 참조 불가
- 디버깅 어려움: 중간 테이블만 단독으로 디버깅 불가 
- 최적화 한계: 복잡한 데이터 처리에 비효율적
<Temp Table 장점>
- 세션 범위 사용: 현재 세션 내에서만 존재하며, 쿼리 종료 후에도 같은 세션 내에서 재사용 가능
- 디버깅 용이 
- 최적화 가능: 대량의 데이터 처리나 복합한 쿼리에 적합
<CTE에서 Temp Table 변환>
- CTE의 With구문과 가상테이블 정의 제거하고, SELECT INTO 구문 사용해서 Temp Table로 데이터 저장
- Temp Table은 이름 앞에 #붙여서 정의하고, 정의된 이후에 스크립트 어디에서나 사용 가능함
<Temp Table 주의사항 및 한계>
- 중복 생성 문제: 동일 이름으로 temp table 생성하려고 하면 에러 발생 -> Drip Table 사용
- 메모리 사용: SQL 서버 메모리 차지해서, 데이터 세트 크면 성능에 영향줌 -> 사용이 끝난 temp table은 명시적으로 삭제해서 메모리 해제
<언제 temo table 사용?>
- 다중출력물 필요할 때 
- 대규모 데이터 조인 할 때나 최적화 할 때 
- 개별 단계에서 디버깅 해야할 때 
- 여러 SQL문을 포함할 때 복잡한 스크립트 작성 시 적합 
<언제 CTE 사용?>
- 단일 쿼리 아웃풋 필요할 때 
- 소규모 ~ 중간 사이즈 데이터셋 쿼링할 때 
- 핵심: 만약 CTE가 너무 느리게 작동하면, temp table로 적어보기 
*/
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

INTO #Sales -- 이 부분이 temp tables를 만드는 부분. 꼭 테이블명 앞에 샵 붙이기

FROM AdventureWorks2019.Sales.SalesOrderHeader


SELECT
	OrderMonth,
	Top10Total = SUM(TotalDue)

INTO #Top10Sales

FROM #Sales

WHERE OrderRank <= 10

GROUP BY OrderMonth



SELECT
	A.OrderMonth,
	A.Top10Total,
	PrevTop10Total = B.Top10Total

FROM #Top10Sales A
	LEFT JOIN #Top10Sales B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1


SELECT * FROM #Sales WHERE OrderRank <= 10

DROP TABLE #Sales
DROP TABLE #Top10Sales