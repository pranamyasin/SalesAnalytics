## DATA ANALYTICS USING GOOGLE ADS DATASET
### SOURCE : Kaggle ( https://www.kaggle.com/datasets/nayakganesh007/google-ads-sales-dataset )

The project aims to analyze the performance of the Ad campaign for the Data Analytics course, using MySQL for Data Manipulation and Analysis, and Tableau for visualization. The primary goal was to clean and process the raw dataset to be able to analyze and uncover the insights.

#### Tools
My SQL  : Data cleaning, manipulation and query based insights
Tableau : Data Visualization

#### SQL Analysis
* Verified dataset structure (columns, null values, data types).
* Identified inconsistencies in null values due to text-based import.
* Ensured data consistency before visualization.

#### Key Insights
Clicks vs. Conversions: 
* High number of clicks, but fewer conversions indicate low purchase intent.
  
Cost & Sales Distribution:
* Out of 2,328 records, 1,137 had cost above average (215.21).
* 1,119 had sales above average (1,495.25).
  
Keywords:
* “Learn data analytics” drove the highest profit.
* “Data analitics online” drove the lowest profit.
* 6 keywords strongly impacted sales performance.
  
Ad Performance:
* Ads A1738 and A2113 achieved the highest sales (2,000 each).
* A1738 generated more profit due to lower cost.
* No ad ran at a loss (all costs recovered).
  
Device Trends:
* Cost distribution is similar across devices; clicks capped at 199.
* Highest sales came from Desktop & Tablet.
* Mobile had the highest cost, sales, and clicks overall.
  
Time Trends:
* Data covers November 2024 only.
* Saturday generated the most revenue, followed by Friday.
* Sunday had the least revenue.

#### Tableau Visualization
The cleaned SQL dataset was visualized in Tableau to highlight:
* Performance across different devices in terms of impressions and clicks
* Sales by Devices
* Time-based impressions throughout the week.
* KPI (Conversion rate, cost, and sale amount) Trend
* Leads and clicks through each keyword

Tableau Source : https://public.tableau.com/app/profile/pranamya6125/viz/Ads_Analytics/Story2


## Conclusion

* Ads were overall profitable.
* KPI's increased consistently throughout the week, with a sudden hike on Fridays.
* Almost all devices showcased similar clicks and impressions. However, during week 45, there was a sudden increase in impressions with all devices, while in week 47, mobile and desktop showed a similar hike, leaving tablet behind.



