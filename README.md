# Layoffs-data-analysis-sql-python-power-bi
End-to-end data analysis of global layoffs dataset. The project covers data cleaning (handling missing values and partial duplicates), exploratory data analysis, and visualization to uncover trends over time, company impact, and industry patterns using SQL, Python, and Power BI


 Problem Statement

In recent years, layoffs have significantly impacted companies across various industries worldwide. However, understanding the patterns behind these layoffs—such as when they occur, which companies are most affected, and how different factors like company stage or location influence layoffs—remains a challenge.

This project aims to analyze a global layoffs dataset to uncover trends over time, identify key drivers of layoffs, and provide insights into how layoffs vary across companies, industries, and regions.

⸻

 Data Cleaning Steps

The dataset was cleaned and prepared through the following steps:
	•	Removed full duplicate rows to eliminate redundant records
	•	Identified partial duplicates based on (company, date) and consolidated them to preserve complete information
	•	Handled missing values:
	•	Retained null values in percentage_laid_off as they represent unreported data
	•	Removed rows with missing stage due to their minimal proportion
	•	Converted date column to proper datetime format
	•	Checked and validated outliers to ensure they represent real-world events and not data errors
	•	Standardized column formats and ensured consistency across categorical values

⸻

 Key Insights
	•	Layoffs showed clear peaks during certain periods, indicating possible economic downturns
	•	Large companies contributed the highest number of layoffs compared to smaller startups
	•	A significant portion of companies did not disclose layoff percentages
	•	Layoff patterns varied across company stages, with later-stage companies showing higher impact
	•	Certain countries and industries were more affected than others
	•	Extreme values (large layoffs) were found to represent real events rather than anomalies

⸻

 Tools Used
	•	SQL → data extraction and data cleaning and analysis
	•	Python (Pandas, Matplotlib) → data visualization 
	•	Power BI → data visualization and dashboard creation
