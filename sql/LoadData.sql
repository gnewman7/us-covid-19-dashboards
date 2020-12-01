
-- Load covid.us table 

LOAD DATA 
LOCAL INFILE '../covid-19-data/us.csv' REPLACE 
INTO TABLE covid.us
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@date,cases,deaths)
SET date_time = CONCAT(@date, ' 17:00:00');


-- Load covid.us_states table  

LOAD DATA 
LOCAL INFILE '../covid-19-data/us-states.csv' REPLACE 
INTO TABLE covid.us_states
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@date,state,fips,cases,deaths)
SET date_time = CONCAT(@date, ' 17:00:00');


-- Load covid.us_counties

LOAD DATA 
LOCAL INFILE '../covid-19-data/us-counties.csv' REPLACE 
INTO TABLE covid.us_counties
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@date,county,state,fips,cases,@deaths)
SET date_time = CONCAT(@date, ' 17:00:00'),
deaths = if(@deaths = ' ', null, @deaths);


