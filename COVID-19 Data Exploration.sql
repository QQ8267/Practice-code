/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


-- Set date to date format

SET SQL_SAFE_UPDATES = 0;

UPDATE covid_deaths
SET `date` = STR_TO_DATE(`date`, '%d/%m/%Y');

UPDATE covid_vac
SET `date` = STR_TO_DATE(`date`, '%d/%m/%Y');


-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
WHERE continent != ""
ORDER BY 1, 2;


-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if youb contract covid in your country

SELECT location, date, total_cases, total_deaths, 
(Total_deaths/total_cases)*100 as DeathPercentage
FROM covid_deaths
WHERE location like 'thai%'
AND continent != ""
ORDER BY 1, 2;


-- Total Cases vs Population
-- Shows what percentage of popultaion infected with Covid

SELECT location, date, population, total_cases,
(total_cases/population)*100 as PercentPopulationInfected
FROM covid_deaths
# WHERE location like 'thai%'
ORDER BY 1, 2;


-- Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount,
MAX((total_cases/population))*100 as PercentPopulationInfected
FROM covid_deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


-- Countries with Highest Death Count per Population

SELECT location, MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
FROM covid_deaths
WHERE continent != ""
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- BREAKING THINGS DOWN BY CONTINENT --

-- Showing continents with the Highest Death Count per Population

SELECT continent, MAX(cast(total_deaths as UNSIGNED)) as TotalDeathCount
FROM covid_deaths
WHERE continent != ""
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as UNSIGNED)) as total_deaths,
SUM(cast(new_deaths as UNSIGNED))/SUM(new_cases)*100 as DeathPercentage
FROM covid_deaths
#WHERE location like 'thai%'
WHERE continent != ""
GROUP BY date
ORDER BY 1, 2;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as UNSIGNED)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated,
#(RollingPeopleVaccinated/population)*100
FROM covid_deaths dea
JOIN covid_vac vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != ""
ORDER BY 2, 3;

-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as UNSIGNED)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vac vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != ""
#ORDER BY 2, 3
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
continent varchar(255),
location varchar(255),
date datetime,
population varchar(255),
new_vaccinations varchar(255),
RollingPeopleVaccinated varchar(255)
);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(COALESCE(NULLIF(vac.new_vaccinations, ''), 0)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vac vac
	ON dea.location = vac.location
    AND dea.date = vac.date;
#WHERE dea.continent != ""
#ORDER BY 2, 3

Select *, (RollingPeopleVaccinated/population)*100
From PercentPopulationVaccinated;



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinatedView as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(COALESCE(NULLIF(vac.new_vaccinations, ''), 0)) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM covid_deaths dea
JOIN covid_vac vac
	ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent != "";
# ORDER BY 2, 3
