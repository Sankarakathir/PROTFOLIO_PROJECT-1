show databases;
create database protfolioproject ;
use  protfolioproject;
select * from coviddeaths limit 10;
select * from  covidvaccinations limit 10;
set sql_safe_updates = 0;


/* ETL PROCESS 
SUMMARY OF THE ETL PROCESS DONE IS AS THE DATASET HAD MANY EMPLTY CELLS IN EXCEL SHEET, IMPORTING THAT  CSV FILE WITH EMPTY CELL 
WILL NOT BE POSSIBLE IN MYSQL IT WOULD ELIMINATE THE EMPTY CELL AFFECTIVE THE DATASET COUNT FOR ADDRESSING THAT PROBLEM WE REPLACED 
EMPTY CELL INTO \N(NULL) AND IMPORTED THEM IN WIZARD AS WIZARD DIDNT RECOGNIZE THEM AS NULL DEFUALTY CAUSING AN DATA TYPE ERROR 
WHERE INT COLUMN HAD \N TEXT VALUES CASUING INAPPROPRIATE DATA-TYPE SO WE EXECUTED THE FOLLOWING THREE ETL STEPS:

-> STEP-1 : CONVERTED ALL THE COLUMNS INTO TEXT DATATYPE 
-> STEP-2 : AFTER SUCCESSFUL IMPORTING REPLACE THE CELLS WITH \N TO NULL USING NULLIF() AND FOR STANDARDIZATION THE DATE COLUMN WE USED STR_TO_DATE()
-> STEP-3 : LATER AFTER THE REPLACING THE VALUES WE CONVERT THE DATATYPES INTO DOUBLE AND DATE AND REVIEW THE END DATASET
*/


# STEP 1 ON ETL : IMPORTING CSV DATASET INTO MYSQL USING WIZARD 
# STEP 2 ON ETL : PROCESS OF UPDATING TEXT_NULL INTO NULL AND TEXT_DATE INTO ISO FORMATTED DATE BEFORE DATA CONVERSION

#using NULLIF(EXPRESSION1,EXPRESSION2)
UPDATE covidvaccinations
SET 
    iso_code = NULLIF(iso_code, '\\N'),
    continent = NULLIF(continent, '\\N'),
    location = NULLIF(location, '\\N'),
    new_tests = NULLIF(new_tests, '\\N'),
    total_tests = NULLIF(total_tests, '\\N'),
    total_tests_per_thousand = NULLIF(total_tests_per_thousand, '\\N'),
    new_tests_per_thousand = NULLIF(new_tests_per_thousand, '\\N'),
    new_tests_smoothed = NULLIF(new_tests_smoothed, '\\N'),
    new_tests_smoothed_per_thousand = NULLIF(new_tests_smoothed_per_thousand, '\\N'),
    positive_rate = NULLIF(positive_rate, '\\N'),
    tests_per_case = NULLIF(tests_per_case, '\\N'),
    tests_units = NULLIF(tests_units, '\\N'),
    total_vaccinations = NULLIF(total_vaccinations, '\\N'),
    people_vaccinated = NULLIF(people_vaccinated, '\\N'),
    people_fully_vaccinated = NULLIF(people_fully_vaccinated, '\\N'),
    new_vaccinations = NULLIF(new_vaccinations, '\\N'),
    new_vaccinations_smoothed = NULLIF(new_vaccinations_smoothed, '\\N'),
    total_vaccinations_per_hundred = NULLIF(total_vaccinations_per_hundred, '\\N'),
    people_vaccinated_per_hundred = NULLIF(people_vaccinated_per_hundred, '\\N'),
    people_fully_vaccinated_per_hundred = NULLIF(people_fully_vaccinated_per_hundred, '\\N'),
    new_vaccinations_smoothed_per_million = NULLIF(new_vaccinations_smoothed_per_million, '\\N'),
    stringency_index = NULLIF(stringency_index, '\\N'),
    population_density = NULLIF(population_density, '\\N'),
    median_age = NULLIF(median_age, '\\N'),
    aged_65_older = NULLIF(aged_65_older, '\\N'),
    aged_70_older = NULLIF(aged_70_older, '\\N'),
    gdp_per_capita = NULLIF(gdp_per_capita, '\\N'),
    extreme_poverty = NULLIF(extreme_poverty, '\\N'),
    cardiovasc_death_rate = NULLIF(cardiovasc_death_rate, '\\N'),
    diabetes_prevalence = NULLIF(diabetes_prevalence, '\\N'),
    female_smokers = NULLIF(female_smokers, '\\N'),
    male_smokers = NULLIF(male_smokers, '\\N'),
    handwashing_facilities = NULLIF(handwashing_facilities, '\\N'),
    hospital_beds_per_thousand = NULLIF(hospital_beds_per_thousand, '\\N'),
    life_expectancy = NULLIF(life_expectancy, '\\N'),
    human_development_index = NULLIF(human_development_index, '\\N');
    
    UPDATE coviddeaths
