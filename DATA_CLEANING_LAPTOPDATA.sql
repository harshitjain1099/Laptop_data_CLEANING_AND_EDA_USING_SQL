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





