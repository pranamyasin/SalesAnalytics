create database Ads_Sales;
use Ads_Sales;

ALTER TABLE ads_sales.googleads_dataanalytics_sales_uncleaned
RENAME TO ads_data;

#---UNDERSTAND THE DATASET---
SELECT * FROM ads_data;
DESC ads_data;
/*NOTE 
- Data is either in text or double format
- Since we have undertaken a single csv file Keys are not present
*/

#---Is there any repeated Ad_ID ?
SELECT Ad_Id, COUNT(Ad_ID) as Repeation
FROM ads_data
GROUP BY Ad_ID
HAVING COUNT(Ad_ID)>1;

-- Each row has distinct Ad_ID


#---Preprocessing Dataset---

SELECT Distinct Campaign_Name
FROM ads_data;

UPDATE ads_data
SET Campaign_Name = "Data Analytics Course";

SELECT DISTINCT Location
FROM ads_data;

UPDATE ads_data
SET Location = 'Hyderabad';

SELECT DISTINCT Device
FROM  ads_data;

SELECT DISTINCT Ad_Date
FROM ads_data;

DESCRIBE ads_data;

SELECT Ad_Date
FROM ads_data
WHERE Ad_Date is NULL;

-- No null Values present

SELECT 
CASE
 WHEN Ad_Date LIKE '%-%' AND LENGTH(AD_Date)=10 THEN 'yyyy-mm-dd or dd-mm-yyyy'
 WHEN Ad_Date LIKE '%/%' AND LENGTH(AD_Date)=10 THEN 'dd/mm/yyyy or yyyy/mm/dd'
 ELSE 'UNKNOWN'
END AS 'Date_Type',
COUNT(*) as Count_Format
FROM ads_data
GROUP BY Date_Type;

-- Therefore, all the rows are in these 2 format which we have to make consistent

ALTER TABLE ads_data ADD COLUMN Format_Date DATE;

UPDATE ads_data
SET Format_Date =
CASE
 WHEN Ad_Date LIKE "%-%" AND SUBSTRING(Ad_Date,3,1) ='-'
   THEN STR_TO_DATE(Ad_Date, '%d-%m-%Y')
 WHEN Ad_Date LIKE "%-%" AND SUBSTRING(Ad_Date, 5,1) ='-'
   THEN STR_TO_DATE(AD_Date, "%Y-%m-%d")
 WHEN Ad_Date LIKE "%/%" AND SUBSTRING(Ad_Date,3,1)='/'
   THEN STR_TO_DATE(Ad_Date, "%d/%m/%Y")
 WHEN Ad_Date LIKE "%/%" AND SUBSTRING(Ad_Date,5,1)='/'
   THEN STR_TO_DATE(AD_Date,  "%Y/%m/%d")
 ELSE NULL
 END;
 
 SELECT Ad_date, Format_Date
 FROM ads_data
 
 -- WHOLE AD_DATE COLUMN BECAME CONSITENT IN YYYY-MM-DD FORMAT
 

SHOW COLUMNS FROM Ads_data LIKE '%Conversion%';

ALTER TABLE ads_data
RENAME COLUMN `Conversion Rate`  TO Conversion_Rate;

SELECT DISTINCT Conversions, Conversion_Rate
FROM ads_data;

-- Few rows contains conversions without conversion_rate

SELECT DISTINCT Clicks, Conversions, Conversion_Rate
FROM ads_data;

-- Clicks are present so it becomes easy to calculate conversion rate

SELECT Clicks 
From ads_data
WHERE Clicks is NULL;

-- No Null in clicks
SELECT DISTINCT Conversion_Rate
From ads_data
ORDER BY Conversion_Rate;

SELECT Conversion_Rate
FROM ads_data
WHERE (Conversions/Clicks) is NULL;

UPDATE ads_data
SET Conversion_Rate = NULL
WHERE Conversion_Rate = '';


SELECT COUNT(*) as No_CR
FROM ads_data
Where Conversion_Rate is NULL;

-- In Total 458 rows have undefined conversion rate 

UPDATE ads_data
SET Conversion_Rate = Conversions/Clicks
WHERE Conversion_Rate is NULL;

UPDATE ads_data
SET Conversion_Rate = ROUND(Conversion_Rate,3);

-- Every row now contains conversion rate

UPDATE ads_data   # performed same for sales_amount
SET Cost= NULL
WHERE Cost = '';

Select count(*) 
from ads_data
where Cost is NULL;

-- 121 rows does not contain sale amount while 84 rows lacks cost

UPDATE ads_data      
SET Cost = REPLACE(REPLACE(Cost, '$', ''),',','');

UPDATE ads_data      
SET Sale_Amount = REPLACE(Sale_Amount, '$', '');

