create database if not exists wallmartsalesdata;
use wallmartsalesdata;

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(30) not null,
    product_line varchar(100) not null,
    unit_price decimal(10, 2) not null,
    quantity int not null,
    vat float(6, 4) not null,
    total decimal(12, 4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10, 2) not null,
    gross_margin_pct float(11, 9),
    gross_income decimal(12, 4) not null,
    rating float(2, 1)
    );
    
    
    
    -- --------------------------------------------------------------------------------------------
    -- ----------------------------------Feature Engineering----------------------------------------
    -- time_of_day
    
    SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day=(
    CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
    END
);

-- day_name
select
	date,
    dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name=dayname(date);

-- month_name

select
	date,
    monthname(date)
from sales;


alter table sales add column month_name varchar(10);

update sales
set month_name=monthname(date);
-- -------------------------------------------------------------------------------------------


-- -------------------------------------------------------------------------------------------
-- ------------------------------------Generic-----------------------------------------------

-- 1.How many unique cities does the data have?
select 
	distinct city 
from sales;

-- 2.In which city is each branch?
select 
	distinct branch 
from sales;

select 
	distinct city,branch
from sales;


-- -------------------------------------------------------------------------------------------
-- ---------------------------------- Product-------------------------------------------------

-- 1.How many unique product lines does the data have?

select 
	count(distinct product_line)
from sales;

-- 2.What is the most common payment method?

select
	payment_method,
	count(payment_method) as count
from sales
group by payment_method
order by count desc;

-- 3.What is the most selling product line?
select
	product_line,
	count(product_line) as count
from sales
group by product_line
order by count desc;

-- 4.What is the total revenue by month?

select
	month_name as month,
    sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

--  5.What month had the largest COGS?

select
	month_name as month,
    sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;


-- 6.What product line had the largest revenue?

select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- 7.What is the city with the largest revenue?

select
	branch,
    city,
    sum(total) as total_revenue
from sales
group by branch,city
order by total_revenue desc;
 
 -- 8.What product line had the largest VAT?
 select
	product_line,
    avg(VAt) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- 9.Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- 10.Which branch sold more products than average product sold?
select
	branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity)>(select avg(quantity) from sales);

-- 11.What is the most common product line by gender?
select 
	gender,
    product_line,
    count(gender) as gender_count
from sales
group by gender,product_line
order by gender_count desc;

-- 12.What is the average rating of each product line?
select
	round(avg(rating),2) as avg_rating,
    product_line
from sales
group by product_line
order by avg_rating desc;

-- --------------------------------------------------------------------------------------------
-- ---------------------------------sales-------------------------------------------------------
-- 1.Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- 2.Which of the customer types brings the most revenue?
 select
	customer_type,
    sum(total) as revenue
from sales
group by customer_type
order by revenue;

-- 3.which city has the largest tax percent/VAT(value Added Tax)?
select
	city,
    round(avg(vat), 2) as VAT
from sales
group by city
order by vat desc;

-- 4.which customer type pays the most in VAT?

select
	customer_type,
    avg(vat) as VAT
from sales
group by customer_type
order by vat desc;

-- ---------------------------------------------------------------------------------------------
-- ---------------------------------------Customers------------------------------------------------------
-- 1.How many unique customer types does the data have?

select
	distinct customer_type
from sales;

-- 2.How many unique payment methods does the data have?

select
	distinct payment_method 
from sales;

-- 3.what is the most common customer type?
select
	customer_type,
    count(*) as count
from sales
group by customer_type
order by count;

-- 4.Which customer type buys the most?
select
	customer_type,
    count(*) as count
from sales
group by customer_type;

-- 5.What is the gender of most of the customers?
select
	gender,
    count(gender)
from sales
group by gender;

-- 6. What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- 7.which time of the day do customers give most ratings?

select
	time_of_day,
    avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- 8.which time of  the day do customers give most ratings per branch?
select
	time_of_day,
    avg(rating) as avg_rating
from sales
where branch="b"
group by time_of_day
order by avg_rating desc;

-- 9.which day of the week has the best avg ratings?
select
	day_name,
    avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- 10.which day of the week has the best average ratings per branch?
select
	day_name,
    avg(rating) as avg_rating
from sales
where branch="a"
group by day_name
order by avg_rating desc;

    
	




