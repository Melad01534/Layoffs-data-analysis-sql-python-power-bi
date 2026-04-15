-- ============================================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- ============================================

-- 1. VIEW DATA
SELECT *
FROM world_layoffs.layoffs_staging2;

-- ============================================
-- 2. BASIC METRICS
-- ============================================

-- Maximum layoffs in a single record
SELECT MAX(total_laid_off) AS max_layoffs
FROM world_layoffs.layoffs_staging2;

-- Percentage layoffs range
SELECT 
    MAX(percentage_laid_off) AS max_percentage,
    MIN(percentage_laid_off) AS min_percentage
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;

-- ============================================
-- 3. EXTREME CASES (100% LAYOFFS)
-- ============================================

-- Companies with 100% layoffs
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;

-- Sort by funding (largest companies affected)
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- ============================================
-- 4. TOP COMPANIES & LOCATIONS
-- ============================================

-- Biggest single layoff events
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 5;

-- Companies with highest total layoffs
SELECT company, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;

-- Top locations by layoffs
SELECT location, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 10;

-- ============================================
-- 5. LAYOFFS BY CATEGORY
-- ============================================

-- By country
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC;

-- By year
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY year;

-- By industry
SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;

-- By company stage
SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;

-- ============================================
-- 6. TOP COMPANIES PER YEAR (ADVANCED)
-- ============================================

WITH company_year AS (
    SELECT 
        company, 
        YEAR(`date`) AS year, 
        SUM(total_laid_off) AS total_layoffs
    FROM world_layoffs.layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
company_rank AS (
    SELECT 
        company, 
        year, 
        total_layoffs,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY total_layoffs DESC
        ) AS ranking
    FROM company_year
)
SELECT *
FROM company_rank
WHERE ranking <= 3
AND year IS NOT NULL
ORDER BY year, total_layoffs DESC;

-- ============================================
-- 7. MONTHLY TREND
-- ============================================

-- Monthly layoffs
SELECT 
    DATE_FORMAT(`date`, '%Y-%m') AS month,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY month
ORDER BY month;

-- ============================================
-- 8. ROLLING TOTAL (ADVANCED)
-- ============================================

WITH monthly_data AS (
    SELECT 
        DATE_FORMAT(`date`, '%Y-%m') AS month,
        SUM(total_laid_off) AS total_layoffs
    FROM world_layoffs.layoffs_staging2
    GROUP BY month
)
SELECT 
    month,
    SUM(total_layoffs) OVER (ORDER BY month) AS rolling_total
FROM monthly_data
ORDER BY month;

-- ============================================
-- END OF EDA
-- ============================================