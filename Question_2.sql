SELECT 
    CASE 
        WHEN monthly_avg.avg_transactions >= 10 THEN 'High Frequency'
        WHEN monthly_avg.avg_transactions >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(monthly_avg.avg_transactions), 1) AS avg_transactions_per_month
FROM (
    SELECT 
        u.id AS customer_id,
        COUNT(*) / COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) AS avg_transactions
    FROM 
        users_customuser u
    JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE 
        s.transaction_date IS NOT NULL
        AND u.is_account_deleted = 0
        AND u.is_active = 1
    GROUP BY 
        u.id
) AS monthly_avg
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2	
        ELSE 3
    END;