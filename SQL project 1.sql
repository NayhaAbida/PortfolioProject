
select * from [Portfolio Project 1].dbo.covidDeaths
where continent is not null
order by 3,4 

select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths 
where continent is not null
order  by 1,2

select location,date ,total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from coviddeaths
where location like '%states%'
and continent is not null
order by 1,2  

select location,date ,total_cases, population, (total_cases/population)*100 as deathpercentage
from coviddeaths
where location like '%states%'
and continent is not null
order by 1,2  


select location ,max(total_cases) as highestinfectioncount, population, max((total_cases/population))*100 as populationiffected
from coviddeaths
group by location,population
order by 4 desc


select location ,max(cast(total_deaths as int)) as highestdeathcount 
from coviddeaths
where continent is not null
group by location
order by 2 desc


select continent ,max(cast(total_deaths as int)) as highestdeathcount 
from coviddeaths
where continent is not null
group by continent
order by 2 desc  


select sum(new_cases) as totalcases, sum(cast(new_deaths as int)) as totaldeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as
deathpercentage from coviddeaths
where  continent is not null
--group by date
order by 1,2  


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
from  coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date 
where dea.continent is not null
order by 2,3 


with popvsvac(continent,location,date,population,new_vaccination,rollingpeoplevac)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
from  coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date 
where dea.continent is not null
--order by 2,3 
)
select *, (rollingpeoplevac/population)*100 from popvsvac 

drop table if exists #popvsvac
create table #popvsvac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rollingpeoplevac numeric)

insert into #popvsvac
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
from  coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date 
--where dea.continent is not null
--order by 2,3 


select *, (rollingpeoplevac/population)*100 from #popvsvac


create view popvsvac
as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevac
from  coviddeaths dea
join covidvaccinations vac
on dea.location=vac.location
and dea.date=vac.date 
where dea.continent is not null
--order by 2,3 

select * from popvsvac
