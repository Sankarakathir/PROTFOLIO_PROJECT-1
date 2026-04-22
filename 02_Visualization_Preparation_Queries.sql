 # DATA EXPLORATION ON COVIDDATAS
 /* KEY NOTE IS THAT WE CANT DIRECTLY UPLOAD OUR SQL DATABASE INTO TABLEAU FOR VISUALIZATION SO FOR IMPORTING THE DATAS FOR VISUAL WE 
 RUN INDIVIDUAL REQUIRED OP FOR VISUALIZATION AND EXPORT THEM INTO CSV FILES AND THEN IMPORT THEM TO TABLEAU  ALSO SIMILAR TO MYSQL NOT 
 ACCEPTING EMPTY CELLS TABLEAU DOES NOT ACCEPT NULL VALUE THEY CONSIDER THEM AS TEXT SO IT BETTER TO REPLACE NULL WITH 0 IN THE CSV FILE  */
 
                               # SECTION 1 — DATA OVERVIEW
 
use protfolioproject;
select * from deaths limit 1000;

-- Total Records in Each Table which ensures successfull loading of tables
select count(*) as total_death_table_record from deaths;
select count(*) as total_vaccination_table_record from vaccinations;

-- Date Range of the Dataset
select min(date) as start_date, max(date) as end_date
from deaths;
select min(date) as start_date, max(date) as end_date
from vaccinations ;

 -- Total Number of Countries Covered
 select count(distinct location) as total_countries
 from deaths where continent is not null;

                                #SECTION 2 — GLOBAL PANDEMIC SCALE

-- Total Global Cases : Measures the total magnitude of infections.
select sum(new_cases) as global_cases from deaths 
where continent is not null;

-- Total Global Deaths :Measures total mortality impact.
select sum(new_deaths) as global_death_count 
from deaths where continent is not null;

-- Global Death Rate :Measures pandemic severity.
select sum(new_deaths)/sum(new_cases)*100 as global_death_rate
from deaths where continent is not null;


                                 # SECTION 3 — GLOBAL VACCINATION RESPONSE

-- Total Global Vaccinations : Measures vaccination effort.
select sum(new_vaccinations) as vaccination_count 
from vaccinations where continent is not null;

-- Average Vaccination Coverage : Measures population protection level.
select avg(max_vaccinated) as avg_vaccination_coverage
from(select location , max(people_vaccinated_per_hundred) as max_vaccinated
from vaccinations where continent is not null
group by location) v;



                                   # SECTION 4 — COUNTRY LEVEL IMPACT

-- looking for total covid cases for each population which shows what percenatge of population got covidinfection
select location, date , total_cases, population, 
round((total_cases/population)*100,2) as covid_percentage
from deaths ;


-- finding  the deathspercentage for total cases in each country which shows the probability of dying after having covid
select location,date , total_cases, total_deaths,
(total_deaths/total_cases)*100 as deathpercentage
from deaths 
where continent is not null and location like '%india%';


-- Shows the top 10 countries with  highest covidinfections cases
select continent,location , max(total_cases)as total_infection
from deaths
where continent is not null
group by continent,location
order by total_infection desc
LIMIT 10 ;

-- to show the countries with highest death count per population
select continent , location , max(total_deaths) as totaldeathcount
from deaths 
where continent is not null
group by continent, location
order by totaldeathcount desc;

-- to show continents with the highest death counts
select continent , max(total_deaths) as totaldeaths
from deaths 
where continent is not null
group by continent ;

-- looking for each countries highest infection cases compared to population shows the highest extent of infection for the provided population
select location ,population,DATE, max(total_cases) as highest_infection_cases,
max((total_cases/population))*100  as Highest_covidpercentage
from deaths 
where continent is not null
group by location, population,DATE
order by Highest_covidpercentage DESC ;


--  global covid numbers shows an date wise global covid cases and death per day
select date, sum(new_cases) as globalcases, sum(new_deaths) as globaldeaths,
round(sum(new_deaths)/sum(new_cases)*100,3) as globaldeathpercentage
from deaths 
where continent is not null
group by date
order by 1; 




                              # SECTION 5 : DATA EXPLORATION ON VACCINATIONS & DEATHS
select * 
from deaths d
join vaccinations v
on d.location = v.location and d.date = v.date;


-- finding the total vaccination per population to show percentage of the population got vaccinated
select d.continent, d.location, d.date ,
d.population, v.new_vaccinations 
from deaths d
join vaccinations v
on d.location = v.location and d.date = v.date
where d.continent is not null
order by 2 ,3;


-- using winbdow function calculation of new vaccinations each day 
select d.continent, d.location, d.date ,d.population, v.new_vaccinations, 
sum(v.new_vaccinations ) over (partition by d.location order by d.location, d.date ) as runningvaccinations
from deaths d
join vaccinations v
on d.location = v.location and d.date=v.date;


-- calculation of what percentage of population has gotten vaccinations day by day using cte 
with population_vaccine (continent,location,date,population,new_vaccinations,runningvaccinations)as
(select d.continent, d.location, d.date ,d.population, v.new_vaccinations, 
sum(v.new_vaccinations ) over (partition by d.location order by d.location, d.date ) as runningvaccinations
from deaths d
join vaccinations v
on d.location = v.location and d.date=v.date)
select * , (runningvaccinations/population)*100 from population_vaccine; 




-- creation of view to store data  for later visualization process

create view globalcovidcases as select date, sum(new_cases) as globalcases, sum(new_deaths) as globaldeaths,
round(sum(new_deaths)/sum(new_cases)*100,3) as globaldeathpercentage
from deaths 
where continent is not null
group by date
order by 1; 

 create view countrydeathcounts as select continent , max(total_deaths) as totaldeaths
from deaths 
where continent is not null
group by continent ;

create view population_infectionrate as select location ,population,max(total_cases) as highest_infection_cases,
max((total_cases/population))*100  as Highest_covidpercentage
from deaths 
where continent is not null
group by location, population
order by 4 desc;


create view runningvaccinations as with population_vaccine (continent,location,date,population,new_vaccinations,runningvaccinations)as
(select d.continent, d.location, d.date ,d.population, v.new_vaccinations, 
sum(v.new_vaccinations ) over (partition by d.location order by d.location, d.date ) as runningvaccinations
from deaths d
join vaccinations v
on d.location = v.location and d.date=v.date)
select * , (runningvaccinations/population)*100 from population_vaccine; 
  
  
  






