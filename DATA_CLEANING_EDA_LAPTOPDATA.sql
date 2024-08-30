USE  eda_laptop;

ALTER TABLE laptopdata
ADD COLUMN `index` INT AUTO_INCREMENT PRIMARY KEY FIRST;


SELECT * FROM laptopdata;

CREATE TABLE laptops_backup like laptopdata;

INSERT INTO laptops_backup
SELECT * FROM laptopdata;

SELECT  * FROM laptops_backup;

SELECT * FROM information_schema.TABLES
WHERE  TABLE_SCHEMA = 'eda_laptop'
AND TABLE_NAME = 'laptopdata';

SELECT * FROM laptopdata;

ALTER TABLE laptopdata DROP COLUMN `Unnamed: 0`;

SELECT * FROM laptopdata;

DELETE FROM laptopdata
WHERE `index` IN (select `index` FROM laptopdata
where Company IS NULL AND TypeName IS NULL AND Inches IS NULL AND ScreenResolution IS NULL AND
Cpu IS NULL AND Ram IS NULL AND Memory IS NULL AND Gpu IS NULL AND  OpSys IS NULL AND Weight IS NULL AND
Price IS NULL);

SELECT count(*) FROM laptopdata;

ALTER TABLE laptopdata MODIFY COLUMN Inches DECIMAL(10,1);


