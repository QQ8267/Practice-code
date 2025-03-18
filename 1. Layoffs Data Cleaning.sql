-- Data Cleaning --

SET SQL_SAFE_UPDATES = 0;

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values
-- 4. Remove Unnecessary Rows and Columns


# Create duplicates of raw data to manipulate it
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

# 1. Removing Duplicates ---------------------------

# Check if row number is > 2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
;

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company ='Casper';

#(second way)
SELECT 
    company,
    location,
    date,
    industry,
    total_laid_off,
    percentage_laid_off,
    stage,
    country,
    funds_raised_millions,
    COUNT(*)
FROM
    layoffs_staging
GROUP BY company , location , date , industry ,  total_laid_off , percentage_laid_off , stage , country , funds_raised_millions
HAVING COUNT(*)   >   1;
#(second way)

# temporary table cannot be updated
WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date',
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;


# Create a table
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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date,
stage, country, funds_raised_millions)
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

# Delete duplicated rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

# Checks again if it works
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

# 2. Standardize the Data ---------------------------

# Trim = getting rid of unncessary spaces before and after
SELECT DISTINCT company, (TRIM(company))
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

# Looking at every column 
# industry
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1; # -> Crypto, Crypto Currency, CryptoCurrency

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'; # most of them are Crypto

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1; # Checks

# country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1; # -> United States, United States.

#(trailing)
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;
#(trailing)

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1; # Checks

# Changing date text format into date format
SELECT DISTINCT `date`
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') # capital Y for 4 numbers
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
# then change the table format
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;


-- 3. Null Values or Blank Values ---------------------------
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; # if both is null it might be useless data -> remove in 4.

# Looking at industry
SELECT industry
FROM layoffs_staging2; # has blank and null

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; # one of them is Airbnb

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'; # try to match with other Airbnb industry

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

# Make all the '' into NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

# Checks
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''; # only Baily's left
SELECT *
FROM layoffs_staging2
WHERE company LIKE "Bally%"; # can't do anything

# where total laid off and percentage laid off is NULL, we can't do anything from it 
# because we don't have the data

-- 4. Remove Unnecessary Rows and Columns ---------------------------
# Has to be confident when removing data

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 
# if both is null it might be useless data

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

# Checks
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL; 

# removing row_num
SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;