SET 
    iso_code = NULLIF(iso_code, '\\N'),
    continent = NULLIF(continent, '\\N'),
    location = NULLIF(location, '\\N'),
    total_cases = NULLIF(total_cases, '\\N'),
    new_cases = NULLIF(new_cases, '\\N'),
    new_cases_smoothed = NULLIF(new_cases_smoothed, '\\N'),
    total_deaths = NULLIF(total_deaths, '\\N'),
    new_deaths = NULLIF(new_deaths, '\\N'),
    new_deaths_smoothed = NULLIF(new_deaths_smoothed, '\\N'),
    total_cases_per_million = NULLIF(total_cases_per_million, '\\N'),
    new_cases_per_million = NULLIF(new_cases_per_million, '\\N'),
    new_cases_smoothed_per_million = NULLIF(new_cases_smoothed_per_million, '\\N'),
    total_deaths_per_million = NULLIF(total_deaths_per_million, '\\N'),
    new_deaths_per_million = NULLIF(new_deaths_per_million, '\\N'),
    new_deaths_smoothed_per_million = NULLIF(new_deaths_smoothed_per_million, '\\N'),
    reproduction_rate = NULLIF(reproduction_rate, '\\N'),
    icu_patients = NULLIF(icu_patients, '\\N'),
    icu_patients_per_million = NULLIF(icu_patients_per_million, '\\N'),
    hosp_patients = NULLIF(hosp_patients, '\\N'),
    hosp_patients_per_million = NULLIF(hosp_patients_per_million, '\\N'),
    weekly_icu_admissions = NULLIF(weekly_icu_admissions, '\\N'),
    weekly_icu_admissions_per_million = NULLIF(weekly_icu_admissions_per_million, '\\N'),
    weekly_hosp_admissions = NULLIF(weekly_hosp_admissions, '\\N'),
    weekly_hosp_admissions_per_million = NULLIF(weekly_hosp_admissions_per_million, '\\N');

update covidvaccinations 
set total_tests= nullif(total_tests ,"\\N");
UPDATE DEATHS SET POPULATION = NULLIF(POPULATION,'\\N');

# DATE FORMAT STANDARDIZATION USING STR_TO_DATE(ISO FORMAT) 
UPDATE DEATHS
SET date = STR_TO_DATE(date, '%d/%m/%Y');
UPDATE vaccinations
SET date = STR_TO_DATE(date, '%d/%m/%Y');

# checking for unexpected spacing due to inperfect match which was caused using 
#one single \ where sql considered it as escape character when used two \\ it was considered exact match 

select concat("[", new_tests, "]") as spacing_check from covidvaccinations limit 10;
select length(new_tests) as length , length(trim(new_tests)) as trimmed_value 
from covidvaccinations limit 10;


# STEP-3 ON ETL : CONVERSION OF DATATYPE USING ALTER MODIFY-DDL COMMANDS
USE protfolioproject;

-- covid deaths table data type conversion
alter table coviddeaths 
modify column new_cases int,
modify column new_cases_smoothed double ,
modify column total_deaths int ,
modify column new_deaths double ,
modify column new_deaths_smoothed double ,
modify column total_cases_per_million double ,
modify column new_cases_per_million double, 
modify column new_cases_smoothed_per_million double ,
modify column total_deaths_per_million double,
modify column new_deaths_per_million double,
modify column new_deaths_smoothed_per_million double,
modify column reproduction_rate double,
modify column icu_patients double,
modify column icu_patients_per_million double,
modify column hosp_patients double,
modify column hosp_patients_per_million double,
modify column weekly_icu_admissions double ,
modify column weekly_icu_admissions_per_million double,
modify column weekly_hosp_admissions double,
modify column weekly_hosp_admissions_per_million double;

ALTER TABLE DEATHS MODIFY COLUMN population DOUBLE;

-- covid vaccination table data type conversion 

select * from covidvaccinations limit 1000;

alter table covidvaccinations
modify column new_tests double ,
modify column  total_tests double,
modify column  total_tests_per_thousand double ,
modify column  new_tests_per_thousand double ,
modify column new_tests_smoothed double ,
modify column  new_tests_smoothed_per_thousand double , 
modify column positive_rate double,
modify column  tests_per_case double , 
modify column total_vaccinations double , 
modify column people_vaccinated double , 
modify column people_fully_vaccinated double ,
modify column  new_vaccinations double ,
modify column  new_vaccinations_smoothed double , 
modify column total_vaccinations_per_hundred double , 
modify column people_vaccinated_per_hundred double ,
modify column  people_fully_vaccinated_per_hundred double ,
modify column  new_vaccinations_smoothed_per_million double ,
modify column  stringency_index double ,
modify column population_density double ,
modify column  median_age double ,
modify column aged_65_older double ,
modify column  aged_70_older double ,  
modify column gdp_per_capita double ,
modify column extreme_poverty double ,
modify column cardiovasc_death_rate double,
modify column diabetes_prevalence double,
modify column  female_smokers double , 
modify column male_smokers double,
modify column handwashing_facilities double ,
modify column hospital_beds_per_thousand double , 
modify column life_expectancy double , 
modify column human_development_index double ;

# CONVERSION OF DATE TYPE FROM TEXT TO DATE
ALTER TABLE DEATHS MODIFY COLUMN DATE date;
ALTER TABLE VACCINATIONS MODIFY COLUMN DATE DATE;

# RENAMING OF TABLES FOR EASIER CALLING
RENAME TABLE covidvaccinations TO VACCINATIONS;
RENAME TABLE coviddeaths TO DEATHS;

select * from DEATHS ORDER BY 3,4 limit 1000;
select * from VACCINATIONS ORDER BY 3,4 limit 1000;

DESC DEATHS;
DESC VACCINATIONS;

-- ETL COMPLETED



















