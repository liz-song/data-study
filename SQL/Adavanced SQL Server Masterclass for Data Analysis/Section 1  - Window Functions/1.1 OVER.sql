--YTD Sales Via Aggregate Query:

SELECT

      [Total YTD Sales] = SUM(SalesYTD)
      ,[Max YTD Sales] = MAX(SalesYTD)

FROM AdventureWorks2019.Sales.SalesPerson



--YTD Sales With OVER:

SELECT BusinessEntityID
      ,TerritoryID
      ,SalesQuota
      ,Bonus
      ,CommissionPct
      ,SalesYTD
	  --,SalesLastYear
	  -- over에 기준이 되는 값이 없어서 모든 Sales YTD를 더해서 내보냄 = 집계함수와 같은 기능 
      ,[Total YTD Sales] = SUM(SalesYTD) OVER() 
	  -- over에 기준이 되는 값이 없어서 모든 Sales YTD 중 MAX값만 내보냄 
      ,[Max YTD Sales] = MAX(SalesYTD) OVER()
	  -- 해당 년도 최대 세일즈 값과 비교했을 때 퍼센티지가 어떻게 되는지. 베스트 세일즈맨은 1이 됨
      ,[% of Best Performer] = SalesYTD/MAX(SalesYTD) OVER()

FROM AdventureWorks2019.Sales.SalesPerson






