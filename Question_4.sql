
SELECT 
    u.id AS customer_id,
    CONCAT(COALESCE(u.first_name, ''), ' ', COALESCE(u.last_name, '')) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (
            (COUNT(s.id) / 
            GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()), 1)) * 
            12 * 
            (SUM(s.confirmed_amount) / GREATEST(COUNT(s.id), 1)) * 
            0.001
        ), 
    2) AS estimated_clv
FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON u.id = s.owner_id AND s.confirmed_amount > 0
WHERE 
    u.is_account_deleted = 0
    AND u.is_active = 1
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
HAVING 
    COUNT(s.id) > 0  -- Only include customers with transactions
ORDER BY 
    estimated_clv DESC;