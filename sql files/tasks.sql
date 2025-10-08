-- TASKS

-- BASIC SELECT QUERIES
-- Task 1: Show all records from the stores table
select * from stores;

-- Task 2:Display only store_id and store_type from the stores table
select Store, Type from stores;

-- Task 3: Find all stores that are of type 'A'
select Store from stores where Type ='A';

-- Task 4: Find all stores with size greater than 150,000 square feet
select Store, Type, Size from stores where Size > 150000;

-- Task 5: Show the first 10 sales records
select * from stores limit 10;

-- BASIC AGGREGATION FUNCTIONS
-- Task 6: How many total stores are there?
select count(distinct(Store)) as Total_Stores from stores;

-- Task 7: What is the total of all weekly sales?
select sum(Weekly_Sales) as Total_Sales from dept_info;

-- Task 8:  What is the average weekly sales amount?
select avg(Weekly_Sales) as Average_Sales from dept_info;

-- Task 9: Find the smallest and largest weekly sales amounts
select min(Weekly_Sales) as Smallest_Sale, max(Weekly_Sales) as Largest_Sale from dept_info;

-- Task 10: Show count, sum, average, min, and max of weekly sales all in one query
select count(*) as Total_Records, sum(Weekly_Sales) as Total_Sales, avg(Weekly_Sales) as Average_Sales, max(Weekly_Sales) as Max_Sale, min(Weekly_Sales) as Min_Sale from dept_info;

-- GROUP BY BASICS
-- Task 11: Count how many stores are of each type
select count(Store), Type from stores GROUP BY Type;

-- Task 12: Find total sales for each store
select Store, sum(Weekly_Sales) as Total_Sales from dept_info GROUP BY Store;

-- Task 13: Find total sales for each store and department combination
select Store, Dept, sum(Weekly_Sales) as Total_Sales from dept_info GROUP BY Store, Dept;

-- Task 14: Find total sales for each store, but only for holiday weeks
select Store, sum(Weekly_Sales) as Total_Sales from dept_info where IsHoliday='TRUE' GROUP BY Store;

-- Task 15: Find total sales per store and sort from highest to lowest
select Store, sum(Weekly_Sales) as Total_Sales from dept_info group by Store order by Total_Sales;

-- BASIC JOINS
-- Task 16: Show sales data along with store type for each sale
select d.Store, d.Weekly_Sales, d.Date, d.IsHoliday, s.Type from dept_info d
join stores s on d.Store = s.Store;

-- Task 17: Show store_id, weekly_sales, store_type, and store_size for each sale
select d.Store, d.Weekly_Sales, s.Type, s.Size from dept_info d
join stores s on d.Store = s.Store;

-- Task 18: Show sales data with store info, but only for Type A stores
select d.Store, d.Weekly_Sales, d.Dept, s.Size, s.Type from dept_info d
join stores s on d.Store = s.Store
where s.Type='A';

-- Task 19: Find total sales for each store type
select s.Type, sum(d.Weekly_Sales) as Total_Sales from dept_info d
join stores s on d.Store = s.Store 
GROUP BY s.Type;

-- Task 20: Show store_id, weekly_sales, store_type, and temperature for each sale
select d.Store, d.Weekly_sales, s.Type, f.Temperature from dept_info d
join stores s on d.Store = s.Store
join features f on d.Store = f.Store and d.Date = f.Date;

-- PRACTICAL BUSINESS QUESTIONS
-- Task 21: Which store has the highest total sales?
select Store, sum(Weekly_Sales) as Sale from dept_info group by Store order by Sale desc  limit 1;

-- Task 22:  Which department has the highest average weekly sales?
select Dept, avg(Weekly_Sales) as Avg_Sale from dept_info GROUP BY Dept order by Avg_Sale desc limit 1; 

-- Task 23: Compare total sales between holiday and non-holiday weeks
select IsHoliday, sum(Weekly_Sales) as Total_Sale from dept_info GROUP BY IsHoliday;

-- Task 24: What's the average weekly sales for each store type?
select s.Type, avg(d.Weekly_Sales) as Avg_Sales from dept_info d
join stores s on d.Store = s.Store
group by s.Type;

-- Task 25: Find the store with highest total sales for each store type
select d.Store, s.Type, sum(d.Weekly_Sales) as Highest_Sale from dept_info d
join stores s on d.Store=s.Store
group by s.Type, d.Store
order by s.Type, Highest_Sale desc;

-- SIMPLE CONDITIONAL LOGIC
-- Task 26: Categorize stores by size (Small: <100K, Medium: 100K-150K, Large: >150K)
select Store, Size,
CASE 
	when Size < 100000 then 'Small'
	when Size <=150000 then 'Medium'
	else 'Large'
end as Size_Category
from stores;

-- Task 27: Count how many stores fall into each size category
select 
case
	when Size < 100000 then 'Small'
	when Size <=150000 then 'Medium'
	else 'Large'
end as Size_Category,
count(*) as Store_Count
from stores
group by Size_Category;

-- Task 28: Find total holiday sales and total non-holiday sales for each store
select Store,
sum(case when IsHoliday='TRUE' then Weekly_Sales else 0 end) as Holiday_Sales,
sum(case when IsHoliday='FALSE' then Weekly_Sales else 0 end) as NonHoldiay_Sales
from dept_info group by Store;

-- DATE FUNCTIONS
-- Task 29: Show total sales by year and month
select 
Year(Date) as Sales_Year,
month(Date) as Sales_Month,
sum(Weekly_Sales) as Total_Sales
from dept_info 
group by Year(Date), Month(Date)
order by Sales_Year, Sales_Month;

-- Task 30: Show total sales by month name for easier reading
select 
year(Date) as Sales_Year,
monthname(Date) as Sales_Month,
sum(Weekly_Sales) as Total_Sales
from dept_info 
group by Year(Date), monthname(Date), Month(Date)
order by Sales_Year, Month(Date);

-- CREATE SIMPLE SUMMARY TABLES
-- Task 31: Create a new table with store performance summary
create table Store_Summary as
select
	d.Store,
    s.Type,
    s.Size,
    count(*) as total_weeks,
    sum(Weekly_Sales) as Total_Sales,
    avg(Weekly_Sales) as Avg_Sales,
    min(Weekly_Sales) as Min_Sales,
    max(Weekly_Sales) as Max_Sales
from dept_info d
join stores s on d.Store=s.Store
group by d.Store, s.Type;
select * from Store_Summary;

-- Task 32: Create a summary table showing department performance
create table Dept_Summary as 
select 
	Dept,
    count(distinct Store) as Stores_with_Dept,
    count(*) as total_records,
    sum(Weekly_Sales) as total_dept_sales,
    avg(Weekly_Sales) as avg_dept_sales,
    SUM(CASE WHEN IsHoliday = 'TRUE' THEN Weekly_Sales ELSE 0 END) as holiday_sales,
    SUM(CASE WHEN IsHoliday = 'False' THEN Weekly_Sales ELSE 0 END) as nonholiday_sales
from dept_info group by Dept;
select * from Dept_Summary;