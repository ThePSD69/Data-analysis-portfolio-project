Select *
From PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4 

Select *
From PortfolioProject..CovidVaccinations
ORDER BY 3,4 



-- Select data that i'm goin to use 

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Looking at total cases vs total deaths in México at a given day
-- Shows the likelihood of dying if you get Covid-19
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Mexico'
order by 1,2

-- Looking total cases vs Population in México
SELECT Location, date, total_cases, Population, (total_cases/population)*100 AS PopulationPercenteGotCV19
FROM PortfolioProject..CovidDeaths
WHERE location = 'Mexico'
order by 1,2

-- Looking at Country with Highest Infection Rate compared to population
SELECT Location, MAX(total_cases) as HighestInfectionCount, Population, (MAX(total_cases)/population)*100 AS 'PopulationWhoGotCV19 by Country'
FROM PortfolioProject..CovidDeaths
-- WHERE location = 'Mexico'
WHERE continent IS NOT NULL 
GROUP BY location, population
ORDER BY 'PopulationWhoGotCV19 by Country' DESC


--Showing Countries With Highest Death Count per Population
SELECT Location, MAX(cast(total_deaths as int)) as 'Total Death Count'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY location 
order by 'Total Death Count' DESC


-- BY Continent
SELECT location, MAX(cast(total_deaths as int)) as 'Total Death Count'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
order by 'Total Death Count' DESC

-- Showing continents with highest death count
SELECT location, MAX(cast(total_deaths as int)) as 'Total Death Count'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
order by 'Total Death Count' DESC

-- Deleting non useful information for our interpretation
DELETE 
FROM PortfolioProject..CovidDeaths 
WHERE location IN ('High income','Upper middle income','Lower middle income','European Union','Low income','International')

-- GLOBAL NUMBERS per date and global
SELECT SUM(new_cases) as 'Total Cases', SUM(cast(new_deaths as int)) as 'Total Deaths', SUM(cast(new_deaths as int))/SUM(new_cases)*100 as 'Global Death Percentaje' -- total_deaths, (total_deaths/total_cases)*100 AS 'Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
order by 1,2



-- Join both tables
-- Looking Atotal population vs Vaccinations
WITH PopvsVac (continent, location, date, population, new_vaccionations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
--ORDER by 2,3
)

SELECT * , (RollingPeopleVaccinated/Population)*100 as 'Vaccination Applieds against total Population percentaje'
FROM PopvsVac

-- USE CTE

-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
--ORDER by 2,3

SELECT * , (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- Creatin view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
-- ORDER by 2,3

SELECT *
FROM PercentPopulationVaccinated