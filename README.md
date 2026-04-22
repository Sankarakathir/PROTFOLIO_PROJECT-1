# PROTFOLIO_PROJECT-1

# COVID-19 Data Analysis Using SQL and Tableau

This project presents an end-to-end analysis of global COVID-19 data using SQL for data cleaning, transformation, exploratory analysis, and dashboard-ready query generation. The final insights are visualized through two Tableau dashboards that tell a clear narrative: the scale of the pandemic, the geographic impact, the time-based spread, and the vaccination response and its effect.

The project is structured in a way that reflects a real analyst workflow:
ETL → Exploratory Analysis → Descriptive Analysis → Visualization → Storytelling**

---

# Objectives

The main objectives of this project are to:

- Clean and standardize raw COVID-19 datasets
- Explore the scale and spread of the pandemic
- Analyze country-wise and continent-wise impact
- Study daily and monthly trends in cases, deaths, and vaccinations
- Measure vaccination coverage and response
- Compare vaccination progress with infection and death patterns
- Build dashboard-ready datasets for Tableau
- Present findings in a structured and story-driven manner

---

## Dataset Used
Two CSV datasets were used in this project:

- COVID Deaths Dataset
- COVID Vaccinations Dataset

These datasets contain daily COVID-19 records across countries and continents, including cases, deaths, vaccinations, population, testing, and health-related indicators.

---

# Tools Used
- MySQL for data cleaning, transformation, analysis, and query preparation
- Tableau  for dashboard creation and visualization
- CSV files as the raw data source
- GitHub for project documentation and portfolio presentation

---

# Project Workflow

1. ETL and Data Cleaning
The raw datasets were imported into SQL and transformed into analysis-ready tables. This stage included:
- handling missing values
- converting date formats
- standardizing column data types
- preparing clean tables for analysis

2. Exploratory Data Analysis
The dataset was explored to understand:
- data coverage
- date range
- number of countries
- reporting consistency
- global and country-level patterns

3. Descriptive Analysis
Further analysis was performed to examine:
- averages
- extremes
- growth patterns
- regional comparisons
- infection and death rates
- vaccination coverage

4. Visualization Query Preparation
SQL queries were written specifically to support Tableau dashboards, including:
- KPI cards
- trend charts
- bar charts
- scatter plots
- dual-axis comparisons

5. Dashboard Storytelling
Two dashboards were created to present a complete narrative:
- Dashboard 1: Global pandemic overview
- Dashboard 2: Vaccination rollout and impact analysis

---

# Key Findings from the Analysis

The analysis of global COVID-19 data revealed several important patterns related to infection spread, mortality trends, and vaccination response across countries and regions.

1. Global Pandemic Scale :

* The global aggregation of daily case and death data confirmed the large-scale impact of COVID-19 across multiple regions. By summing daily reported cases and deaths, the analysis quantified the overall magnitude of the pandemic and established baseline metrics for further comparison.

* The calculated global death rate provided a measure of disease severity by estimating the proportion of confirmed cases that resulted in fatalities. This metric helped evaluate the overall risk associated with infection and provided context for comparing different time periods and regions.

* Additionally, the percentage of the population infected metric demonstrated the extent to which the virus spread relative to population size, allowing for a standardized assessment of pandemic reach.
These indicators formed the foundation for understanding the scale and severity of the global outbreak.

---

2. Geographic Impact :

* Country-level aggregation revealed that a relatively small number of countries accounted for a significant proportion of global cases and deaths. By grouping data by location and identifying maximum cumulative totals, the analysis highlighted regions that experienced the highest disease burden.
 
* Continent-level comparisons further demonstrated that the pandemic impact was uneven across geographic regions. Some continents showed higher mortality counts and faster infection growth, indicating differences in healthcare capacity, population density, and response measures.

* This geographic analysis helped identify high-risk regions and provided insight into how the pandemic affected countries differently based on demographic and regional factors.

---

3. Time-Based Trends :

* Time-series analysis of daily case and death counts revealed that the pandemic progressed in multiple waves rather than following a steady growth pattern. By grouping data by date and aggregating daily totals, the analysis identified periods of rapid infection growth followed by stabilization or decline.

* Monthly aggregation of cases helped smooth daily fluctuations and revealed clearer patterns in transmission cycles. These monthly trends allowed for easier identification of peak periods of infection and recovery phases.

* Cumulative case and vaccination calculations further illustrated how the pandemic evolved over time, providing a visual representation of long-term growth and the effectiveness of response measures.
This time-based analysis was essential for understanding the dynamic nature of the pandemic.

---

4. Vaccination Rollout and Coverage :

* Vaccination data analysis showed a steady increase in daily vaccination activity after the initial rollout period. By aggregating daily vaccination counts and calculating cumulative totals, the analysis tracked how vaccination programs expanded over time.

* Country-level vaccination comparisons revealed significant variation in vaccination coverage across nations. Some countries achieved higher vaccination rates more quickly, indicating stronger healthcare infrastructure and more efficient distribution systems.

* The calculation of vaccination coverage percentages provided a standardized measure of population protection and allowed for fair comparison between countries of different population sizes.
Overall, the vaccination data demonstrated the progressive expansion of immunization efforts across the globe.

---

5. Vaccination Impact on Pandemic Outcomes :

* Comparative analysis between vaccination coverage and infection rates suggested a meaningful relationship between vaccination efforts and public health outcomes. By joining vaccination and case data and calculating infection and death rates relative to population size, the analysis evaluated how vaccination influenced pandemic trends.

* The dual analysis of vaccination activity and death rate trends indicated that increased vaccination coverage was associated with reduced severity and improved disease management over time.

* While causation cannot be directly established through descriptive analysis alone, the observed patterns support the conclusion that vaccination programs played a significant role in stabilizing infection and mortality trends.
This relationship highlights the importance of vaccination as a critical public health intervention during the pandemic.

---

# Overall Conclusion

The analysis confirms that the COVID-19 pandemic evolved through multiple stages, including rapid infection spread, regional concentration of cases, and eventual stabilization supported by vaccination programs.
The combination of structured SQL analysis and data visualization enabled a clear understanding of pandemic behavior, response effectiveness, and long-term trends across countries and regions.

# Analysis Pipeline 

COVID-19-Data-Analysis-SQL-Tableau/
│
├── sql/
│   ├── 01_ETL_Data_Cleaning_and_Transformation.sql
│   ├── 02_Exploratory_Data_Analysis.sql
│   ├── 03_Dashboard_Visualization_Queries.sql
│   └── 04_Descriptive_Exploratory_Analysis.sql
│
├── dashboards/
│   ├── dashboard_1_global_pandemic_overview.png
│   └── dashboard_2_vaccination_impact_analysis.png
│
├── data/
    ├── CovidDeaths.csv
    └── CovidVaccinations.csv
