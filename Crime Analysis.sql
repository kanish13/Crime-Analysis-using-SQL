
-- DATABASE CREATION

create database CrimeAnalysis

-- DATA RETRIEVAL

-- a) homicide

SELECT year,state_name,homicide FROM CrimeAnalysis..crimes

-- b) rape

SELECT year,state_name,rape_legacy FROM CrimeAnalysis..crimes

-- c) robbery

SELECT year,state_name,robbery FROM CrimeAnalysis..crimes

-- FILTERING DATA

--a) crimes occurred in 2003

SELECT * FROM CrimeAnalysis..crimes 
WHERE year=2003

--b) homicide occurred in 2003

SELECT year,state_name, homicide FROM CrimeAnalysis..crimes 
WHERE year=2003

--c) rapes occurred in New York

SELECT year,state_name, rape_legacy FROM CrimeAnalysis..crimes 
WHERE state_name='New York'

--d) robbery occurred in ohio

SELECT year,state_name, robbery FROM CrimeAnalysis..crimes 
WHERE state_abbr='OH'

-- AGGREGATION AND GROUPING

--a) total number of homicide,rape,roberry in 2003

SELECT (SUM(homicide)+SUM(rape_legacy)+sum(robbery)) AS TOTAL_CRIME FROM CrimeAnalysis..crimes
WHERE year=2003

--b) average number of murder per year

SELECT ROUND(SUM(homicide)/COUNT(homicide),2) AS AVERAGE_MURDER FROM CrimeAnalysis..crimes
WHERE year=2003

-- ADVANCED FILTERING

--a) retrieve homicide records where the number of offenses is greater than a 1000

SELECT year, state_name,homicide FROM CrimeAnalysis..crimes
WHERE homicide>1000

--b) retrieve property_crime records where the number of fatalities is above a 30,000

SELECT year, state_name,property_crime FROM CrimeAnalysis..crimes
WHERE property_crime>1000

-- DATA CLEANING

-- creating temporary table for cleaning

SELECT TOP 0 * INTO crimes_duplicate FROM CrimeAnalysis..crimes;

INSERT INTO crimes_duplicate
SELECT * FROM CrimeAnalysis..crimes

select * from crimes_duplicate

-- deleting the rows where states are empty

delete from crimes_duplicate
where state_abbr is null and state_name is null

-- STATISTISTICAL ANALYSIS

--a) Find the year with the highest number of homicide

select top 1 year,sum(homicide) as homicide_count from CrimeAnalysis.. crimes
group by year 
order by homicide_count desc

--b) Find the city with the highest number of rape

select top 1 state_name,rape_legacy from CrimeAnalysis..crimes_duplicate
order by rape_legacy desc

-- DATA UPDATE

-- a) update 1981 ohio motor_vehicle_theft to 9463

update CrimeAnalysis..crimes
set motor_vehicle_theft=9463
where state_name='Ohio' and year=1981

select * from CrimeAnalysis..crimes_duplicate

-- DATA DELETION

-- b) delete crime record in texas in 2003

delete from CrimeAnalysis..crimes_duplicate
where year=2003 and state_name='Texas'

-- COMPLEX QUERIES

--a) Retrieve state_names data where the number of robbery is above average for the 2005

-- step 1: calculate the average 

select round(sum(robbery)/count(robbery),2) as avg_robbery from CrimeAnalysis..crimes
where year=2005 

-- step 2: number of robbery is above average

select state_name from CrimeAnalysis..crimes
where robbery>(select round(sum(robbery)/count(robbery),2) as avg_robbery from CrimeAnalysis..crimes
where year=2005) and year=2005 and state_name is not null

--b) Calculate the year-over-year growth rate of burglary (2013)

/* formula for y-o-y
 
YoY Growth Rate=( 
(Accidents in Current Year−Accidents in Previous Year)/Accidents in Previous Year
​)×100

*/

--Accidents in Current Year

select sum(burglary) as Current_Year from CrimeAnalysis..crimes
where year=2013

--Accidents in Previous Year

select sum(burglary) as Previous_year from CrimeAnalysis..crimes
where year=2012

--YoY Calculation
 
with yearlyBurglary(year,burglary) as 
(select year,sum(burglary) from CrimeAnalysis..crimes
where year in (2012,2013)
group by year)

select 
round(((y2013.burglary-y2012.burglary)/y2012.burglary)*100,2)
from yearlyBurglary y2013
left join yearlyBurglary y2012
on 
y2013.year=y2012.year+1
where y2013.year =2013




-- INDEXING

select burglary from CrimeAnalysis..crimes

create index ind_burglary on CrimeAnalysis..crimes (burglary)