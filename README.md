**Skills used -** Aggregate functions, CTE, Join, Window Expression, Converting data type

1. **Download** Covid Death file from Alex the analyst. (Link - https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/CovidDeaths.xlsx)

2. **Data Preparation**
- Shift the population column near Total_cases to avoid Joins in the beggining.(Cntrl X on population column & insert cut coulmns)
- Delete columns from AA to the end. (Keeping data compact for initial analysis)
- Save file as Covid_death. 
- Cntrl + z  and delete columns from E to Z. (select columns & right- click delete)
- Save As Covid_vaccinations. (File no. 2 will be later used with Joins)

3. **Loading Data Error**(Issue resolved- Steps) (sol : use microsoft sql server mngt studio
or load data using pandas)
- Using SSMS software (SQL server mgt studio)(download sql server and install ssms)
- Convert file to csv format. 
- load data using import flat file. (right click on database)
- click next, correct data types for each column and tick null entries.
- finish and refersh.

4. **Manipulating Data**
- 4.1 Tables - Covid Death , Covid Vaccinations
- 4.2 What are the total covid +ve cases and total deaths?
- 4.3 % of Covid deaths
- 4.4 What is the highest % of infected cases per popluation? 
- 4.5 Covid recovered cases
- 4.6 Death vs Recovered %
- 4.7 Year by Year covid +ve rate comparison
- 4.8 Year by year death rate comparison
- 4.9 Total vaccinations
- 5.0 What % of people are fully vaccinated? 
- 5.1 Vaccination doses rolled
- 5.2 What % of vaccination doses rolled per population?

**Key Points -** 
- To calculate Total Covid cases, sum of new_cases is done. (total_cases in data has cumulative values) 
- Continent not null is used in 'where' claus to get distinct numbers for countries.
- Infected % of population = (sum of new_cases / population) *100
- Convert new_cases to float and use nullif to record for decimal values.
- Recovered cases = (total covid cases - total deaths)
- For year on year comparison, Common table expression is used to calculate covid cases for 2020 and 2021 respectively. Both tables are joined to get 2020 vs 2021 numbers.
- % of vaccinated people per population can have have higher %'s as fully_vaccinations are administered in doses.
- Join covid and vaccination tables on location and date. 
- Vaccination doses rolled = sum(new_cases) OVER (PARTITION BY location ORDER BY date)

##**Key Insights** - 
- **Us, India,France among few countres with highest covid cases and deaths**. 
- 32346954	576232	United States	North America
- 19164913	211853	India	Asia
- 14658811	403781	Brazil	South America
- 5677824	104675	France	Europe
- 4750608	108290	Russia	Europe

- **Continents have atleast 2% mortality rate, and Asia with 1.34%**
- 2.7	South America
- 2.67	Africa
- 2.4	Oceania
- 2.27	Europe
- 2.26	North America
- 1.34	Asia

- **Europe have the highest infection rate per population**
- Europe	Andorra	77265	17.13
- Europe	Montenegro	628062	15.51
- Europe	Czechia	10708982	15.23
- Europe	San Marino	33938	14.93
- Europe	Slovenia	2078932	11.56
- Europe	Luxembourg	625976	10.74
- Asia	Bahrain	1701583	10.4

- **Us, India,France among few countries with high recovery numbers**
- 31770738 United States	North America
- 18953116 India	        Asia
- 14255230 Brazil	        South America
- 5573160	France	        Europe
- 4642465	Russia	        Europe

- **Places with least covid cases and deaths**
- 1	1	Vanuatu	Oceania
- 33	1	Grenada	North America
- 90	2	Fiji	Oceania
- 109	3	Brunei	Asia
- 307	1	Bhutan	Asia

- **Countries with highest populations saw a drop in covid cases from 2020 to 2021, except for indonesia**
- China	1439323776	0.0005	0.0066	-0.0062
- India	1380004352	0.6448	0.744	-0.0992
- United States	331002656	3.7002	6.0723	-2.3721
- Indonesia	273523616	0.3382	0.2717	0.0665
- Pakistan	220892336	0.1554	0.2183	-0.0629

- **Few places saw increased covid cases in 2021**
- Albania	2877800	Europe	2.5286	2.0264	0.5022
- Antigua and Barbuda	97928	North America	1.0957	0.1624	0.9333
- Barbados	287371	North America	1.2082	0.1333	1.0749
- Benin	12123198	Africa	0.0377	0.0268	0.0109
- Botswana	2351625	Africa	1.3662	0.6296	0.7367

- **Vaccination rate of 10 countries**
- 1.929	India	1380004352
- 30.636	United States	331002656
- 2.795	Indonesia	273523616
- 6.374	Brazil	212559408
- 1.704	Bangladesh	164689376
- 5.163	Russia	145934464
- 5.507	Mexico	128932752
- 0.787	Japan	126476456
- 0.256	Philippines	109581088
- 10.795	Turkey	84339064

- **Rolling vaccination rates** 
- Asia	China	1439323776	12.83
- Asia	India	1380004352	10.33
- North America	United States	331002656	68.76
- Asia	Indonesia	273523616	4.51
- Asia	Pakistan	220892336	0.36
- South America	Brazil	212559408	18.35
- Africa	Nigeria	206139584	0.11
- Asia	Bangladesh	164689376	1.98
- Europe	Russia	145934464	7.73
- North America	Mexico	128932752	12.56

##**Conclusion** - India, USA,Indonesia, Pakistan among the few populous countries saw the highest covid cases and deaths. They also had highest vaccination rollout rates.
