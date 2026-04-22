# FOR VISUALIZATION & BETTER STORY TELLING 


# FOR DASHBOARD 1
# STAGE 1 : NARRATIVE FLOW — KEY PERFORMING INDICATORS (KPIs)

-- How big was the pandemic globally? we need to find the global case count
select sum(new_cases)as total_cases 
from deaths where continent is not null;

-- How severe was it? we weed to find the global death counts 
select sum(new_deaths)as total_deaths
 from deaths where continent is not null;

-- How widespread was it? to find the global  Death Percentage show what percentage of infected people died
select sum(new_deaths)/sum(new_cases)*100 as global_death_perentage 
from deaths where continent is not null;

-- How many people were vaccinated?to find the Total Global Vaccinations
select sum(new_vaccinations) as total_vaccinations 
from vaccinations where continent is not null;

-- What was the mortality burden? to find the Percentage of Population Infected shows What percentage of the world population was infected?
select sum(new_cases)/sum(population) *100 as percentage_population_infected
from deaths where continent is not null;

-- comined version for easier kpi creation
select sum(d.new_cases)as total_cases ,
 sum(d.new_deaths)as total_deaths,
  sum(v.new_vaccinations) as total_vaccinations ,
 sum(d.new_deaths)/sum(new_cases)*100 as global_death_perentage ,
 sum(d.new_cases)/sum(d.population) *100 as percentage_population_infected
from deaths d
join vaccinations v on 
d.location = v.location and d.date=v.date
where d.continent is not null;

  -- FOR UNDERSTANDING THE GLOBAL CASES AND DEATHS AND WHAT PERCENTAGE OF INFECTED DEAD/
 select  sum(new_cases) as globalcases, sum(new_deaths) as globaldeaths,
round(sum(new_deaths)/sum(new_cases)*100,3) as globaldeathpercentage
from deaths 
where continent is not null
order by 1; 



# STAGE 2: Where Was the Impact Highest? (Geographic Impact)

--  Top 10 Countries with Highest Total Cases AND WITH HIGHEST TOTAL DEATHS 
SELECT LOCATION, MAX(TOTAL_CASES) AS TOTALCASES ,
MAX(TOTAL_DEATHS) AS TOTALDEATHS
FROM DEATHS WHERE CONTINENT IS NOT NULL 
GROUP BY LOCATION 
ORDER BY TOTALCASES DESC
LIMIT 10;

-- Continent-wise Death Count
select location , sum(new_deaths) as totaldeathcount
from deaths where location not in('world','european union','International') and continent is null
group by location;


# STAGE 3: How Did the Pandemic Evolve Over Time?

-- Visual 1- When did cases rise? shows How did infections change over time globally?
SELECT DATE , SUM(coalesce(new_cases,0)) AS GLOBL_CASESTREND 
FROM DEATHS WHERE CONTINENT IS NOT NULL 
GROUP BY DATE
ORDER BY DATE ;

-- Visual 2 - When did deaths peak? shows How did deaths change over time?
select date , sum(coalesce(new_deaths,0)) as global_death_trend
FROM deaths where continent is not null
group by date
order by date;

-- Visual 3 - COMBINED REALTION OF GLOBAL DEATH AND GLOBAL CASES
select date , sum(coalesce(new_cases,0)) as globalcasescount,
sum(coalesce(new_deaths,0)) as globaldeathcount
from deaths where continent is not null
group by date
order by date;

-- Visual 4 - peak infection date vand locaion? (OPTIONAL)
select location, date, sum(new_cases) as peak_cases from deaths 
where continent is not null 
group by  location,date
order by peak_cases desc 
 limit 10;
 
-- Visual 5 — Monthly Pandemic Trend - shows How did cases evolve month by month?
select year(date) as year , month(date) as months , sum(new_cases) as monthlycases 
from deaths where continent is not null
group by year(date),month(date)
order by year(date), month(date) ;




# FOR DASHBOARD 2
       
# STAGE 4 - What this stage answers : How Did Vaccination Change the Pandemic?
SELECT * FROM VACCINATIONS ;

-- Visual 1 — Global New Vaccinations Over Time How did vaccination rollout evolve globally? When did vaccination start?
SELECT DATE , SUM(COALESCE(NEW_VACCINATIONS,0)) AS DAILY_VACCINATIONS FROM VACCINATIONS 
WHERE CONTINENT IS NOT NULL 
GROUP BY DATE
ORDER BY DATE;

-- Visual 2 — Cumulative Vaccinations (Running Total)  SHOWS How many vaccinations have been administered over time?How fast did vaccination grow?
SELECT DATE, SUM(NEW_VACCINATIONS) AS DAILY_VACCINATIONS ,
SUM(SUM(NEW_VACCINATIONS)) OVER (ORDER BY DATE) AS CUMULATIVE_VACCINATIONS
FROM VACCINATIONS WHERE CONTINENT IS NOT NULL 
GROUP BY DATE
ORDER BY DATE;

-- Visual 3 — When Did Vaccination Start?  When did each country begin vaccination? FRO THE TOP 10 COUNTRIES
SELECT LOCATION , MIN(DATE)AS VACCINATION_START
FROM VACCINATIONS
WHERE NEW_VACCINATIONS IS NOT NULL AND CONTINENT IS NOT NULL 
GROUP BY LOCATION 
HAVING LOCATION IN ('BRASIL','UNITED STATES','INDIA','UNITED KINGDOM','GERMANY','FRANCE','ITALY','RUSSIA','SPAIN','TURKEY')
ORDER BY VACCINATION_START;

