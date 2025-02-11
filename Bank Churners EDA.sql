select *
from bank_customer;

select count(customerid)
from bank_customer;

-- Checking for duplicates 

select customerid, count(customerid)
from bank_customer
group by CustomerId
having count(customerid) > 1;

-- Checking for missing values 

select *
from bank_customer
where creditscore is null or creditscore = '';

select *
from bank_customer
where Geography is null or Geography = '';

Select *
from bank_customer
where Gender is null or Gender = '';

select *
from bank_customer
where age is null or age = '';

select *
from bank_customer
where Tenure is null or Tenure = '';

select *
from bank_customer
where balance is null or balance = '';

-- OR

select
	sum(case when creditscore is null then 1 else 0 end) as missing_credit_score,
    sum(case when geography is null then 1 else 0 end) as missing_geography,
    sum(case when gender is null then 1 else 0 end) as missing_gender,
    sum(case when age is null then 1 else 0 end) as missing_age,
    sum(case when tenure is null then 1 else 0 end) as missing_tenure,
    sum(case when balance is null then 1 else 0 end) as missing_balance,
    sum(case when Numofproducts is null then 1 else 0 end) as missing_products,
    sum(case when hascrcard is null then 1 else 0 end) as missing_cc,
	sum(case when isactivemember is null then 1 else 0 end) as missing_am,
	sum(case when estimatedsalary is null then 1 else 0 end) as missing_es,
	sum(case when exited is null then 1 else 0 end) as missing_exited
from bank_customer;

-- Exploratory Data Analysis

-- Total number of customers Churned vs Retained

select Exited, count(exited)
from bank_customer
group by Exited;

-- Churned Rate vs Retained Rate

select exited, count(*) as total_customers, 
       (count(*) * 100.0 / (select count(*) from bank_customer)) as churn_percentage
from bank_customer
group by exited;

-- Total number of customers churned by Country

select Geography, sum(exited) as exited
from bank_customer
group by Geography
order by exited;

-- Churn rate by Country 

select geography, count(*) as total_customers,
       sum(exited) as churned_customers,
       (sum(exited) * 100.0 / count(*)) as churn_rate
from bank_customer
group by geography
order by churn_rate;

-- Total number of customers churned by Gender

select Gender, sum(exited) as exited
from bank_customer
group by Gender
order by exited;

-- Churn rate by Gender

select gender, count(exited) as total_customers,
		SUM(Exited) AS churned_customers,
		(SUM(Exited) * 100.0 / COUNT(*)) AS churn_rate
from bank_customer
group by Gender
order by churn_rate;

-- Churn Rate by Age

select distinct(age)
from bank_customer
order by 1;

select 
	case
		when age < 25 then 'Young'
		when age between 25 and 40 then 'Middle-Age'
		When age > 40 then 'Old'
    end as age_bracket,
    count(*) as total_customers,
    Sum(exited) as churned_customers,
    (Sum(exited) * 100/count(*)) as churned_rate
from bank_customer
group by age_bracket
order by 4;

-- Balance and Churn Rate

select  
    case 
        when balance = 0 then 'No Nalance'
        when balance < 50000 then 'Low Balance'
        when balance between 50000 and 100000 then 'Medium Balance'
        when balance > 100000 then 'High Balance'
    end as balance_category,
    count(*) as total_customers,
    sum(exited) as churned_customers,
    (sum(exited) * 100.0 / count(*)) as churn_rate
from bank_customer
group by balance_category
order by 4;

-- Active Members and Churn Rate

select IsActiveMember, count(exited) as total_customers,
		SUM(Exited) AS churned_customers,
		(SUM(Exited) * 100.0 / COUNT(*)) AS churn_rate
from bank_customer
group by IsActiveMember
order by churn_rate;

-- Churn Rate and Credit Score

Select distinct(creditscore)
from bank_customer
order by 1; 

select 
    case 
        when creditscore <= 580 then 'Bad'
        when creditscore between 581 and 700 then 'Average'
        when creditscore > 700 then 'Good'
    end as creditscorecategory,
    count(exited) as total_customers,
	SUM(Exited) AS churned_customers,
	(SUM(Exited) * 100.0 / COUNT(*)) AS churn_rate
from bank_customer
group by creditscorecategory
order by 4;

-- High Risk Customers

select *
from bank_customer
where age > 40 
and balance < 50000 
and isactivemember = 0
and creditscore < 500
and exited = 0;
