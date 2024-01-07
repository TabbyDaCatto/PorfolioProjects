Select *
From Portfolio..CovidDeaths
where continent is not null
order by 3,4

--Select *
--From Portfolio..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio..CovidDeaths 
order by 1,2

-- Looking at total cases vs total deaths
-- show likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths 
where location like '%states%'
order by 1,2

-- looking at total cases vs population
-- show what percentage of population got Covid

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
From Portfolio..CovidDeaths 
--where location like '%afghanistan%'
order by 1,2

-- looking at countries with highest infection rate compared to population

Select location, population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as  PercentagePopulationInfected
from Portfolio..CovidDeaths
Group by Location, population
order by PercentagePopulationInfected desc

-- Showing Countries with Highest Death Count per population

Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio.. CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc

-- break things down by continent

-- SHOWING continents with the highest death count per population 


Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From Portfolio..CovidDeaths
where continent is not null
group by continent 
order by TotalDeathCount desc

-- global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio..CovidDeaths
where continent is not null
--Group by date
order by 1,2

-- looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location Order by dea.location, dea.date) 
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- use CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac

-- Temp table

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated