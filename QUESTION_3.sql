SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(COALESCE(s.transaction_date, p.last_charge_date)) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), MAX(COALESCE(s.transaction_date, p.last_charge_date))) AS inactivity_days
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount s ON p.id = s.plan_id AND s.confirmed_amount > 0
WHERE 
    p.is_deleted = 0
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY 
    p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
HAVING 
    last_transaction_date IS NOT NULL
    AND DATEDIFF(CURRENT_DATE(), last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;