	-- RENAME TABLE monroe_county_car_crashes_2003_2015 TO car_crash;


	-- SELECT * FROM car_crash;


SELECT *
FROM car_crash
WHERE `Day` = '1' OR `Day` = '2';


SELECT *
FROM car_crash
WHERE `Reported_Location` = 'NORTH GRANT' OR `Reported_Location` = 'SOUTH LIBERTY';



SELECT *
FROM car_crash
WHERE `Collision Type` = '1-car';



SELECT *
FROM car_crash
WHERE `Primary Factor` = 'UNSAFE SPEED' AND `Collision Type` = '1-car';

 
SELECT `Reported_Location`, `Collision Type`, `Primary Factor`, `Day`, COUNT(*) as `Number of Crashes`
FROM car_crash
GROUP BY `Reported_Location`, `Collision Type`, `Primary Factor`, `Day`;



SELECT *
FROM car_crash
ORDER BY `Injury Type`;




-- 


SELECT 
   `Collision Type`, 
    COUNT(*) AS Collision_Count, 
    `INJURY TYPE`, 
    COUNT(*) AS Injury_Count
FROM 
    car_crash
GROUP BY 
    `Collision Type`, 
    `INJURY TYPE`
ORDER BY 
    Collision_Count DESC, 
    Injury_Count DESC
LIMIT 1


	-- NUMBER OF COLLISIONS PER HOUR DURING RUSH HOURS (0700 - 0900) AND (1600 - 1800)
SELECT 
    `Hour`, 
    COUNT(*) / COUNT(DISTINCT `Weekend?`) AS Average_Collisions_Per_Hour
FROM 
    car_crash
WHERE 
    (`Hour` BETWEEN 700 AND 900) OR (`Hour` BETWEEN 1600 AND 1800)
GROUP BY 
    `Hour`
ORDER BY 
    `Hour`

	-- NUMBER OF COLLISIONS PER HOUR DURING NON-RUSH HOURS (1000 - 1600) AND (1900 - 2300)

SELECT 
    `Hour`, 
    COUNT(*) / COUNT(DISTINCT `Weekend?`) AS Average_Collisions_Per_Hour
FROM 
    car_crash
WHERE 
    (`Hour` BETWEEN 10 AND 16) OR (`Hour` BETWEEN 19 AND 23) OR (`Hour` BETWEEN 0 AND 6)
GROUP BY 
    `Hour`
ORDER BY 
    `Hour`
    
    
    -- COLLISION TYPE vs. INJURY TYPE : SHOWS THE SPECIFIC NUMBER OF COLLISIONS PER COLLISION TYPE AND THE NUMBER OF INJURIES PER INJURY TYPE

SELECT 
    `Collision Type`, 
    COUNT(*) AS Collision_Count, 
    `INJURY TYPE`, 
    COUNT(*) AS Injury_Count
FROM 
    car_crash
GROUP BY 
    `Collision Type`, 
    `INJURY TYPE`
ORDER BY 
    Collision_Count DESC, 
    Injury_Count DESC;


	-- NUMBER OF COLLISIONS PER REPORTED LOCATIONS AND AVG. OF INJURIES PER COLLISION FOR EACH REPORTED LOCATION 


SELECT 
    `Reported_Location`, 
    COUNT(*) AS Collision_Count, 
    AVG(`Injury_Count`) AS Avg_Injuries_Per_Collision
FROM 
    (SELECT 
        `Reported_Location`, 
        `Collision Type`, 
        COUNT(*) AS Injury_Count
     FROM 
        car_crash
     WHERE 
        `INJURY TYPE` IS NOT NULL
     GROUP BY 
        `Reported_Location`, 
        `Collision Type`) AS Injury_Counts
GROUP BY 
    `Reported_Location`
ORDER BY 
    `Reported_Location`;


	-- AVERAGE LATITUDE AND AVERGAE LONGITUDE FOR EACH REPORTED LOCATION


SELECT 
    `Reported_Location`, 
    AVG(`Latitude`) AS `Avg_Latitude`, 
    AVG(`Longitude`) AS `Avg_Longitude`
FROM 
    car_crash
GROUP BY 
    `Reported_Location`
ORDER BY 
    `Avg_Latitude` DESC, `Avg_Longitude` DESC;

	-- CREATE VIEW 
	
	CREATE VIEW avg_location AS
SELECT 
    `Reported_Location`, 
    AVG(`Latitude`) AS `Avg_Latitude`, 
    AVG(`Longitude`) AS `Avg_Longitude`
FROM 
    car_crash
GROUP BY 
    `Reported_Location`
ORDER BY 
    `Avg_Latitude` DESC, `Avg_Longitude` DESC;


	-- NUMBER OF COLLISION AND INJURIES FOR REPORTED LOCATIONS DURING DECEMBER (12) AND JAN (1)
	
	
SELECT 
    `Reported_Location`, 
    COUNT(*) AS `Collision_Count`, 
    SUM(`INJURY TYPE` = 'Injury') AS `Injury_Count`
FROM 
    car_crash
WHERE 
    MONTH = 12 OR MONTH = 1 
GROUP BY 
    `Reported_Location`
ORDER BY 
    `Collision_Count` DESC;


	-- SPEED RELATED COLLISIONS 
	
	
SELECT 
    `Reported_Location`, 
    COUNT(*) AS `Collision_Count`, 
    SUM(`INJURY TYPE` = 'Injury') AS `Injury_Count`
FROM 
    car_crash
WHERE 
    `Primary Factor` LIKE ('SPEED%')
GROUP BY 
    `Reported_Location`
ORDER BY 
    `Collision_Count` DESC;

	-- CREATING A VIEW OF THE PRIMARY FACTOR(S) FOR ALL COLLISIONS 


CREATE VIEW collision_primary_factors AS
SELECT 
    `Primary Factor`, 
    COUNT(*) AS `Collision_Count`, 
    SUM(`INJURY TYPE` = 'Injury') AS `Injury_Count`
FROM 
    car_crash
GROUP BY 
    `Primary Factor`
ORDER BY 
    `Collision_Count` DESC;