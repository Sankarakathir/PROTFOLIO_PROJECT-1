# EDA ANALYSIS ( Descriptive EDA )
select * from deaths ;
select * from vaccinations ;

-- 1.finding the start date and end date of the given dataset
SELECT MIN(DATE) AS STARTDATE , MAX(DATE) AS LASTDATE FROM DEATHS ;
SELECT MIN(DATE) AS STARTDATE , MAX(DATE) AS LASTDATE FROM vaccinations ;

-- 2.finding the number of countries dataset provided
select count(distinct location)  from deaths;

-- 3.finding the overall global covid cases and covid deaths
select sum(total_cases) as totalcase, sum(total_deaths) as totaldeaths
from deaths where continent is not null;

-- 4. Which locations had the highest cumulative total cases?
select location , max(total_cases) as maxcases 
from deaths where continent is not null
group by location 
order by maxcases desc 
limit 10;

-- 5. Which locations had the highest cumulative total DEATHS?
select location, max(total_deaths) as highestdeaths
from deaths where continent is not null
group by location
order by highestdeaths desc
limit 10;

-- 6. how many records exists for each location : it hekps to identify missing datas and reporting gaps
select location , count(*) as recodcounts
from deaths 
group by location;
# this shows there are inconsistency in the data record based on location, but most countries does have similar record .

-- 7. Which locations recorded the first COVID case?
select location , min(DATE) as startdate 
from deaths where continent is not null and NEW_cases is not null 
group by location 
ORDER BY startdate
LIMIT 1;

-- 8. helps to understand When did each country report its first case? Helps understand pandemic spread timing.
select location , min(DATE) as startdate 
from deaths where continent is not null and NEW_cases is not null 
group by location ;

-- 9. What is the average number of monthly new cases globally? show new infection cases per month on an average 
SELECT location ,month(date),  AVG(new_cases) AS average_new_cases
FROM deaths WHERE continent IS NOT NULL
group by location, month(date)
order by location;

-- 10. What is the average number of monthly deaths globally? show new death cases per month on an average 
select location , month(date) as months, avg(new_deaths)as average_deaths
from deaths where continent is not null
group by location, month(date)
order by location;

-- 11. NUMBER OF COUNTRIES AFFECTED BY COVID INFECTION
SELECT  COUNT(DISTINCT LOCATION) AS AFFECTED_COUNTRIES
FROM DEATHS WHERE CONTINENT IS NOT NULL AND NEW_CASES >1;


/* 12 .Which countries has the highest infection rate relative to their population? 
shows true spread intensity of infection  relative to population size */

select location , max(population)as populations, max(total_cases) as highestinfection ,
max(total_cases) /max(population)*100 as infection_rate_percentage
from deaths where continent is not null 
group by location
order by infection_rate_percentage desc
LIMIT 10;

/* 13 .Which countries had the highest death rate among infected people?
Where was COVID most lethal? This measures disease severity and healthcare system effectiveness  */
select  location , max(total_cases) as totalcases, max(total_deaths) as highestdeaths,
(max(total_deaths)/max(total_cases))*100 as deathrate
from deaths where continent is not null 
group by  location 
order by deathrate desc 
LIMIT 10;

-- 14.how did daily cases change over period of time THIS SHOWS HOW DID IT MOVE OVER TIME
select date ,sum(new_cases) as newcase from deaths 
where continent is not null 
group by date
order by date ;
# this shows that globally there has been an rapid increase in infection cases day by day

-- 15.Cumulative Cases Over Time. How did total cases accumulate during the pandemic?
SELECT 
    date,LOCATION,
    SUM(COALESCE(new_cases,0)) AS daily_cases,
    SUM(SUM(coalesce(NEW_CASES,0))) OVER (
        ORDER BY date
    ) AS running_total_cases
FROM deaths
WHERE continent IS NOT NULL
GROUP BY LOCATION,date
ORDER BY date;

