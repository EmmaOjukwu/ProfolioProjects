Select *
From dbo.covidDeaths2
where continent is not null
order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population 
From dbo.covidDeaths2
order by 1,2


To find percentage use (colName1 / colName2) *100 as nameofNewColumn

if an error orrurs use cast e.g. 

SELECT location, date, total_cases, total_deaths, 
       CAST((total_deaths/ CAST(total_cases AS int)) * 100 AS decimal(10,2)) AS case_fatality_rate
FROM dbo.covidDeaths2

or

Select Location, population, MAX(cast(total_deaths as int)) as totalDeathCount
From dbo.covidDeaths2
--where location like 'united states' 
Group By location, population
order by  totalDeathCount desc 







--Looking at Total Cases vs Total Deaths
--Shows the likelyhood of dying if you contract covid in your country

Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage
From dbo.covidDeaths2
where location like 'united states' and date like '2021-12-30'
order by 1,2 




-- Looking at the Total Cases Vs Population 
--Shows what percentage of population got Covid

Select Location, date, population, total_cases,   (total_cases/population) *100 as PercentofPopInfected
From dbo.covidDeaths2
where location like 'united states' 
order by 1,2 


--Looking at countries with highest infection Rate compared to population 


Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) *100 as PercentageofPopInfected
From dbo.covidDeaths2
--where location like 'united states' 
Group By location, population
order by  PercentageofPopInfected desc 



--Showing the countries with Highest Death Count per population 

Select Location, MAX(cast(total_deaths as int))  as totalDeathCount
From dbo.covidDeaths2
--where location like 'united states' 
Where continent is not null
Group By location
order by  totalDeathCount desc 

--Break things down by Continent

Select continent, MAX(cast(total_deaths as int))  as totalDeathCount
From dbo.covidDeaths2
--where location like 'united states' 
Where continent is not null
Group By continent
order by  totalDeathCount desc 


Select Location, MAX(cast(total_deaths as int))  as totalDeathCount
From dbo.covidDeaths2
--where location like 'united states' 
Where continent is null
Group By location
order by  totalDeathCount desc 



--Global Numbers 

Select  date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases) *100  as DeathPercentage
From dbo.covidDeaths2
--where location like 'united states' 
where continent is not null 
--Group by date
order by 1,2 

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, 
       SUM(CAST(new_deaths AS INT))/NULLIF(SUM(new_cases),0)*100 AS DeathPercentage
FROM dbo.covidDeaths2
--WHERE location LIKE 'united states' 
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1,2


--Looking at Total Population vs Vaccintation

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, Sum(Convert(bigint, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From dbo.covidDeaths2 dea
	Join 

	dbo.covidVaccination vac
	on 
	dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	order by 2,3

	--Now to find the percentage by using a CTE using WITH Population vs Vaccintation

	
	with popvsVac (Continent,Location,Date,Population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(Convert(bigint, vac.new_vaccinations)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100 
From dbo.covidDeaths2 dea
	Join 

	dbo.covidVaccination vac
	on 
	dea.location = vac.location
	and dea.date= vac.date
	where dea.continent is not null
	--order by 2,3
	) 
	
select 
    *,
    cast(RollingPeopleVaccinated as decimal(10,2)) / cast(Population as decimal(10,2)) * 100 as VaccinationPercentage
from 
    popvsVac

	--First one did not work use this query, 


	with popvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as (
    select 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        cast(vac.new_vaccinations as decimal(20)), 
        sum(cast(vac.new_vaccinations as decimal(20))) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
    from 
        dbo.covidDeaths2 dea
        join dbo.covidVaccination vac on dea.location = vac.location and dea.date = vac.date
    where 
        dea.continent is not null
)
select 
    *,
    cast(RollingPeopleVaccinated as decimal(20)) / cast(Population as decimal(20)) * 100 as VaccinationPercentage
from 
    popvsVac


	--Temp Table - We are creating a temportary table 

Drop Table if exists #PercentPopulationVaccinated
	Create Table #PercentPopulationVaccinated
	(
	Continent nvarchar (255),
	Location nvarchar(255),
	date datetime,
	Population numeric,
	New_Vaccinations numeric,
	RollingPeopleVaccinated numeric
	)

	
	Insert Into #PercentPopulationVaccinated
	
    select 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        cast(vac.new_vaccinations as decimal(20)), 
        sum(cast(vac.new_vaccinations as decimal(20))) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
    from 
        dbo.covidDeaths2 dea
        join dbo.covidVaccination vac on dea.location = vac.location and dea.date = vac.date
    where 
        dea.continent is not null

select 
    *,
    cast(RollingPeopleVaccinated as decimal(20)) / cast(Population as decimal(20)) * 100 as VaccinationPercentage
from 
    #PercentPopulationVaccinated




	-- Creating View to Store Data for Later Visualisations 
CREATE VIEW PercentPopulationVaccinated AS

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CAST(vac.new_vaccinations AS decimal(20))) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated,
    CAST(SUM(CAST(vac.new_vaccinations AS decimal(20))) OVER (PARTITION BY dea.location ORDER BY dea.date) AS decimal(20)) / CAST(dea.population AS decimal(20)) * 100 AS VaccinationPercentage
FROM 
    dbo.covidDeaths2 dea
    JOIN dbo.covidVaccination vac ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
	
	--Check New View
	Select *
	From dbo.PercentPopulationVaccinated 

