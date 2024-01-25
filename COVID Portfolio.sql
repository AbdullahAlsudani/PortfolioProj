-- SELECT STATEMENTS (WHEN NEEDED)
SELECT * FROM CovidDeaths WHERE location = 'Iraq' OR LOCATION = 'Kuwait' OR location = 'Germany' AND date BETWEEN '2022-02-22' AND '2020-03-22';
SELECT total_population FROM CovidDeaths;

-- QUERY 1: TOTAL CASES VS. TOTAL DEATHS
SELECT
	LOCATION,
	date,
	total_cases,
	total_deaths,
	(total_deaths / total_cases) * 100 AS DeathPercentage
FROM
	CovidDeaths
WHERE location IN ('Iraq', 'Germany')
ORDER BY
	1,
	2;

-- QUERY 2: TOTAL CASES VS. POPULATION
SELECT
	LOCATION,
	date,
	total_cases,
	population,
	(population / total_cases) * 100 AS DeathPercentage
FROM
	CovidDeaths
WHERE location IN ('Iraq', 'Germany')
ORDER BY
	1,
	2;

-- QUERY 3: HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT
	LOCATION,
	Population,
	MAX(total_cases) AS HighestInfectionCount,
	Max((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
	CovidDeaths
WHERE LOCATION IN ('Iraq', 'Germany')
GROUP BY
	LOCATION,
	Population
ORDER BY
	PercentPopulationInfected DESC;

-- QUERY 4: HIGHEST DEATH COUNT PER POPULATION
SELECT
	LOCATION,
	MAX(total_deaths) AS TotalDeathCount
FROM
	CovidDeaths
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- QUERY 5: BREAKING THINGS DOWN BY CONTINENT
SELECT continent, MAX(CAST(Total_deaths AS SIGNED)) as TotalDeathCount
FROM CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc;

SELECT continent, MAX(CAST(Total_deaths AS SIGNED)) as TotalDeathCount
FROM CovidDeaths
Where location IN ('Iraq', 'Germany', 'Brazil', 'Canada')
AND continent is not null 
Group by continent
order by TotalDeathCount DESC;

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS SIGNED)) as total_deaths, SUM(CAST(new_deaths AS SIGNED))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
Where location IN ('Iraq', 'Germany', 'Kuwait')
AND continent is not null 
Group By date
order by 1,2;

SELECT SUM(new_cases) as total_cases, 
       SUM(CAST(new_deaths AS SIGNED)) as total_deaths, 
       SUM(CAST(new_deaths AS SIGNED))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
WHERE continent is not null 
ORDER BY 1,2;

-- QUERY 6: JOINING THE TWO TABLES
SELECT * 
From CovidDeaths dea 
JOIN CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date;

-- QUERY 7: TOTAL POPULATION vs VACCINATION (CTE)
WITH PopvsVac AS (
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM
	CovidDeaths dea
	JOIN CovidVaccinations vac ON dea.location = vac.location AND dea.date = vac.date
WHERE
	dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PopvsVac;

-- TEMP TABLE
CREATE TEMPORARY TABLE PercentOfPopulationVaccinated (
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
WHERE
	dea.continent IS NOT NULL;

SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PercentOfPopulationVaccinated;

-- VIEW
CREATE VIEW TotalDeathCountByContinent AS
SELECT continent, MAX(CAST(Total_deaths AS SIGNED)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc;

CREATE VIEW PercentOfPopulationVaccinated_v2 AS
SELECT
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (PARTITION BY


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
