-- Step 1: Set the Database
USE cyclist;

-- Step 2: Create the Main Table
CREATE TABLE cycle_data (
    ride_id VARCHAR(50) PRIMARY KEY,
    rideable_type VARCHAR(50),
    started_at DATETIME,
    ended_at DATETIME,
    member_casual VARCHAR(120)
);

-- LOAD DATA USING INFILE METHOD OR ANOTHER AS PER UR CHOICE

-- Step 3: Basic Data Exploration
SELECT COUNT(*) FROM cycle_data;

-- Extracting ride details with date and duration:
SELECT 
  ride_id,
  rideable_type,
  member_casual,
  started_at,
  ended_at,
  DATE(started_at) AS start_date,
  DAYNAME(started_at) AS start_day,
  MONTHNAME(started_at) AS start_month,
  DATE(ended_at) AS return_date,
  DAYNAME(ended_at) AS return_day,
  MONTHNAME(ended_at) AS return_month,
  TIMESTAMPDIFF(MINUTE, started_at, ended_at) AS duration_minutes
FROM cycle_data;

-- Step 4: Data Quality Checks
SELECT ride_id, started_at, ended_at 
FROM cycle_data 
WHERE ended_at < started_at;

-- Detecting carriage return and line feed issues:
SELECT DISTINCT HEX(member_casual), member_casual 
FROM cycle_data;

-- Step 5: Clean the member_casual Column
UPDATE cycle_data
SET member_casual = TRIM(REPLACE(REPLACE(member_casual, '\r', ''), '\n', ''))
WHERE member_casual IS NOT NULL
LIMIT 1050000;

-- Verify if clean:
SELECT COUNT(*) 
FROM cycle_data
WHERE member_casual LIKE '%\r%' 
   OR member_casual LIKE '%\n%' 
   OR member_casual LIKE ' %' 
   OR member_casual LIKE '% ';

-- Step 6: Aggregated Summaries
-- a. User Count by Type
SELECT 
    IFNULL(member_casual, 'Total') AS member_casual,
    COUNT(*) AS user_count
FROM cycle_data
GROUP BY member_casual WITH ROLLUP;

-- b. Monthly Ride Summary
SELECT 
    MONTHNAME(started_at) AS start_month,
    COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS t_members,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS t_casuals,
    COUNT(*) AS total_rides_in_month
FROM cycle_data
GROUP BY MONTH(started_at), MONTHNAME(started_at)
ORDER BY MONTH(started_at);

-- Step 7: Seasonal Analysis
SELECT 
    CASE
        WHEN MONTH(started_at) IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH(started_at) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(started_at) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(started_at) IN (9, 10, 11) THEN 'Fall'
    END AS season,
    COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS total_members,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS total_casuals,
    COUNT(*) AS t_rides_pseason
FROM cycle_data
GROUP BY season
ORDER BY FIELD(season, 'Winter', 'Spring', 'Summer', 'Fall');

-- Step 8: Weekday Analysis
SELECT 
    CASE 
        WHEN DAYOFWEEK(started_at) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(started_at) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(started_at) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(started_at) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(started_at) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(started_at) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(started_at) = 7 THEN 'Saturday'
    END AS weekday,
    COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS total_members,
    COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS total_casuals,
    COUNT(*) AS total_users
FROM cycle_data
GROUP BY weekday
ORDER BY FIELD(weekday, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

-- Step 9: Avg Ride Duration by Weekday
SELECT 
    CASE
        WHEN DAYOFWEEK(started_at) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(started_at) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(started_at) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(started_at) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(started_at) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(started_at) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(started_at) = 7 THEN 'Saturday'
    END AS weekday,
    member_casual,
    AVG(TIMESTAMPDIFF(MINUTE, started_at, ended_at)) AS average_ride_duration_minutes
FROM cycle_data
GROUP BY weekday , member_casual
ORDER BY FIELD(weekday, 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'),
         FIELD(member_casual, 'member', 'casual');

-- Step 10: Rides Count by Time of Day
SELECT 
    member_casual,
    CASE 
        WHEN HOUR(started_at) BETWEEN 0 AND 5 THEN 'Night'
        WHEN HOUR(started_at) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(started_at) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN HOUR(started_at) BETWEEN 18 AND 23 THEN 'Evening'
    END AS time_of_day,
    COUNT(*) AS ride_count
FROM cycle_data
GROUP BY member_casual, time_of_day
ORDER BY FIELD(member_casual, 'member', 'casual'),
         FIELD(time_of_day, 'Night', 'Morning', 'Afternoon', 'Evening');
