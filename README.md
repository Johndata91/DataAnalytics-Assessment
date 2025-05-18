# DataAnalytics-Assessment

Coming from a strong background in MSSQL and PostgreSQL, I initially found MySQL’s syntax and behavior a bit surprising. Small but critical differences—like the way each database handles NULL values in aggregations or the stricter requirements for GROUP BY clauses—caught me off guard at first.
For example, when calculating transaction frequencies, I had to rethink my usual approach to date formatting because MySQL’s DATE_FORMAT() function uses different specifiers than what I was accustomed to. And while working on the CLV estimation, I discovered that MySQL’s TIMESTAMPDIFF() behaves slightly differently than similar functions in other databases, requiring adjustments to avoid edge cases like negative tenure for new customers.
To bridge the gap, I leaned heavily on MySQL’s documentation on W3SCHOOL and ran small test queries to validate my assumptions. 

# Question 1
My first approach was understanding the table and working with the guide and hint provided in the assesment document. The identify customers with both saving and invesments plans.
I had to use CONCAT & COALESCE for clear name format to align with the expected output. I also calculated total deposits of each customer and sorted them out in decending order.
CHALLENGES - I had to use DISTINCT to avoid duplicate records 

# Question 2 

I Calculated transactions per customer per month (DATE_FORMAT) & Derived monthly averages by dividing total transactions by active months. Created frequency tiers using CASE statements using the guide provided in the document.

CHALLENGES - Date handing was very difficult for me, needed to group by by year and month.

# Question 3 

I performed a left join and I have to use Max_transactional_date to get the last activity & den filtered for inactive days greater than 356 days.

CHALLENGES - Created clear labels using CASE statements based on is_regular_savings/is_a_fund flags & also added NULL checks to remove account with no activity.

# Question 4 

Calculated account tenure in months (TIMESTAMPDIFF), Counted all confirmed transactions. Applied CLV formula: (transactions/tenure)*12*(avg_amount*0.001). given that the " "profit_per_transaction is 0.1% = 0.001 of the transaction value". I used GREATEST() to prevent division by zero.

CHALLENGES-   I found myself having quick sync-ups with different thought to confirm things like "Does a withdrawal count as activity?" or "Is 0.1% really our profit margin?"
