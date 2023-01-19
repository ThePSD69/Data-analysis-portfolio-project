--1

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as INT)) as Total_deaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 as DeathRatio
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--2

SELECT Location, SUM(CAST(new_deaths AS INT)) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC

--3

SELECT Location, Population, MAX(Total_cases) AS HighestInfectionCount,
MAX((Total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc



