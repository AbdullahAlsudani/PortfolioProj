SELECT * FROM CovidDeaths WHERE location = 'Iraq' OR LOCATION = 'Kuwait' OR location = 'Germany' AND date BETWEEN '2/22/202' AND '3/22/2020';

SELECT total_population FROM CovidDeaths;

-- SELECT * FROM CovidVaccinations order by 1,2

-- SELECT * FROM CovidDeaths order by 3,4


-- TOTAL CASES VS. TOTAL DEATHS : SHOWS THE DEATH TO CASES RATIO

SELECT
	LOCATION,
	date,
	total_cases,
	total_deaths,
	(total_deaths / total_cases) * 100 AS DeathPercentage
FROM
	CovidDeaths
WHERE location = 'Iraq' OR location = 'Germany'
ORDER BY
	1,
	2


-- TOTAL CASES VS. POPULATION : SHOWS PERCENTAGE OF PEOPLE WHO GOT INFECTED 

SELECT
	LOCATION,
	date,
	total_cases,
	population,
	(population / total_cases) * 100 AS DetathPercentage
FROM
	CovidDeaths
WHERE location = 'Iraq' OR location = 'Germany'
ORDER BY
	1,
	2;


-- HIGHEST INFECTION RATE COMPARED TO POPULATION


SELECT
	LOCATION,
	Population,
	MAX(total_cases) AS HighestInfectionCount,
	Max((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
	CovidDeaths
WHERE LOCATION = 'Iraq' OR LOCATION = 'Germany' OR LOCATION = 'Kuwait'
GROUP BY
	LOCATION,
	Population
ORDER BY
	PercentPopulationInfected DESC;


-- HIGHEST DEATH COUNT PER POPULATION 


SELECT 
	LOCATION,
	MAX(total_deaths) AS TotalDeathCount
	FROM CovidDeaths
	GROUP BY location
	ORDER BY TotalDeathCount DESC
	
-----




SELECT 
	LOCATION,
	MAX(total_deaths) AS TotalDeathCount
	FROM CovidDeaths WHERE LOCATION = 'Iraq'


-- BREAKING THINGS DOWN BY CONTINENT

	-- Showing contintents with the highest death count per population
	
Select continent, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc
	
	
	

	
Select continent, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From CovidDeaths
Where location = 'Iraq' or LOCATION = 'Germany' or LOCATION = 'Brazil' or LOCATION = 'Canada'
AND continent is not null 
Group by continent
order by TotalDeathCount DESC 
	
	
-- Globally 

Select date , SUM(new_cases) as total_cases, SUM(Cast(new_deaths as signed)) as total_deaths, SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
Where location = 'Iraq' or LOCATION = 'Germany' or LOCATION = 'Kuwait'
AND continent is not null 
Group By date
order by 1,2




SELECT SUM(new_cases) as total_cases, 
       SUM(cast(new_deaths as signed)) as total_deaths, 
       SUM(cast(new_deaths as signed))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
WHERE continent is not null 
ORDER BY 1,2


-- JOINING THE TWO TABLES 
SELECT * 
From CovidDeaths dea 
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date 


-- -- TOTAL POPULATION vs VACCINATION

SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CONVERT(vac.new_vaccinations, signed)) OVER (PARTITION BY dea.Location ORDER BY dea.location,
		dea.Date) AS RollingPeopleVaccinated
FROM
	CovidDeaths dea
	JOIN CovidVaccinations vac ON dea.location = vac.location
		AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
ORDER BY
	2,
	3




	
	
---- Using CTE 


-

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS UNSIGNED)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinationPercentage
From PopvsVac


--- TEMP TABLE 


CREATE TABLE PercentOfPopulationVaccinated (
 continent VARCHAR(255),
 location VARCHAR(255),
 date DATE,
 population INT,
 new_vaccinations INT,
 RollingPeopleVaccinated INT
);

INSERT INTO PercentOfPopulationVaccinated
SELECT
 dea.continent,
 dea.location,
 dea.date,
 dea.population,
 vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
ORDER BY 2, 3;

SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PercentOfPopulationVaccinated;









DROP TABLE PercentOfPopulationVaccinated;


---  CREATING A VIEW (1)


CREATE VIEW TotalDeathCountByContinent AS
Select continent, MAX(cast(Total_deaths as signed)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc;



---  CREATING A VIEW (2)


CREATE VIEW PercentOfPopulationVaccinated_v2 AS
SELECT
 dea.continent,
 dea.location,
 dea.date,
 dea.population,
 vac.new_vaccinations,
 SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
where dea.continent is not null;