-- 16.  7-Day Rolling Average SHOWS What is the smoothed infection trend?
select date , avg(coalesce(new_cases,0)) over ( order by date rows between 6 preceding and current row) as rolling_average
from deaths where continent is not null 
order by date;

-- 17. What is the total number of vaccinations administered globally?
SELECT SUM(NEW_VACCINATIONS) AS TOTAL_VACCINATIONS FROM VACCINATIONS
WHERE CONTINENT IS NOT NULL ;

-- 18. How did vaccination rollout progress over time?
SELECT DATE , SUM(NEW_VACCINATIONS) AS DAILY_VACCINATION 
FROM VACCINATIONS WHERE CONTINENT IS NOT NULL
GROUP BY Date
order by date;

-- 19.What is the relationship between vaccination coverage and infection rate?
 select d.location,
 max(v.people_vaccinated_per_hundred) as vaccinated_percent,
 max(d.total_cases)/max(d.population)*100 as infection_rate 
 from deaths d
 join vaccinations v on d.location=v.location and d.date =v.date 
 group by d.location
 order by d.location;
  
  -- 20 .What is the death rate before and after vaccination rollout?
SELECT D.DATE , 
SUM(D.NEW_DEATHS)/SUM(D.NEW_CASES) *100 AS DEATH_RATE ,
SUM(COALESCE(V.NEW_VACCINATIONS,0)) AS DAILY_VACCINATIONS 
FROM DEATHS D
JOIN VACCINATIONS V ON V.LOCATION = D.LOCATION AND D.DATE = V.DATE 
WHERE D.CONTINENT IS NOT NULL 
GROUP BY D.DATE
ORDER BY D.DATE;

/* 21.Which continents recorded the highest total cases and their total  deaths
Why this is done :This compares regional pandemic concentration and supports continent-level comparisons with their mortality severity */
  select continent,sum(new_cases) as highest_case_record ,
  sum(new_deaths) as highest_death_count
  from deaths where continent is not null
  group by continent 
  order by highest_case_record desc ;
  
/* 22. What is the average daily number of new cases compared to avg daily deaths globally?
Why this is done : This establishes a baseline infection level compared to the baseline of death severity */
select date, avg(new_cases) as daily_cases,
avg(new_deaths) as daily_deaths
from deaths where continent is not null 
group by date 
order by date ;

/* 23. Which country experienced the highest single-day case spike, death spike? helps to find out the extreme situation of cases and deaths  */
select location ,max(new_cases) as highest_singleday_cases,
max(new_deaths) as hightest_singleday_case
from deaths where continent is not null
group by location
order by highest_singleday_cases desc
limit 10;
   
/* 24.   What is the average infection rate per country?
Why this is done : This compares infection intensity across countries. */
select location , avg(total_cases/population)*100 as average_infection_rate
from deaths where continent is not null
group by location
order by average_infection_rate desc;
 
/* 25. Which countries had the highest vaccination growth? This identifies vaccination acceleration patterns. */
select continent,location , max(total_vaccinations) as vaccination_growth
from vaccinations where continent is not null
group by continent,location 
order by vaccination_growth desc
limit 10 ;

/* 26. What is the monthly trend of cases & vaccinations ? This reveals seasonal or wave patterns. */
select 
  year(d.date) as year,
  month(d.date) as month, 
  sum(d.new_cases) as monthly_cases,
  sum(v.new_vaccinations) as monthly_vaccines
from deaths d join vaccinations v 
on d.date = v.date and d.location=v.location
where d.continent is not null
group by year,month
order by year, month;

/* 27. What percentage of the population was fully vaccinated? */
select location,
        MAX(people_fully_vaccinated_per_hundred) 
        AS fully_vaccinated_percentage
 from vaccinations 
 where continent is not null
 group by location
 order by fully_vaccinated_percentage desc 
 limit 10;
 

     
     
     
     
     