-- Visual 4 — Top 10 Countries by Total Vaccinations Which countries administered the most vaccine doses?
SELECT LOCATION , max(TOTAL_VACCINATIONS) AS TOTAL_VACCINATIONS
FROM VACCINATIONS
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION
ORDER BY TOTAL_VACCINATIONS DESC
LIMIT 10;

-- Visual 5 — Top 10 Countries by Vaccination Coverage Which countries vaccinated the highest percentage of their population/ What percentage of people were vaccinated?
SELECT V.LOCATION , MAX(V.people_vaccinated)/MAX(D.POPULATION)*100 AS VACCINATION_PERCENTAGE 
FROM VACCINATIONS V
JOIN DEATHS D ON D.LOCATION=V.LOCATION AND V.DATE=D.DATE
WHERE V.CONTINENT IS NOT NULL AND V.LOCATION IN ('BRASIL','UNITED STATES','INDIA','UNITED KINGDOM','GERMANY','FRANCE','ITALY','RUSSIA','SPAIN','TURKEY')
GROUP BY V.LOCATION
ORDER BY VACCINATION_PERCENTAGE DESC;




# STAGE 5: Top KPI CARD FOR VACCINATION REPORT

-- KPI 1 -  Total Vaccination Doses
SELECT SUM(NEW_VACCINATIONS) AS TOTALVACCINE_DOSAGE
FROM VACCINATIONS WHERE CONTINENT IS NOT NULL;

-- KPI 2 - People Vaccinated %
SELECT AVG(PEOPLE_VACCINATED) AS avg_people_vaccinated_percent
FROM (SELECT LOCATION, MAX(people_vaccinated_per_hundred) AS PEOPLE_VACCINATED
FROM VACCINATIONS WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION 
ORDER BY PEOPLE_VACCINATED DESC)VACCINATED;

-- KPI 3 — Fully Vaccinated (%)
SELECT AVG(FULLY_VACCINATED) AS FULLY_VACCINTED
FROM (SELECT LOCATION , MAX(people_fully_vaccinated_per_hundred) AS FULLY_VACCINATED
FROM VACCINATIONS WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION)FV;

--  KPI 4 — Peak Daily Vaccinations
SELECT MAX(DAILY_VACCINATIONS) AS PEAK_VACCINATIONS
FROM (SELECT DATE , SUM(COALESCE(NEW_VACCINATIONS,0)) AS DAILY_VACCINATIONS 
FROM VACCINATIONS 
WHERE CONTINENT IS NOT NULL
GROUP BY DATE) T;




# Stage 6  — Impact Analysis

-- VISUAL 1 — Global Vaccination Trend (Line Chart)
SELECT DATE , SUM(COALESCE(NEW_VACCINATIONS,0))  AS DAILY_VACCINATIONS
FROM VACCINATIONS WHERE CONTINENT IS NOT NULL
GROUP BY DATE 
ORDER BY DATE ;

-- VISUAL 2— Vaccination vs Infection (SCATTER PLOT)
SELECT D.LOCATION,D.CONTINENT,
MAX(V.people_vaccinated)/MAX(D.POPULATION)*100 AS VACCINATED_RATE,
MAX(D.TOTAL_CASES)/MAX(D.POPULATION)*100 AS INFECTED_RATE
FROM VACCINATIONS V
JOIN DEATHS D ON D.LOCATION =V.LOCATION AND D.DATE = V.DATE 
WHERE D.CONTINENT IS NOT NULL
GROUP BY D.LOCATION,D.CONTINENT;

-- VISUAL 3— Vaccination vs Infection (SCATTER PLOT) FOR THE TOP COUNTIRES
SELECT D.CONTINENT,D.LOCATION,
MAX(V.people_vaccinated) AS VACCINATED_RATE,
MAX(D.TOTAL_CASES)/MAX(D.POPULATION)*100 AS INFECTED_RATE
FROM VACCINATIONS V
JOIN DEATHS D ON D.LOCATION =V.LOCATION AND D.DATE = V.DATE 
WHERE D.CONTINENT IS NOT NULL AND D.LOCATION IN ('BRASIL','UNITED STATES','INDIA','UNITED KINGDOM','GERMANY','FRANCE','ITALY','RUSSIA','SPAIN','TURKEY')
GROUP BY D.LOCATION,D.CONTINENT;

-- VISUAL 4 - DEATH RATE BEFORE AND AFTER VACCINATIONS ( DUAL LINE CHAT)

SELECT D.DATE , 
SUM(D.NEW_DEATHS)/SUM(D.NEW_CASES) *100 AS DEATH_RATE ,
SUM(COALESCE(V.NEW_VACCINATIONS,0)) AS DAILY_VACCINATIONS 
FROM DEATHS D
JOIN VACCINATIONS V ON V.LOCATION = D.LOCATION AND D.DATE = V.DATE 
WHERE D.CONTINENT IS NOT NULL 
GROUP BY D.DATE
ORDER BY D.DATE;