UPDATE laptopdata l1
JOIN (
    SELECT `index`, REPLACE(Ram, 'GB', '') AS new_ram
    FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.Ram = l2.new_ram;

ALTER TABLE laptopdata modify COLUMN Ram INTEGER;

SELECT * FROM information_schema.TABLES
WHERE  TABLE_SCHEMA = 'eda_laptop'
AND TABLE_NAME = 'laptopdata';

UPDATE laptopdata l1
JOIN (
    SELECT `index`, REPLACE(Weight, 'kg', '') AS new_weight
    FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.Weight = l2.new_weight;


UPDATE laptopdata l1
JOIN (
    SELECT `index`, ROUND(Price) AS new_price
    FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.price = l2.new_price;

SELECT * FROM laptopdata;

ALTER TABLE laptopdata modify COLUMN Price INTEGER;

SELECT distinct OpSys FROM laptopdata;

SELECT OpSYS,
CASE
    WHEN OpSys LIKE '%mac%' THEN 'macos'
	WHEN OpSys LIKE 'Windows%' THEN 'windows'
	WHEN OpSys LIKE '%Linux%' THEN 'linux'
	WHEN OpSys = 'No OS' THEN 'N\A'
    ELSE 'other'
END AS 'os_brand'
FROM laptopdata;


    
    UPDATE laptopdata
    SET OpSys = CASE
    WHEN OpSys LIKE '%mac%' THEN 'macos'
	WHEN OpSys LIKE 'Windows%' THEN 'windows'
	WHEN OpSys LIKE '%Linux%' THEN 'linux'
	WHEN OpSys = 'No OS' THEN 'N\A'
    ELSE 'other'
END ;

SELECT * FROM laptopdata;

ALTER TABLE laptopdata
ADD COLUMN gpu_brand VARCHAR(255) AFTER GPU,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

UPDATE laptopdata l1
JOIN (
    SELECT `index`, SUBSTRING_INDEX(Gpu, ' ', 1) AS Gpu_Brand
    FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.gpu_brand = l2.Gpu_Brand;

select * from laptopdata;

UPDATE laptopdata l1
JOIN (
    SELECT `index`, REPLACE(Gpu,gpu_brand,'') AS Gpu_name
    FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.gpu_name = l2.Gpu_name;

ALTER TABLE laptopdata DROP COLUMN Gpu ;

select * from laptopdata;

ALTER TABLE laptopdata
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

UPDATE laptopdata l1
JOIN (
    SELECT `index`, SUBSTRING_INDEX(Cpu, ' ', 1) AS Cpu_Brand
    FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.Cpu_brand = l2.Cpu_Brand;

UPDATE laptopdata l1
JOIN (
    SELECT `index`, CAST(REPLACE(SUBSTRING_INDEX(Cpu, ' ', -1),'GHz','')AS DECIMAL) AS Cpu_speed
    FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.Cpu_speed = l2.Cpu_speed;

SELECT * FROM laptopdata;

UPDATE laptopdata l1
JOIN (
    SELECT `index`, REPLACE(
            REPLACE(Cpu, cpu_brand, ''), 
            SUBSTRING_INDEX(REPLACE(Cpu, cpu_brand, ''), ' ', -1), 
            '') AS cpu_name
FROM laptopdata
) AS l2 ON l1.`index` = l2.`index`
SET l1.cpu_name = l2.cpu_name;

ALTER TABLE laptopdata DROP COLUMN Cpu;


select ScreenResolution,  
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1)
 from laptopdata;

ALTER TABLE laptopdata 
add column resolution_width INTEGER AFTER ScreenResolution,
add column resolution_height INTEGER AFTER ScreenResolution;


update laptopdata
set resolution_width = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1),
resolution_height = SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1);

select *from laptopdata;

ALTER TABLE laptopdata 
add column touchscreen INTEGER AFTER resolution_height;

select ScreenResolution like '%Touch%' from laptopdata;

update laptopdata
set touchscreen = ScreenResolution like '%Touch%';

ALTER TABLE  laptopdata
drop column  ScreenResolution ;

select *from laptopdata;

select cpu_name,substring_index(TRIM(cpu_name),' ',2)
from laptopdata;


update laptopdata
set cpu_name = substring_index(TRIM(cpu_name),' ',2);

select *from laptopdata;

ALTER TABLE laptopdata
ADD COLUMN memory_type VARCHAR(255) AFTER Memory, 
ADD COLUMN primary_storage INTEGER AFTER  memory_type,
ADD COLUMN secondary_storage INTEGER AFTER  primary_storage;

SELECT Memory,
case
    when Memory like '%SSD%' AND  Memory like '%HDD%' THEN 'Hybrid'
    when Memory like '%SSD%' THEN 'SSD'
    when Memory like '%HDD%' THEN 'HDD'
    when   Memory like '%Flash Storage%' THEN 'Flash Storage'
    when   Memory like '%Hybride%' THEN 'Hybrid'
	when   Memory like '%Flash Storage%' AND Memory like  '%HDD%' THEN 'Hybrid'
    ELSE null
END AS 'memory_type'
from laptopdata;

update laptopdata
set memory_type = case
    when Memory like '%SSD%' AND  Memory like '%HDD%' THEN 'Hybrid'
    when Memory like '%SSD%' THEN 'SSD'
    when Memory like '%HDD%' THEN 'HDD'
    when Memory like '%Flash Storage%' THEN 'Flash Storage'
    when Memory like '%Hybride%' THEN 'Hybrid'
	when Memory like '%Flash Storage%' AND Memory like  '%HDD%' THEN 'Hybrid'
    ELSE null
END ;

select * from laptopdata;
     

SELECT Memory,
REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END
FROM laptopdata;

UPDATE laptopdata
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0 END;


select * from laptopdata;

select
primary_storage,
case when primary_storage <= 2 then primary_storage*1024 else primary_storage end,
secondary_storage,
case when secondary_storage <= 2 then secondary_storage*1024 else secondary_storage end
from laptopdata;

update laptopdata
set primary_storage = case when primary_storage <= 2 then primary_storage*1024 else primary_storage end,
secondary_storage = case when secondary_storage <= 2 then secondary_storage*1024 else secondary_storage end;

select * from laptopdata;

ALTER TABLE laptopdata DROP COLUMN Memory;

select * from laptopdata;

ALTER TABLE laptopdata DROP COLUMN gpu_name;
 
select * from laptopdata;


-- EDA



-- head, tail and sample
SELECT * FROM laptopdata
order by `index` Limit 5;

SELECT * FROM laptopdata
order by `index`DESC Limit 5;

SELECT * FROM laptopdata
order by RAND() Limit 5;



-- UNIVARATE ANALYSIS
WITH RankedPrices AS (
    SELECT 
        Price,
        ROW_NUMBER() OVER (ORDER BY Price) AS row_num,
        COUNT(*) OVER () AS total_count
    FROM 
        laptopdata
)
SELECT 
    COUNT(Price) AS Total_Count,
    MIN(Price) AS Min_Price,
    MAX(Price) AS Max_Price,
    AVG(Price) AS Avg_Price,
    STDDEV(Price) AS Std_Price,
    (SELECT Price FROM RankedPrices WHERE row_num = FLOOR(0.25 * total_count)) AS Q1,
    (SELECT Price FROM RankedPrices WHERE row_num = FLOOR(0.5 * total_count)) AS Median,
    (SELECT Price FROM RankedPrices WHERE row_num = FLOOR(0.75 * total_count)) AS Q3
FROM 
    RankedPrices;
     
     
     
-- NULL VALUES    
SELECT COUNT(Price)
FROM laptopdata
WHERE Price IS NULL;



-- OUTLIERS
WITH RankedPrices AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY Price) AS row_num,
        COUNT(*) OVER () AS total_count
    FROM 
        laptopdata
),
Quartiles AS (
    SELECT 
        MIN(CASE WHEN row_num = FLOOR(0.25 * total_count) THEN Price END) AS Q1,
        MIN(CASE WHEN row_num = FLOOR(0.75 * total_count) THEN Price END) AS Q3
    FROM 
        RankedPrices
        ),

OutlierBounds AS (
    SELECT 
        Q1,
        Q3,
        (Q3 - Q1) AS IQR,
        (Q1 - 1.5 * (Q3 - Q1)) AS Lower_Bound,
        (Q3 + 1.5 * (Q3 - Q1)) AS Upper_Bound
    FROM 
        Quartiles
)
SELECT 
    *
FROM 
    laptopdata, OutlierBounds
WHERE 
    Price < Lower_Bound OR Price > Upper_Bound;
    
    
    
    
    SELECT t.BUCKETS,REPEAT('*',count(*)) FROM (SELECT Price,
    CASE 
        WHEN Price  between 0 AND 25000 THEN '0-25K'
	    WHEN Price  between 25001 AND 50000 then '25K-50K'
	    WHEN Price  between 50001 AND 75000 THEN  '50K-75K'
	    WHEN Price  between 75001 AND 100000 THEN  '75K-100K'
        ELSE'>100K'
    END AS'BUCKETS'
    FROM laptopdata) t
    GROUP BY t.BUCKETS;



SELECT Company,COUNT(Company) FROM laptopdata
GROUP BY Company;



SELECT cpu_speed,Price FROM laptopdata;



SELECT * FROM laptopdata;



SELECT Company,
SUM(CASE WHEN Touchscreen = 1 THEN 1 ELSE 0 END) AS 'Touchscreen_yes',
SUM(CASE WHEN Touchscreen = 0 THEN 1 ELSE 0 END) AS 'Touchscreen_no'
FROM laptopdata
GROUP BY Company;



SELECT DISTINCT cpu_brand FROM laptopdata;



SELECT Company,
SUM(CASE WHEN cpu_brand = 'Intel' THEN 1 ELSE 0 END) AS 'intel',
SUM(CASE WHEN cpu_brand = 'AMD' THEN 1 ELSE 0 END) AS 'amd',
SUM(CASE WHEN cpu_brand = 'Samsung' THEN 1 ELSE 0 END) AS 'samsung'
FROM laptopdata
GROUP BY Company;





-- Categorical Numerical Bivariate analysis
SELECT Company,MIN(price),
MAX(price),AVG(price),STD(price)
FROM laptopdata
GROUP BY Company;



