Select *
From PortfolioProject1..CovidDeaths$
Where continent is not Null
Order by 3,4

--Select *
--From PortfolioProject1..CovidVaccinations$
--Order by 3,4

--Select the data we are going to be using

Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject1..CovidDeaths$
Order by 1,2

--Looking at Total Cases vs Total Death
--Showing likelihood of dying if you contract covid in your country

Select location,date,total_cases,total_deaths, (total_cases/total_deaths)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths$
where location like '%state%' 
Order by 1,2

--Looking at Total Cases vs Population
--Showing the percentage of Population that got covid

Select location,date,total_cases,population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths$
where location like '%state%' 
Order by 1,2

--Looking at the countries with the Highest infection rate

Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeaths$
--where location like '%state%' 
Group by location, population
Order by PercentPopulationInfected DESC

--Showing Countries with Highest Death Count per Population

Select location, MAX(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths$
--where location like '%state%' 
where continent is not Null 
Group by location
Order by TotalDeathCount DESC

--Lets break down things by Continent

--Showing the continent with the highest death count

Select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeaths$
--where location like '%state%' 
where continent is not Null 
Group by  continent
Order by TotalDeathCount DESC


--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/SUM(new_cases)*100as Deathpercentage
From PortfolioProject1..CovidDeaths$
--where location like '%state%' 
where continent is not Null 
--Group by  date
Order by 1,2

--Looking for Total Population vs Vaccination

--USE CTE

With PopvsVac(Continent,Location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinationS$ vac
	On dea.location= vac.location
	and dea.date= vac.date
where dea.continent is not null
-- order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVAC



--TEMPORARY TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinationS$ vac
	On dea.location= vac.location
	and dea.date= vac.date
where dea.continent is not null
-- order by 2,3

Select*, (RollingPeopleVaccinated/Population)*100
From  #PercentPopulationVaccinated


--Creating View to store Data for later Visualization

Create view PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths$ dea
Join PortfolioProject1..CovidVaccinationS$ vac
	On dea.location= vac.location
	and dea.date= vac.date
where dea.continent is not null
-- order by 2,3

Select *
From PercentPopulationVaccinated
















