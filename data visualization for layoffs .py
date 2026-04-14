#!/usr/bin/env python
# coding: utf-8

# In[31]:


# Importing Libaries ToolKit
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


# # Exploring a Data Analysis

# In[3]:


# Importing & Inspecting Data
data = pd.read_csv('layoffs after clean.csv')


# In[8]:


data.shape


# In[4]:


data.head(10)


# In[6]:


data.columns


# In[14]:


data.info()


# In[15]:


# Handle Missing Values
print(data.isna().sum())


# In[21]:


# Dropped rows with missing values in stage as they represented a very small proportion (<0.3%)
# of the dataset and could not be reliably imputed.
data = data.dropna(subset=['stage'])
data = data.dropna(subset=['date'])
data = data.dropna(subset=['industry'])


# In[24]:


# Handle Missing Values
print(data.isna().sum())


# In[23]:


#Plotting missing values
data.isna().sum().plot(kind="bar")
plt.show()


# In[27]:


# check duplicated values
data.duplicated().sum()


# In[26]:


data[data.duplicated(keep=False)]


# Partial duplicates were identified based on key fields such as company and date.
# Since these records were not fully identical and contained complementary information,
# they were not removed. Instead, they were considered for consolidation to preserve data integrity.
# 
# 

# In[29]:


# find the outlier and handle 
data.describe()


# In[35]:


# Insight: Identify major companies driving layoffs
# Question: Which companies have the highest layoffs?

top_companies = data.groupby('company')['total_laid_off'].sum().sort_values(ascending=False).head(10)
top_companies.plot(kind='bar')
plt.title("Top 10 Companies by Total Layoffs")
plt.xlabel("Company")
plt.ylabel("Total Laid Off")
plt.xticks(rotation=45)
plt.show()


# In[39]:


# Insight: Understand which sectors are unstable
# 2. Question: Which industries are most affected?

industry = data.groupby('industry')['total_laid_off'].sum().sort_values(ascending=False).head(10)
industry.plot(kind='bar')
plt.title("Layoffs by Industry")
plt.xlabel("Industry")
plt.ylabel("Total Laid Off")
plt.xticks(rotation=45)
plt.show()


# In[43]:


# Insight: Detect peaks and crisis periods
# 4. Question: How do layoffs change over time?

data['date'] = pd.to_datetime(data['date'])
data['month'] = data['date'].dt.to_period('M')
monthly = data.groupby('month')['total_laid_off'].sum()

monthly.plot()
plt.title("Monthly Layoffs Trend")
plt.xlabel("Month")
plt.ylabel("Total Laid Off")
plt.show()


# In[48]:


# 5. Question: Which company stages are most affected?
# 5. Question: Which company stages are most affected?
stage = data.groupby('stage')['total_laid_off'].sum().head(10)

stage.plot(kind='pie', autopct='%1.1f%%')
plt.title("Layoffs by Company Stage")
plt.show()


# In[49]:


# Insight: Check if funding protects companies
# 6. Question: Is there a relationship between funding and layoffs?

plt.scatter(data['funds_raised_millions'], data['total_laid_off'])
plt.title("Funding vs Layoffs")
plt.xlabel("Funds Raised (Millions)")
plt.ylabel("Total Laid Off")
plt.show()


# In[50]:


# Insight: Check if funding protects companies
# 7. Question: How severe are layoffs (percentage)?

data['percentage_laid_off'] = pd.to_numeric(data['percentage_laid_off'], errors='coerce')

data['percentage_laid_off'].dropna().hist()
plt.title("Layoff Percentage Distribution")
plt.xlabel("Percentage")
plt.show()



# In[51]:


# Insight: Identify major affected cities
# 8. Question: Which locations (cities) are most affected?

location = data.groupby('location')['total_laid_off'].sum().sort_values(ascending=False).head(10)

location.plot(kind='bar')
plt.title("Top Locations by Layoffs")
plt.xticks(rotation=45)
plt.show()


# In[52]:


# 3. Layoffs by Country
country = data.groupby('country')['total_laid_off'].sum().sort_values(ascending=False).head(10)

plt.figure()
country.plot(kind='bar')
plt.title("Top Countries by Layoffs")
plt.xticks(rotation=45)
plt.show()


# In[59]:


# 9. Yearly Trend

data['year'] = data['date'].dt.year

yearly = data.groupby('year')['total_laid_off'].sum()

plt.figure()
yearly.plot(kind='bar')
plt.title("Layoffs by Year")
plt.show()


# In[ ]:




