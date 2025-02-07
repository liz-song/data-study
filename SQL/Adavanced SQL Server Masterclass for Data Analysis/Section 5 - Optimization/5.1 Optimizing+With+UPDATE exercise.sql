SELECT 
	   A.BusinessEntityID
      ,A.Title
      ,A.FirstName
      ,A.MiddleName
      ,A.LastName
	  ,B.PhoneNumber
	  ,PhoneNumberType = C.Name
	  ,D.EmailAddress

FROM AdventureWorks2019.Person.Person A
	LEFT JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID
	LEFT JOIN AdventureWorks2019.Person.PhoneNumberType C
		ON B.PhoneNumberTypeID = C.PhoneNumberTypeID
	LEFT JOIN AdventureWorks2019.Person.EmailAddress D
		ON A.BusinessEntityID = D.BusinessEntityID



-- 답변(optimazation version)
-- 1. 항상 업데이트할 대상 테이블 A
CREATE TABLE #PersonContactInfo(
    BusinessEntityID INT,
    Title VARCHAR(50),
    FirstName VARCHAR(50),
    MiddleName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(25),
    PhoneNumberTypeID INT,
    PhoneNumberType VARCHAR(50),
    EmailAddress VARCHAR(50)
)

INSERT INTO #PersonContactInfo(
	BusinessEntityID,
	Title,
	FirstName,
	MiddleName,
	LastName
)

SELECT
	BusinessEntityID,
	Title,
	FirstName,
	MiddleName,
	LastName
FROM AdventureWorks2019.Person.Person

-- B는 참조테이블로 join 해서 가져오는 소스테이블 

UPDATE A -- 테이블 B에서 보여줘야하는것, 조인으로 엮인 컬럼과 보여줘야할 컬럼 셀렉
SET	
	PhoneNumber = B.PhoneNumber,
	PhoneNumberTypeID = B.PhoneNumberTypeID
FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID

UPDATE A
SET
	PhoneNumberType = C.Name
FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PhoneNumberType C
		ON A.PhoneNumberTypeID = C.PhoneNumberTypeID

UPDATE A
SET
	EmailAddress = D.EmailAddress
FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.EmailAddress D
		ON A.BusinessEntityID = D.BusinessEntityID