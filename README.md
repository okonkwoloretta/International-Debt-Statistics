
# Analysis of World Bank's International Debt Data

![bank-notes](https://github.com/okonkwoloretta/International-Debt-Statistics/assets/116097143/ff081e2a-39ee-45bd-b1e7-6c7de0967b50)


It's not that we humans only take debts to manage our necessities. A country may also take debt to manage its economy. 

## Objective:

The objective of this project is to analyze international debt data collected by the [World Bank](https://www.worldbank.org/en/home) to gain insights into the total amount of debt, countries with the highest debt, average debt across different indicators, and identify viable debt issues.

## Dataset:

The dataset used in this project contains 2,358 rows and the following column names: country_name, country_code, indicator_name, indicator_code, and debt. It was sourced from DataCamp.

## Overview:
The project explores the international debt landscape by analyzing the World Bank's dataset. 
By examining different debt indicators, we aim to understand the distribution of debt among countries and identify key insights into their economic conditions.

## Steps:

We are going to find the answers to questions like:

- What is the total amount of debt that is owed by the countries listed in the dataset?
- Which country owns the maximum amount of debt and what does that amount look like?
- What is the average amount of debt owed by countries across different debt indicators?

Also, I'll limit the output to the first ten rows to keep the output clean.

```sql
-- Viewing the first 10 columns from the international_debt table
SELECT TOP (10) [country_name]
      ,[country_code]
      ,[indicator_name]
      ,[indicator_code]
      ,[debt]
  FROM [International Debt].[dbo].[international_debt]
```

  Output 
|country_name	|country_code	|indicator_name	|indicator_code	|debt|
--------------|--------------|--------------|----------------|-----|
Afghanistan|	AFG	|Disbursements on external debt, long-term (DIS, current US$)|	DT.DIS.DLXF.CD	|72894456
Afghanistan|	AFG	|Interest payments on external debt, long-term (INT, current US$)|	DT.INT.DLXF.CD|	53239440
Afghanistan|	AFG	|PPG, bilateral (AMT, current US$)|	DT.AMT.BLAT.CD|	61739336
Afghanistan|	AFG	|PPG, bilateral (DIS, current US$)|	DT.DIS.BLAT.CD|	49114728
Afghanistan|	AFG	|PPG, bilateral (INT, current US$)|	DT.INT.BLAT.CD|	39903620
Afghanistan|	AFG	|PPG, multilateral (AMT, current US$)|	DT.AMT.MLAT.CD|	39107844
Afghanistan|	AFG	|PPG, multilateral (DIS, current US$)|	DT.DIS.MLAT.CD|	23779724
Afghanistan|	AFG	|PPG, multilateral (INT, current US$)|	DT.INT.MLAT.CD|	13335820
Afghanistan|	AFG	|PPG, official creditors (AMT, current US$)|	DT.AMT.OFFT.CD|	100847184
Afghanistan|	AFG	|PPG, official creditors (DIS, current US$)|	DT.DIS.OFFT.CD|	72894456  

From the first ten rows, we can see the amount of debt owed by Afghanistan in the different debt indicators. 
But we do not know the number of different countries we have on the table. 
There are repetitions in the country names because a country is most likely to have debt in more than one debt indicator.

Without a count of unique countries, we will not be able to perform our statistical analyses holistically. In this section, 
we are going to extract the number of unique countries present in the table.

```sql
 -- Finding the number of distinct countries
  SELECT COUNT(DISTINCT country_name) AS total_countries
  FROM international_debt
```

Output
|total_countries|
|---------------|
|124|

We can see there are a total of 124 countries present on the table. 
As we saw in the first section, there is a column called indicator_name that briefly specifies the purpose of taking the debt. 
Just beside that column, there is another column called indicator_code which symbolizes the category of these debts. 
Knowing about these various debt indicators will help us to understand the areas in which a country can possibly be indebted to.

```sql
  -- Finding out the distinct debt indicators
  SELECT DISTINCT indicator_code AS dist_debt_code
  FROM international_debt
```

Output
|dist_debt_code|
|--------------|
|DT.DIS.DLXF.CD|
|DT.AMT.PBND.CD|
|DT.AMT.DPNG.CD|
|DT.AMT.DLXF.CD|
|DT.DIS.MLAT.CD|
|DT.AMT.PCBK.CD|
|DT.INT.DPNG.CD|
|DT.INT.PCBK.CD|
|DT.AMT.OFFT.CD|
|DT.DIS.PROP.CD|

Let's move from the debt indicators now and find out the total amount of debt (in USD) that is owed by the different countries. 
This will give us a sense of how the overall economy of the entire world is holding up.

```sql
 --Totaling the amount of debt owed by the countries
  SELECT ROUND(SUM (debt/1000000), 2)AS total_debt
FROM international_debt
```

Output
|total_debt|
|----------|
|3079734.49|

"Human beings cannot comprehend very large or very small numbers. It would be useful for us to acknowledge that fact." - [Daniel Kahneman](https://en.wikipedia.org/wiki/Daniel_Kahneman). 
That is more than 3 million million USD, an amount which is really hard for us to fathom.

Now that we have the exact total of the amounts of debt owed by several countries, 
let's now find out the country that owns the highest amount of debt along with the amount. 
Note that this debt is the sum of different debts owed by a country across several categories. 
This will help to understand more about the country in terms of its socio-economic scenarios. 
We can also find out the category in which the country owns its highest debt. 

```sql
--Country with the highest debt
SELECT TOP(1) country_name, SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt DESC
```
Output
|country_name	|total_debt|
|-------------|-----------|
|China|	285793490528|

So, it was China. A more in-depth breakdown of China's debts can be found [here](https://datatopics.worldbank.org/debt/ids/country/CHN).

```sql
---Country and the category with highest debt
SELECT TOP(1) country_name, indicator_name AS category, SUM(debt) AS total_debt
FROM international_debt
GROUP BY country_name, indicator_name
ORDER BY total_debt DESC
```

Output
|country_name|	category	|total_debt|
|------------|------------|----------|
|China|	Principal repayments on external debt, long-term (AMT, current US$)	|96218619904|

We now have a brief overview of the dataset and a few of its summary statistics. 
We already have an idea of the different debt indicators in which the countries owe their debts. 
We can dig even further to find out on an average how much debt a country owes? 
This will give us a better sense of the distribution of the amount of debt across different indicators

```sql
--Average amount of debt across indicators
SELECT TOP(10)
      indicator_code AS debt_indicator,
      indicator_name,
      AVG(debt) AS average_debt
FROM international_debt
GROUP BY indicator_code,indicator_name
ORDER BY average_debt DESC
```

Output
|debt_indicator|	indicator_name	|average_debt|
|--------------|------------------|------------|
|DT.AMT.DLXF.CD|	Principal repayments on external debt, long-term (AMT, current US$)	|5904868420.41331|
|DT.AMT.DPNG.CD|	Principal repayments on external debt, private nonguaranteed (PNG) (AMT, current US$)	|5161194287.74031|
|DT.DIS.DLXF.CD|	Disbursements on external debt, long-term (DIS, current US$)	|2152041234.12195|
|DT.DIS.OFFT.CD|	PPG, official creditors (DIS, current US$)	|1958983442.45082|
|DT.AMT.PRVT.CD|	PPG, private creditors (AMT, current US$)	|1803694085.62404|
|DT.INT.DLXF.CD|	Interest payments on external debt, long-term (INT, current US$)	|1644024072.83569|
|DT.DIS.BLAT.CD|	PPG, bilateral (DIS, current US$)	|1223139290.37301|
|DT.INT.DPNG.CD|	Interest payments on external debt, private nonguaranteed (PNG) (INT, current US$)	|1220410845.30854|
|DT.AMT.OFFT.CD|	PPG, official creditors (AMT, current US$)	|1191187964.1875|
|DT.AMT.PBND.CD|	PPG, bonds (AMT, current US$)	|1082623945.41667|

We can see that the indicator DT.AMT.DLXF.CD tops the chart of average debt. 
This category includes repayment of long term debts. Countries take on long-term debt to acquire immediate capital. 
More information about this category can be found [here](https://datacatalog.worldbank.org/principal-repayments-external-debt-long-term-amt-current-us-0).

An interesting observation in the above finding is that there is a huge difference in the amounts of the indicators after the second one. 
This indicates that the first two indicators might be the most severe categories in which the countries owe their debts.

We can investigate this a bit more so as to find out which country owes the highest amount of debt in the category of long term debts (DT.AMT.DLXF.CD). 
Since not all the countries suffer from the same kind of economic disturbances, this finding will allow us to understand that particular country's economic condition a bit more specifically.

```sql
--The highest amount of principal repayments
SELECT 
    country_name, 
    indicator_name
FROM international_debt
WHERE debt = (SELECT 
                  MAX(debt)
              FROM international_debt
              WHERE indicator_code='DT.AMT.DLXF.CD')
```

Output
|country_name	|indicator_name|
|-------------|--------------|
|China	|Principal repayments on external debt, long-term (AMT, current US$)|

China has the highest amount of debt in the long-term debt (DT.AMT.DLXF.CD) category. 
This is verified by The [World Bank](https://data.worldbank.org/indicator/DT.AMT.DLXF.CD?end=2018&most_recent_value_desc=true).
It is often a good idea to verify our analyses like this since it validates that our investigations are correct.

We saw that long-term debt is the topmost category when it comes to the average amount of debt. 
But is it the most common indicator in which the countries owe their debt? 

Let's find that out.

```sql
--The most common debt indicator
SELECT TOP(10) indicator_code, 
       COUNT(indicator_code) AS indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC
```

Output
|indicator_code	|indicator_count|
|---------------|---------------|
|DT.INT.OFFT.CD	|124|
|DT.INT.MLAT.CD	|124|
|DT.INT.DLXF.CD	|124|
|DT.AMT.OFFT.CD	|124|
|DT.AMT.MLAT.CD	|124|
|DT.AMT.DLXF.CD	|124|
|DT.DIS.DLXF.CD	|123|
|DT.INT.BLAT.CD	|122|
|DT.DIS.OFFT.CD	|122|
|DT.AMT.BLAT.CD	|122|

There are a total of six debt indicators in which all the countries listed in our dataset have taken debt. 
The indicator DT.AMT.DLXF.CD is also there in the list. So, this gives us a clue that all these countries are suffering from a common economic issue. 
But that is not the end of the story, but just a part of the story.

Let's move from debt_indicators now and focus on the amount of debt again. Let's find out the maximum amount of debt that each country has.
With this, we will be in a position to identify the other plausible economic issues a country might be going through.

In this project, we took a look at debt owed by countries across the globe. 
We extracted a few summary statistics from the data and unraveled some interesting facts and figures. 
We also validated our findings to make sure the investigations are correct.

```sql
--Viable debt issues
SELECT TOP(10) country_name, MAX(debt) AS maximum_debt
FROM international_debt
GROUP BY country_name
ORDER BY maximum_debt DESC
```

Output
|country_name|	maximum_debt|
|------------|-------------|
|China	|96218619904
|Brazil	|90041843712
|Russian Federation	|66589761536
|Turkey	|51555028992
|South Asia	|48756297728
|Least developed countries: UN classification	|40160768000
|IDA only	|34531188736
|India	|31923507200
|Indonesia	|30916112384
|Kazakhstan	|27482093568


