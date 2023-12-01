-- select * from `crucial-summer-401016.ykproject_1.COVIDDEATHS001` where continent is not null order by 3,4

--select location, date, total_cases, new_cases, total_deaths, population
--from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
--where continent is not null
--order by 1,2

--Total Cases vs Total Deaths 
--select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as Percentage_Fatality
--from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
--where continent is not null
--Order by 1,2

--Total Cases vs Population
--select location, date, total_cases, population, ((total_cases/population)*100) as Percentage_Infection
--from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
--where continent is not null
--Order by 1,2

--Highest Infection Rate
-- SELECT location, population, max(total_cases) as highest_inf_count, max((total_cases/population)*100) as Percentage_Infection
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
-- where continent is not null
-- group by location, population
-- order by percentage_infection desc

--Highest Count of Fatality Per Country
-- select location,max(total_deaths) total_death_count
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
-- where continent is not null
-- group by location
-- order by total_death_count desc

--Highest Count of Fatality Per Continent
-- select continent,max(total_deaths) total_death_count
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
-- where continent is not null
-- group by continent
-- order by total_death_count desc

--Global Numbers

-- Overall Death Percentage
-- select sum(new_cases) total_cases1, sum(new_deaths) total_deaths1, (sum(new_deaths)/sum(new_cases))*100 as Death_Percentage
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
-- where continent is not null
-- order by 1,2

--Death Percentage per Day
-- select date, sum(new_cases) total_cases1, sum(new_deaths) total_deaths1, (sum(new_deaths)/sum(new_cases))*100 as Death_Percentage
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001`
-- where continent is not null and new_cases >0
-- group by date
-- order by 1,2

--Joined Table to See Vaccination Rates
-- select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001` dea
-- join `crucial-summer-401016.ykproject_1.covidvacs` vac
-- on dea.location = vac.location
--  and dea.date = vac.date
-- where dea.continent is not null
-- order by 1,2,3

--Total Population vs Vaccination Rates
-- select distinct(dea.date), dea.continent, dea.location,  dea.population, vac.new_vaccinations
-- , sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) Rolling_People_Vaccinated
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001` dea
-- join `crucial-summer-401016.ykproject_1.covidvacs` vac
-- on dea.location = vac.location
--  and dea.date = vac.date
-- --where dea.location = 'United States'
-- where dea.continent is not null
-- order by 1,2,3

--Using CTE

-- With PopVac as (select "date" as date, 
--  "continent" as continent, 
--  "location" as location, 
--  "population" as population, 
--  "new_vaccinations" as new_vac, 
--  "Rolling_People_Vaccinated" as RollingVacCount)
-- select distinct(dea.date), dea.continent, dea.location,  dea.population, vac.new_vaccinations
-- , sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) Rolling_People_Vaccinated
-- from `crucial-summer-401016.ykproject_1.COVIDDEATHS001` dea
-- join `crucial-summer-401016.ykproject_1.covidvacs` vac
-- on dea.location = vac.location
--  and dea.date = vac.date
-- --where dea.location = 'United States'
-- where dea.continent is not null
-- --order by 1,2,3 

With PopVac as (select distinct(dea.date) as date, 
 dea.continent as continent, 
 dea.location as location, 
 dea.population as population, 
 vac.new_vaccinations as new_vac, 
 sum(vac.new_vaccinations) over(partition by dea.location order by dea.location, dea.date) as RollingVacCount
from `crucial-summer-401016.ykproject_1.COVIDDEATHS001` dea
join `crucial-summer-401016.ykproject_1.covidvacs` vac
on dea.location = vac.location
 and dea.date = vac.date
--where dea.location = 'United States'
where dea.continent is not null
--order by 1,2,3
)
select *,(RollingVacCount/popvac.population)*100 from popvac