ALTER TABLE ads_data
MODIFY COLUMN Cost DECIMAL(10,2),
MODIFY COLUMN Sale_Amount DECIMAL(10);

#---Analysing the dataset---

-- 1. DATA QUALITY ANALYSIS

SELECT COUNT(*)
FROM ads_data
WHERE Conversions > Clicks;

-- Clicks are more that tells the data is correct, since person clicks on ads many time but idea of purchase or to add value to business is less.

SELECT AVG(COST) FROM ads_data;

SELECT COUNT(*)
FROM ads_data
WHERE COST > (SELECT AVG(COST) FROM ads_data)

-- From 2328, 1137 rows has cost more than average which is 215.21

SELECT AVG(Sale_Amount) FROM ads_data;

SELECT COUNT(*)
FROM ads_data
WHERE Sale_Amount > (SELECT AVG(Sale_Amount) FROM ads_data);

-- From 2328, 1119 rows has sale amount more than average which is 1495.25

SELECT DISTINCT (Keyword)
FROM ads_data;

-- In total there are 6 keywords impacting the sales 

-- 2. Analysing Profits

SELECT * FROM ads_data;

SELECT count(*)
FROM ads_data
WHERE Cost >= Sale_Amount;
 
-- None of the ads have faced loss since all the cost was recovered

SELECT * 
FROM ads_data
WHERE Sale_Amount =( SELECT max(Sale_Amount) From ads_data);

-- Ad_ID of A1738 and A2113 gave maximum Sale Amount of 2000 on 2024-11-02 and 2024-11-20 respectively. 
-- However more profit is earned by A1738 since the cost was less

-- IMPACT OF KEYWORD TO COST
SELECT DISTINCT(keyword), SUM(COST) as "Total_Cost_per_keyword"
FROM ads_data
GROUP BY keyword
ORDER BY Total_Cost_per_keyword;

-- Highest Cost of the ad contains keyword of learn data analytics followed by online data analytics
-- Lowest Cost of the ad contains keyword of data analytics training followed by data analitics online

-- Impact of KEYWORD TO SALE_AMOUNT
SELECT DISTINCT(keyword), SUM(Sale_Amount) as "Total_Saleamt_per_keyword"
FROM ads_data
GROUP BY keyword
ORDER BY Total_Saleamt_per_keyword;

-- Highest sale amount from the ad contains keyword same as the cost 
-- For lowest sale amount ad has keyword data analitics online followed by data analytics training

# Calculate PROFIT

SELECT KEYWORD,
SUM(Sale_Amount - Cost) as Profit
FROM ads_data
GROUP BY keyword
ORDER BY Profit;

-- Highest Profit has come with Keyword "learn data analytics" followed by "data analytrics course"  , "online data analytic"
-- Lowest Profit has come with  Keyword " data analitics online" followed by "data analytics training" ,"analytics for data"

# Keywords with highest Clicks but lowest Conversion

SELECT Keyword, 
SUM(Clicks) as "TOTAL_CLICKS",
SUM(Conversions) as "TOTAL_CONV"
FROM ads_data
GROUP BY Keyword
ORDER BY TOTAL_CLICKS DESC, TOTAL_CONV ASC;

-- All the keywords had more clicks and less total conv\

# Relation of devices with clicks, cost and sale amount

SELECT Device,
MAX(COST) as "Max_Cost",
MAX(Sale_Amount) as "Max_Sale",
Max(Clicks) as "Max_Clicks"
FROM ads_data
GROUP BY Device;

-- Cost for each device is almost similar and the maximum clicks for all is same of 199. However the highest sale is through desktop and tablet of 2000

SELECT Device,
SUM(COST) as "Total_Cost",
SUM(Sale_Amount) as "Total_Sale",
SUM(Clicks) as "Total_Clicks"
FROM ads_data
GROUP BY Device
ORDER BY Total_Clicks ASC;

-- The highest cost,sales and clicks is through mobile, followed by desktop and then with tablet.

# Understand if the ad_date(changed to format_date) has any relation to revenue

SELECT DATE_FORMAT(STR_TO_DATE(	Format_Date, '%Y-%m-%d'), '%Y-%m') AS Month,
SUM(Sale_Amount) AS Total_Revenue
FROM ads_data
GROUP BY Month
ORDER BY Month;

 -- Month of nov 2024 is only present in the dataset
 
SELECT DAYNAME(STR_TO_DATE(Format_Date, '%Y-%m-%d')) AS Weekday,
SUM(Sale_Amount) AS Total_Revenue
FROM ads_data
GROUP BY Weekday
ORDER BY Total_Revenue DESC;

-- Maximum revenue is generated on Saturday followed by Friday while least is on Sunday.

