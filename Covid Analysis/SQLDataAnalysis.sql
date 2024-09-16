--check if the 2 tables are correctly uploaded

select *
from CovidDeaths
order by 3, 4

select *
from CovidVaccinations
order by 3, 4

--select the data that we are going to work on

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1, 2

--death percentage

select location, date, total_cases, total_deaths, 
	(total_deaths / total_cases) * 100 as death_percentage
from CovidDeaths

--infected population

select location, date, population, total_cases, (total_cases / population) * 100 as infected_percentage
from CovidDeaths

-- country wise death percentage compared to population

select location, population, 
	max(total_deaths) as total_deaths, 
	max(total_cases) as total_cases,
	max((total_deaths / total_cases) * 100) as death_percentage
from CovidDeaths
where continent is not null
group by location, population
order by max(total_deaths) desc

--countries with highest death count by population

select location, population, max(total_deaths) as totaldeaths
from CovidDeaths
where location not in ('World', 'Africa', 'Europe', 'Asia', 'North America', 'European Union', 'South America')
group by location, population
order by totaldeaths desc

--Countries with highest infected percentage

select location, population, 
	max(total_deaths) as total_deaths, 
	max(total_cases) as total_cases,
	max((total_cases / population) * 100) as infected_percentage
from CovidDeaths
where location != ''
group by location, population
order by infected_percentage desc

--continets by highest death percentage

select location, max(total_deaths) as totaldeaths
from CovidDeaths
group by location
order by totaldeaths desc

--global picture by date

select date, sum(new_cases) as 'Cases', sum(new_deaths) as 'Deaths', 
	( sum (new_deaths) / sum (new_cases) ) * 100 as DeathPercentage
from CovidDeaths
where continent <> ''
group by date
order by date

--global picture (final)

select sum(new_cases) as 'Cases', sum(new_deaths) as 'Deaths',
	( sum (new_deaths) / sum (new_cases) ) * 100 as DeathPercentage
from CovidDeaths
where continent <> ''

--Joins

select d.continent, d.location, d.date, d.population, v.new_vaccinations
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location and d.date = v.date
where d.continent != ''
order by 2, 3

--with partitions and window functions

select d.continent, d.location, d.date, d.population, v.new_vaccinations,
	sum (v.new_vaccinations) over (partition by d.location order by d.location, d.date) as cumulative_new_vaccinations
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location and d.date = v.date
where d.continent != ''
order by 2, 3

--sum (v.new_vaccinations) over (partition by d.location order by d.location, d.date)
--sum (v.new_vaccinations)		--this totals the new vaccinations
--over		-- This shows that we are going to do the summing in a windowed manner rather than a group by
--partition by d.location	--this groups the data within the window function
--order by d.location, d.date	--this means that the data will be summed in a cumulative manner e.g. day by day for each country

--USING CTEs

with PopulationvsVaccinations (continent, location, date, population, new_vaccinations, cumulative_new_vaccinations)
as
(	
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
	sum (v.new_vaccinations) over (partition by d.location order by d.location, d.date) as cumulative_new_vaccinations
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location and d.date = v.date
where d.continent != ''
)
select *, (cumulative_new_vaccinations / population) * 100 from PopulationvsVaccinations as Vaccination_Percentage


--USING TEMP TABLE

drop table if exists TempPopvsVac

create table TempPopvsVac (
	continent varchar(100),
	location varchar(100),
	date date, 
	population numeric, 
	new_vaccinations numeric, 
	cumulative_new_vaccinations numeric
)

insert into TempPopvsVac
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
	sum (v.new_vaccinations) over (partition by d.location order by d.location, d.date) as cumulative_new_vaccinations
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location and d.date = v.date
where d.continent != ''

select *, (cumulative_new_vaccinations / population) * 100 from TempPopvsVac as Vaccination_Percentage

--creating views

create view CumVacView as
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
	sum (v.new_vaccinations) over (partition by d.location order by d.location, d.date) as cumulative_new_vaccinations
from CovidDeaths d
join CovidVaccinations v
	on d.location = v.location and d.date = v.date
where d.continent != ''

select * from CumVacView
