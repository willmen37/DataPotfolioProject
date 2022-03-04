--Select *
From PortfolioProject..CovidDeaths
order by 3,4

----Select *
From PortfolioProject..CovidVaccinations
order by 3,4

----Query 1 Select the data we are going to use.
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

---- Query 2 Looking at the total cases vs total deaths
 --shows the likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

---- Query 3 Looking at Total Cases vs Population
 --Shows what percentage of the population got Covid
Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where Location like '%states%'
order by 1,2

----Query 4 Looking at countries with highest infection rate coampred with Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as
PercentPopuationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
Order by PercentPopuationInfected desc

------ Query 5 Showing countries with the highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

------Query 6 Let's break down  by continent
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

----Query 7 Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 
as DeathPercentage 
From PortfolioProject..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

--Query 8 looking at total population vs vaccination
--USE CTE

With PopvsVac (Continent, Location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccinated
--(RollinPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location,
dea.date) as RollingPeopleVaccinated
--(RollinPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

----------------------------------------------------------------------------
-- QUERIES FOR TABLEU TABLES
--1
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
and location not in ('world','European Union', 'International','Upper middle income', 
'High Income', 'Lower Middle Income', 'Low Income')
Group by location
order by TotalDeathCount desc

--2

Select Location, Population, date, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population))*100
as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
Order by PercentPopulationInfected desc










