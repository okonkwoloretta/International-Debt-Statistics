-- Viewing the first 10 columns from the international_debt table
SELECT TOP (10) [country_name]
      ,[country_code]
      ,[indicator_name]
      ,[indicator_code]
      ,[debt]
  FROM [International Debt].[dbo].[international_debt]

  -- Finding the number of distinct countries
  SELECT COUNT(DISTINCT country_name) AS total_countries
  FROM international_debt

  -- Finding out the distinct debt indicators
  SELECT DISTINCT indicator_code AS dist_debt_code
  FROM international_debt

  --Totaling the amount of debt owed by the countries
  SELECT ROUND(SUM (debt/1000000), 2)AS total_debt
FROM international_debt

--Country with the highest debt
SELECT TOP(1) country_name, SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC

---Country and the category with highest debt
SELECT TOP(1) country_name, indicator_name AS category, SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name, indicator_name
ORDER BY total_debt DESC

--Average amount of debt across indicators
SELECT TOP(10)
      indicator_code AS debt_indicator,
      indicator_name,
      AVG(debt) AS average_debt
FROM international_debt
GROUP BY indicator_code,indicator_name
ORDER BY average_debt DESC

--The highest amount of principal repayments
SELECT 
    country_name, 
    indicator_name
FROM international_debt
WHERE debt = (SELECT 
                  MAX(debt)
              FROM international_debt
              WHERE indicator_code='DT.AMT.DLXF.CD')


--The most common debt indicator
SELECT TOP(10) indicator_code, 
       COUNT(indicator_code) AS indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC 

--Viable debt issues
SELECT TOP(10) country_name, MAX(debt) AS maximum_debt
FROM international_debt
GROUP BY country_name
ORDER BY maximum_debt DESC