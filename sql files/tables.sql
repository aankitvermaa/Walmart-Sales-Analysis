use retail_sales;

CREATE TABLE stores(
	Store int,
    Type char(1),
    Size INT
);
alter table stores modify column Store int PRIMARY KEY;
select * from stores;

Create TABLE dept_info(
	Store int,
    Dept int,
    Date date,
    Weekly_Sales decimal(12,4),
    IsHoliday Boolean,
    primary key(Store, Dept, Date)
);
alter table dept_info modify column IsHoliday Varchar(50);
alter table features MODIFY column Date Date;
alter table features modify column IsHoliday varchar(50);
ALTER TABLE features
MODIFY COLUMN MarkDown1 FLOAT NULL;
ALTER TABLE features
MODIFY COLUMN MarkDown2 FLOAT NULL;



select * from features;
select * from dept_info;
select * from stores;
SHOW VARIABLES LIKE 'secure_file_priv';