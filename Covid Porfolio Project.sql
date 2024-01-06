Select *
From Portfolio..CovidDeaths
order by 3,4

--Select *
--From Portfolio..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio..CovidDeaths 
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths 
where location like '%states%'
order by 1,2


Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From Portfolio..CovidDeaths 
--where location like '%afghanistan%'
order by 1,2

Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio.. CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio..CovidDeaths
where continent is not null
Group by date
order by 1,2

Select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
From Portfolio..CovidDeaths dea
Join Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

