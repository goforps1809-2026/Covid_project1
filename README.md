**Skills used -** Aggregate functions, CTE, Join, Window Expression, Converting data type

1. **Download** Covid Death file from Alex the analyst. (Link - https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidDeaths.xlsx)

2. **Data Preparation **
- Shift the population column near Total_cases to avoid Joins in the beggining.(Cntrl X on population column & insert cut coulmns)
- Delete columns from AA to the end. (Keeping data compact for initial analysis)
- Save file as Covid_death. 
- Cntrl + z  and delete columns from E to Z. (select columns & right- click delete)
- Save As Covid_vaccinations. (File no. 2 will be later used with Joins)

3. **Loading Data Error **(Issue resolved- Steps) (sol : use microsoft sql server mngt studio
or load data using pandas)
- Using SSMS software (SQL server mgt studio)(download sql server and install ssms)
- Convert file to csv format. 
- load data using import flat file. (right click on database)
- click next, correct data types for each column and tick null entries.
- finish and refersh.

4. **Manipulating Data **
- 4.1 Tables - Covid Death , Covid Vaccinations
-4.2 What are the total covid +ve cases and total deaths?
-4.3 % of Covid deaths
-4.4 What is the highest % of infected cases per popluation? 
-4.5 Covid recovered cases
-4.6 Death vs Recovered %
-4.7 Year by Year covid +ve rate comparison
-4.8 Year by year death rate comparison
-4.9 Total vaccinations
-5.0 What % of people are fully vaccinated? 
-5.1 Vaccination doses rolled
-5.2 What % of vaccination doses rolled per population?

**Key Points -** 
-To calculate Total Covid cases, sum of new_cases is done. (total_cases in data has cumulative values) 
-Continent not null is used in 'where' claus to get distinct numbers for countries.
-Infected % of population = (sum of new_cases / population) *100
-Convert new_cases to float and use nullif to record for decimal values.
-Recovered cases = (total covid cases - total deaths)
-For year on year comparison, Common table expression is used to calculate covid cases for 2020 and 2021 respectively. Both tables are joined to get 2020 vs 2021 numbers.
-% of vaccinated people per population can have have higher %'s as fully_vaccinations are administered in doses.
Join covid and vaccination tables on location and date. 
Vaccination doses rolled = sum(new_cases) OVER (PARTITION BY location ORDER BY date)
