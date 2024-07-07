-- DATABASE CREATION

CREATE DATABASE CrimeAnalysis

-- DATA RETRIEVAL

-- a) HOMICIDE

SELECT year, state_name, homicide FROM CrimeAnalysis..crimes

-- b) RAPE

SELECT year, state_name, rape_legacy FROM CrimeAnalysis..crimes

-- c) ROBBERY

SELECT year, state_name, robbery FROM CrimeAnalysis..crimes

-- FILTERING DATA

--a) CRIMES OCCURRED IN 2003

SELECT * FROM CrimeAnalysis..crimes 
WHERE year = 2003

--b) HOMICIDE OCCURRED IN 2003

SELECT year, state_name, homicide FROM CrimeAnalysis..crimes 
WHERE year = 2003

--c) RAPES OCCURRED IN NEW YORK

SELECT year, state_name, rape_legacy FROM CrimeAnalysis..crimes 
WHERE state_name = 'New York'

--d) ROBBERY OCCURRED IN OHIO

SELECT year, state_name, robbery FROM CrimeAnalysis..crimes 
WHERE state_abbr = 'OH'

-- AGGREGATION AND GROUPING

--a) TOTAL NUMBER OF HOMICIDE, RAPE, ROBBERY IN 2003

SELECT (SUM(homicide) + SUM(rape_legacy) + SUM(robbery)) AS TOTAL_CRIME FROM CrimeAnalysis..crimes
WHERE year = 2003

--b) AVERAGE NUMBER OF MURDER PER YEAR

SELECT ROUND(SUM(homicide) / COUNT(homicide), 2) AS AVERAGE_MURDER FROM CrimeAnalysis..crimes
WHERE year = 2003

-- ADVANCED FILTERING

--a) RETRIEVE HOMICIDE RECORDS WHERE THE NUMBER OF OFFENSES IS GREATER THAN 1000

SELECT year, state_name, homicide FROM CrimeAnalysis..crimes
WHERE homicide > 1000

--b) RETRIEVE PROPERTY_CRIME RECORDS WHERE THE NUMBER OF FATALITIES IS ABOVE 30,000

SELECT year, state_name, property_crime FROM CrimeAnalysis..crimes
WHERE property_crime > 1000

-- DATA CLEANING

-- CREATING TEMPORARY TABLE FOR CLEANING

SELECT TOP 0 * INTO crimes_duplicate FROM CrimeAnalysis..crimes;

INSERT INTO crimes_duplicate
SELECT * FROM CrimeAnalysis..crimes

SELECT * FROM crimes_duplicate

-- DELETING THE ROWS WHERE STATES ARE EMPTY

DELETE FROM crimes_duplicate
WHERE state_abbr IS NULL AND state_name IS NULL

-- STATISTISTICAL ANALYSIS

--a) FIND THE YEAR WITH THE HIGHEST NUMBER OF HOMICIDE

SELECT TOP 1 year, SUM(homicide) AS homicide_count FROM CrimeAnalysis..crimes
GROUP BY year 
ORDER BY homicide_count DESC

--b) FIND THE CITY WITH THE HIGHEST NUMBER OF RAPE

SELECT TOP 1 state_name, rape_legacy FROM CrimeAnalysis..crimes_duplicate
ORDER BY rape_legacy DESC

-- DATA UPDATE

-- a) UPDATE 1981 OHIO MOTOR_VEHICLE_THEFT TO 9463

UPDATE CrimeAnalysis..crimes
SET motor_vehicle_theft = 9463
WHERE state_name = 'Ohio' AND year = 1981

SELECT * FROM CrimeAnalysis..crimes_duplicate

-- DATA DELETION

-- b) DELETE CRIME RECORD IN TEXAS IN 2003

DELETE FROM CrimeAnalysis..crimes_duplicate
WHERE year = 2003 AND state_name = 'Texas'

-- COMPLEX QUERIES

--a) RETRIEVE STATE_NAMES DATA WHERE THE NUMBER OF ROBBERY IS ABOVE AVERAGE FOR 2005

-- STEP 1: CALCULATE THE AVERAGE 

SELECT ROUND(SUM(robbery) / COUNT(robbery), 2) AS avg_robbery FROM CrimeAnalysis..crimes
WHERE year = 2005 

-- STEP 2: NUMBER OF ROBBERY IS ABOVE AVERAGE

SELECT state_name FROM CrimeAnalysis..crimes
WHERE robbery > (SELECT ROUND(SUM(robbery) / COUNT(robbery), 2) AS avg_robbery FROM CrimeAnalysis..crimes
WHERE year = 2005) AND year = 2005 AND state_name IS NOT NULL

--b) CALCULATE THE YEAR-OVER-YEAR GROWTH RATE OF BURGLARY (2013)

-- Formula for YoY Growth Rate:
-- YoY Growth Rate = ((Accidents in Current Year − Accidents in Previous Year) / Accidents in Previous Year) × 100

-- ACCIDENTS IN CURRENT YEAR

SELECT SUM(burglary) AS Current_Year FROM CrimeAnalysis..crimes
WHERE year = 2013

-- ACCIDENTS IN PREVIOUS YEAR

SELECT SUM(burglary) AS Previous_year FROM CrimeAnalysis..crimes
WHERE year = 2012

-- YoY CALCULATION
 
WITH yearlyBurglary(year, burglary) AS 
(SELECT year, SUM(burglary) FROM CrimeAnalysis..crimes
WHERE year IN (2012, 2013)
GROUP BY year)

SELECT 
ROUND(((y2013.burglary - y2012.burglary) / y2012.burglary) * 100, 2)
FROM yearlyBurglary y2013
LEFT JOIN yearlyBurglary y2012
ON y2013.year = y2012.year + 1
WHERE y2013.year = 2013

-- INDEXING

SELECT burglary FROM CrimeAnalysis..crimes

CREATE INDEX ind_burglary ON CrimeAnalysis..crimes (burglary)
