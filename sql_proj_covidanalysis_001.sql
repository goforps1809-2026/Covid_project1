USE SQL_Covid_Proj1;

select *
from CovidDeath;

-- Total cases are cumulative, sum function is applied to new_cases

-- Total cases and deaths 

Select sum(new_cases)as covid_cases,sum(new_deaths) as covid_deaths, location, continent
from CovidDeath
where continent is not null
group by location, continent
order by covid_cases DESC, covid_deaths DESC

-- few adjustments, continent not like is incorrect, not null is accurate 
-- if data type is set for int, then it will nt record decimal values, for that conversion is imp into FLOAT

-- death %

select ROUND((CAST(sum(new_deaths) AS FLOAT)*100/NULLIF(sum(new_cases),0)),2) as mortality_rate,continent
from CovidDeath
where continent is not null
group by continent
order by mortality_rate desc ;


-- Infected % of population

SELECT 
    continent,
    location,
    population,
    ROUND((CAST(SUM(new_cases) AS FLOAT) / NULLIF(population, 0)),4) * 100 AS infected_percentage
FROM CovidDeath
WHERE continent IS NOT NULL
GROUP BY location, population,continent
ORDER BY infected_percentage desc,population DESC;


-- recovered cases (+ve cases - deaths)

select (sum(new_cases) - sum(new_deaths)) as recovered, location , continent
from CovidDeath
where continent is not null
group by location , continent
order by recovered desc

-- death vs recovered %

with cte as (select new_cases, new_deaths, (new_cases - new_deaths) as recovered, location, continent
from CovidDeath
where continent is not null and new_cases is not null and new_deaths is not null)

select continent, location, ROUND((CAST(sum(new_deaths) AS FLOAT)*100/NULLIF(sum(new_cases),0)),2) as mortality_rate,round((CAST(sum(recovered) AS FLOAT)*100/NULLIF(sum(new_cases),0)),2) as recovery
from cte
group by location, continent



-- covid cases % 2021 minus 2020
--✔ Safer join (location + population)


WITH ct AS (
    SELECT  
        location,
        population,
        (CAST(SUM(new_cases) AS FLOAT) * 100 / NULLIF(population, 0)) AS covid_rate20
    FROM dbo.CovidDeath
    WHERE continent IS NOT NULL 
      AND YEAR(date) = 2020
    GROUP BY location, population
),
ct2 AS (
    SELECT  
        location,
        population,
        (CAST(SUM(new_cases) AS FLOAT) * 100 / NULLIF(population, 0)) AS covid_rate21
    FROM dbo.CovidDeath
    WHERE continent IS NOT NULL 
      AND YEAR(date) = 2021
    GROUP BY location, population
)

SELECT 
    ct.location,ct.population,
    ROUND(ct2.covid_rate21, 4) AS covid_rate_2021,
    ROUND(ct.covid_rate20, 4) AS covid_rate_2020,
    ROUND(ct2.covid_rate21 - ct.covid_rate20, 4) AS diff
FROM ct
JOIN ct2
    ON ct.location = ct2.location
    AND ct.population = ct2.population
ORDER BY ct.population DESC;


-- death rate 2021 - 2020
     
WITH ct AS (
    SELECT  
        location,
        population,
        (CAST(SUM(new_deaths) AS FLOAT) * 100 / NULLIF(population, 0)) AS deaths_percent_20
    FROM dbo.CovidDeath
    WHERE continent IS NOT NULL 
      AND YEAR(date) = 2020
    GROUP BY location, population
),
ct2 AS (
    SELECT  
        location,
        population,
        (CAST(SUM(new_deaths) AS FLOAT) * 100 / NULLIF(population, 0)) AS deaths_21
    FROM dbo.CovidDeath
    WHERE continent IS NOT NULL 
      AND YEAR(date) = 2021
    GROUP BY location, population
)

SELECT 
    ct.location,ct.population,
    ROUND(ct2.covid_rate21, 4) AS covid_rate_2021,
    ROUND(ct.covid_rate20, 4) AS covid_rate_2020,
    ROUND(ct2.covid_rate21 - ct.covid_rate20, 4) AS diff
FROM ct
JOIN ct2
    ON ct.location = ct2.location
    AND ct.population = ct2.population
ORDER BY ct.population DESC;

-- covid- vaccinations

select * from CovidVaccinations;

-- (total vaccinations)

select sum(b.highest) as total_vaccinations
from 
    (select max(new_vaccinations) as highest , continent
    from CovidVaccinations
    group by continent) b


-- join on date and location **

-- % of people vaccinated 

select round(cast(max(cv.people_fully_vaccinated) as float)*100/ nullif(cd.population, 0),3) as vaccination_rate, cv.location, cd.population
from CovidDeath cd
join CovidVaccinations cv
on cd.location = cv.location
AND cd.date = cv.date
where cv.continent is not null and cv.people_fully_vaccinated is not null
group by cv.location, cd.population
order by population desc

-- 1.vaccinations(doses) rolled 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is  not null
order by 2,3

-- 2.% of vaccinations(doses) rolled 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeath dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is  not null
--order by 2,3
)
Select Continent,location, population, round(max((RollingPeopleVaccinated)/Population),4)*100 as rolling_vac
From PopvsVac
group by Continent,location,  population
order by population desc
