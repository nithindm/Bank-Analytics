create database bank_loan_analysis;
use bank_loan_analysis;

select * from finance_1;
select * from finance_2;

# KPI 1 Year wise loan amount 
create view Year_Wise_Loan_Amnt as
select year(issue_d) as "Issued Year", concat("$",format(sum(loan_amnt)/1000000,2),"M") as "Total Loan Amount" from finance_1
group by year(issue_d)
order by year(issue_d) desc
;

select * from Year_Wise_Loan_Amnt;

# KPI 2 Grade and sub grade wise revol_bal
create view Grade_Subgrade_Wise_RevolBal as
Select f1.grade as Grade, f1.sub_grade as "Sub-Grade", concat("$",format(sum(f2.revol_bal)/1000000,2),"M") as Revol_bal
from finance_1 as f1 inner join finance_2 as f2
on (f1.id = f2.id)
group by f1.grade, f1.sub_grade
order by f1.grade, f1.sub_grade;

select * from Grade_Subgrade_Wise_RevolBal;

# KPI 3 Total Payment for Verified Status Vs Total Payment for Non Verified Status
create view TotalPymnt_Verfied_vs_NonVerified as
SELECT
    CASE 
        WHEN f1.verification_status IN ('Verified', 'Source Verified') THEN 'Verified'
        ELSE f1.verification_status
    END AS Group_Verification_status,
    CONCAT("$", FORMAT(ROUND(SUM(f2.total_pymnt) / 1000000, 2), 2), "M") AS Total_payment
FROM
    finance_1 AS f1
INNER JOIN
    finance_2 AS f2 ON f1.id = f2.id
GROUP BY
   Group_Verification_status;
   
select * from TotalPymnt_Verfied_vs_NonVerified;

# KPI 4 State wise and month wise loan status
create view State_Month_Wise_LoanStatus as
SELECT
    f1.addr_state as State,
    month(f2.last_credit_pull_d) as "Month",
    monthname(f2.last_credit_pull_d) AS "Month Name",
    COUNT(*) AS "Loan Status Count",
    SUM(CASE WHEN f1.loan_status = 'Fully Paid' THEN 1 ELSE 0 END) AS "Fully paid",
    SUM(CASE WHEN f1.loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS "Charged Off",
    SUM(CASE WHEN f1.loan_status = 'Current' THEN 1 ELSE 0 END) AS "Current"
FROM
    finance_1 f1, finance_2 f2
    where f1.id = f2.id
GROUP BY
    f1.addr_state,month(f2.last_credit_pull_d), monthname(f2.last_credit_pull_d)
ORDER BY
    f1.addr_state,Month;

select * from State_Month_Wise_LoanStatus;

# KPI 5 Home ownership Vs last payment date stats
create view HomeOwnership_vs_LastPymntD as
select f1.home_ownership,
	   f2.last_pymnt_d,
       concat("$", format(sum(last_pymnt_amnt)/1000,2), "K") as "Last Payment Amount"
from finance_1 as f1
inner join finance_2 as f2
on f1.id = f2.id
where f2.last_pymnt_d <> ""
group by f1.home_ownership, f2.last_pymnt_d
order by f2.last_pymnt_d desc;

select * from HomeOwnership_vs_LastPymntD;



