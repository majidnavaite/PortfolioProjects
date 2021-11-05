 select * 
 from PortfolioProject.dbo.['Covid Deaths$']
 where continent is not null
 order by 3,4;

 select * from PortfolioProject.dbo.['Covid Vaccinations$'] order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject.dbo.['Covid Deaths$']
order by 1,2;

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject.dbo.['Covid Deaths$']
where location like '%india%'
order by date desc;

Select location, date, total_cases, new_cases, icu_patients,hosp_patients, weekly_hosp_admissions, weekly_icu_admissions
From PortfolioProject..['Covid Deaths$']
where continent is not null
order by 1,2;



-- Looking at total cases vs population

select location, date, total_cases, total_deaths, population, (total_cases/population)*100 as DeathPercentage
from PortfolioProject.dbo.['Covid Deaths$']
--where location like '%india%'
order by 1,2;

-- Looking at countries with higher infection rate compared to population

select location, MAX(total_cases) as highest_infection_count, population, (MAX(total_cases)/population)*100 as Highest_Percentage_of_population_Infected
from PortfolioProject.dbo.['Covid Deaths$']
--where location like '%india%'
Group By location, population
order by Highest_Percentage_of_population_Infected desc;

-- Showing countries with highest death count per population

select location, MAX(cast(total_cases as int)) as total_death_count
from PortfolioProject.dbo.['Covid Deaths$']
--where location like '%india%'
where continent is not null
Group By location
order by total_death_count desc;

-- Lets break things down by continents
-- showing the continents with the highest death count

select location, MAX(cast(total_cases as int)) as total_death_count
from PortfolioProject.dbo.['Covid Deaths$']
--where location like '%india%'
where continent is null
Group By location
order by total_death_count desc;

-- Global Numbers

select date, SUM(new_cases) as NEW_CASES, Sum(cast(new_deaths as int)) as NEW_DEATHS, (Sum(cast(new_deaths as int))/SUM(new_cases))*100 as DEATH_PERCENTAGE
from PortfolioProject.dbo.['Covid Deaths$']
--where location like '%india%'
where continent is not null
Group By date
order by 1,2;

-- Smokers Percentage

Select dea.location, dea.date, dea.total_cases, dea.total_deaths, dea.population, vac.female_smokers, vac.male_smokers
From PortfolioProject..['Covid Deaths$'] dea
Join PortfolioProject..['Covid Vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date;

-- VACCINATIONS

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Total_Vaccinations
From PortfolioProject..['Covid Deaths$'] dea
Join PortfolioProject..['Covid Vaccinations$'] vac
	On  dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
order by 2,3;

-- CTE

With PopvsVac (continent, location, date, population, new_vaccinations, Total_Vaccinations)
As
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Total_Vaccinations
From PortfolioProject..['Covid Deaths$'] dea
Join PortfolioProject..['Covid Vaccinations$'] vac
	On  dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
)

Select *, (Total_Vaccinations/Population)*100
From PopvsVac
order by 2,3;

