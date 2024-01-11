CREATE DATABASE project;
use project;
select * from finance_data1 
inner join finance_2 
on finance_data1.id =finance_data2.id ;
select extract(year from issue_d)as year,count(id)as coustmer,sum(loan_amnt)as Loan_amount from finance_data1 group by extract(year from issue_d)order by extract(year from issue_d)  ;
select extract(year from issue_d)as year,count(id)as coustmer,sum(loan_amnt)as Loan_amount from finance_data1 group by extract(year from issue_d);
select finance_data1.issue_d,finance_2.total_pymnt from finance_data1 join finance_2 on finance_data1.id= finance_2.id;

-- KPI 1 year wise loan status ---
select extract(year from finance_data1.issue_d)as year ,count(finance_data1.id)as coustmer,sum(finance_data1.loan_amnt)as Loan_amount,
 sum(finance_2.total_pymnt) as Payment
from finance_data1  left join finance_2
 on finance_data1.id= finance_2.id 
 group by extract(year from finance_data1.issue_d) 
 order by extract(year from finance_data1.issue_d );

 -- KPI2 Grade AND sub grade wise revol_bal---
select extract(year from finance_data1.issue_d)as year ,finance_data1.grade,count(finance_data1.id)as coustmer,
 sum(finance_2.revol_bal) as rev_bal
from finance_data1  left join finance_2
 on finance_data1.id= finance_2.id 
 group by extract(year from finance_data1.issue_d), finance_data1.grade
 order by finance_data1.grade ,extract(year from finance_data1.issue_d ); 
 
 select finance_data1.grade,count(finance_data1.id)as coustmer,
 sum(finance_2.revol_bal) as rev_bal
from finance_data1  left join finance_2
 on finance_data1.id= finance_2.id 
 group by finance_data1.grade
 order by finance_data1.grade ; 
 
  select finance_data1.sub_grade,count(finance_data1.id)as coustmer,
 sum(finance_2.revol_bal) as rev_bal
from finance_data1  left join finance_2
 on finance_data1.id= finance_2.id 
 group by  finance_data1.sub_grade
 order by finance_data1.sub_grade ; 
 
 -- KPI 3 total payment ANd verification status ----
 select extract(year from finance_data1.issue_d)as year ,finance_data1.verification_status, count(finance_data1.id)as coustmer,sum(finance_data1.loan_amnt)as Loan_amount,
 sum(finance_2.total_pymnt) as Payment
from finance_data1  left join finance_2
 on finance_data1.id= finance_2.id 
 group by extract(year from finance_data1.issue_d), finance_data1.verification_status
 order by extract(year from finance_data1.issue_d),finance_data1.verification_status ;

 select finance_data1.verification_status, count(finance_data1.id)as coustmer,sum(finance_data1.loan_amnt)as Loan_amount,
 sum(finance_2.total_pymnt) as Payment
from finance_data1  left join finance_2
 on finance_data1.id= finance_2.id 
 group by  finance_data1.verification_status
 order by finance_data1.verification_status ;
 
 -- KPI 4 state wise and credit pull wise date loan status ---
select addr_state, loan_status, count(loan_status)
from finance_data1
group by addr_state, loan_status;

select monthname(f2.last_pymnt_d) pay_month, count(f1.loan_status) as loan_status
from finance_data1 as f1 join finance_2 as f2
on f1.id = f2.id
group by pay_month;

-- KPI 5 Home ownership Vs last payment date stats --
select year(f2.last_pymnt_d) payment_year, monthname(f2.last_pymnt_d) payment_month, f1.home_ownership, count(f1.home_ownership) home_ownership
from finance_data1 as f1 inner join finance_2 as f2
on f1.id = f2.id
group by year(f2.last_pymnt_d), monthname(f2.last_pymnt_d), f1.home_ownership
order by payment_year;

with cte as (
select fn1.home_ownership, year(last_pymnt_d) as payment_year, monthname(last_pymnt_d) as payment_month
from finance_data1 as fn1 join finance_2 as fn2
on fn1.id = fn2.id
where home_ownership in ('rent', 'mortgage', 'own')
group by fn1.home_ownership
)
select * from
(select cte.home_ownership, count(last_pymnt_d) as num_loan
from cte 
group by cte.home_ownership
) final;

select year(f2.last_pymnt_d) payment_year, f1.home_ownership, count(f1.home_ownership) home_ownership
from finance_data1 as f1 inner join finance_2 as f2
on f1.id = f2.id
group by year(f2.last_pymnt_d), f1.home_ownership
order by payment_year;

select year(f2.last_pymnt_d) payment_year, monthname(f2.last_pymnt_d) payment_month, f1.home_ownership, count(f1.home_ownership) home_ownership
from finance_data1 as f1 inner join finance_2 as f2
on f1.id = f2.id
group by year(f2.last_pymnt_d), monthname(f2.last_pymnt_d), f1.home_ownership
order by payment_year;

/* Yearly Interest Received */

select year(last_pymnt_d) as received_year, cast(sum(total_rec_int) as decimal (10,2)) as interest_received
from finance_2
group by received_year
order by received_year;

/* Term Wise Popularity */
select term, sum(loan_amnt) total_amount from finance_1
group by term;

/* Top 5 States */ 
select addr_state as state_name, count(*) as customer_count
from finance_data1
group by addr_state
order by customer_count desc
limit 5;
