-- Data Cleaning 
 SELECT *
 FROM layoffs;
 -- -- first thing we want to do is create a staging table. 
 -- This is the one we will work in and clean the data. 
 -- We want a table with the raw data in case something happens

 
 -- steps of cleaning data using Sql 
 -- Remove Duplicates 
 -- Satandrize the data 
 -- Null values or blank values
 -- Remove Any Column 
 
 CREATE TABLE layoffs_staging
 LIKE layoffs;
 
  SELECT *
  FROM layoffs_staging;
  
  INSERT layoffs_staging
  SELECT *
  FROM layoffs;
  
  SELECT *
  FROM layoffs_staging;
  
   -- Remove Duplicates 
     
     SELECT *,
     ROW_NUMBER() OVER(PARTITION BY
     company,industry,total_laid_off,percentage_laid_off,'date')AS row_num
     FROM layoffs_staging;
     
     
     
     WITH duplicate_cte AS 
     (
      SELECT *,
     ROW_NUMBER() OVER(PARTITION BY
     company,location,industry,total_laid_off,percentage_laid_off,'date',stage
     ,country,funds_raised_millions)AS row_num
     FROM layoffs_staging
    )
    SELECT *
    FROM duplicate_cte 
    WHERE row_num > 1;
    
   -- let's just look at oda to confirm   
  SELECT *
  FROM layoffs_staging
  WHERE company = 'Casper';
  
  
   WITH duplicate_cte AS 
     (
      SELECT *,
     ROW_NUMBER() OVER(PARTITION BY 
     company,location,industry,total_laid_off,
     percentage_laid_off,'date',stage,
     country,funds_raised_millions)AS row_num
     FROM layoffs_staging
    )
    Delete
    FROM duplicate_cte 
    WHERE row_num > 1;
    
    
  
  -- Create the Table to delete duplicated 
  CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 SELECT *
  FROM layoffs_staging2;

  -- Insert the table to column 
  
      INSERT INTO layoffs_staging2
       SELECT *,
     ROW_NUMBER() OVER(PARTITION BY 
     company,location,industry,total_laid_off,
     percentage_laid_off,'date',stage,
     country,funds_raised_millions)AS row_num
     FROM layoffs_staging;
     
   
  SELECT *
  FROM layoffs_staging2
  WHERE row_num > 1;
  
  SET SQL_SAFE_UPDATES = 0;
  
  DELETE
  FROM layoffs_staging2
  WHERE row_num > 1;
  
  -- test the code 
   SELECT *
  FROM layoffs_staging2
  WHERE row_num > 1;
  
   SELECT *
  FROM layoffs_staging2;
  
  -- THE FIRST STEP DUPLICATED IS DONE 
  -- NOW WE ARE GO TO STANTRIZATION
  -- IS funiding issues and fix it 
  
  SELECT DISTINCT (company) -- to know the distinct the rows 
  FROM layoffs_staging2;
  
  SELECT company,TRIM(company) -- this to remove the distince 
  FROM layoffs_staging2;
  
  UPDATE layoffs_staging2  -- update the column of company 
  SET company = TRIM(company);
  
   SELECT DISTINCT (industry) -- to know the distinct the rows 
  FROM layoffs_staging2
  order by 1;
  
  SELECT *   -- To know how many rows in industry column contain to crypto 
  FROM layoffs_staging2
  where industry like 'crypto%';
  
  -- To remove the rows that contain the empty value and null value 
    UPDATE layoffs_staging2
    SET industry = 'Crypto'
  where industry like 'Crypto%';
  
    SELECT DISTINCT (industry) -- to cheek the change 
  FROM layoffs_staging2;
  
    SELECT distinct (location) -- this is not empty and contain space 
  FROM layoffs_staging2
  order by 1;
  
  SELECT distinct country
  FROM layoffs_staging2
  WHERE country like 'United States%'
  order by 1;
  
   SELECT *
  FROM layoffs_staging2
  WHERE country like 'United States%'
  order by 1;
  
  SELECT DISTINCT country,TRIM(TRAILING '.' FROM country)
  FROM layoffs_staging2
  order by 1;
  
  UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
where country like 'United States%';
  
  select date,
  str_to_date(`date`, '%m/%d/%Y')
  from layoffs_staging2;
  
    select date
  FROM  layoffs_staging2;
-- we can use str to date to update this field
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

  select date           -- cheek the change 
  FROM  layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

 SELECT  *
  FROM  layoffs_staging2
  WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;   
  
  UPDATE layoffs_staging2
  SET industry = NULL
  WHERE industry = '';
  
  SELECT *
  FROM layoffs_staging2
  WHERE industry IS NULL
  OR industry = '';

    SELECT *
	FROM layoffs_staging2
    WHERE company LIKE 'Bally%';


    SELECT t1.industry,t2.industry
    FROM layoffs_staging2 t1
    JOIN layoffs_staging2 t2
      ON t1.company = t2.company
     -- AND t1.location = t2.location
      WHERE (t1.industry IS NULL OR t1.industry='')
      AND t2.industry IS NOT NULL;
    
    
    UPDATE layoffs_staging2 t1
    JOIN layoffs_staging2 t2
     ON t1.company = t2.company
     SET t1.industry = t2.industry
	WHERE t1.industry IS NULL 
     AND t2.industry IS NOT NULL;

    
    SELECT *  -- cheek the data
	FROM layoffs_staging2;
    
     SELECT  *
  FROM  layoffs_staging2
  WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL; 
  
  DELETE 
  FROM  layoffs_staging2
  WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL; 
  
  SELECT *
  FROM layoffs_staging2;
  
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
    
    
    