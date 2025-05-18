USE adashi_staging

SELECT 
    s.id as owner_id,
    CONCAT(COALESCE(u.first_name,'' ), ' ', COALESCE(u.last_name,'')) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT 
				CASE 
				WHEN p.is_fixed_investment = 1 OR p.is_managed_portfolio = 1 
                THEN p.id END) AS investment_count,
    (SUM(s.amount) + SUM(CASE 
							WHEN p.is_fixed_investment = 1 OR p.is_managed_portfolio = 1
                            THEN p.amount ELSE 0 END)) AS total_deposits
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    plans_plan p ON u.id = p.owner_id
WHERE 
    -- Filter for funded savings accounts (assuming confirmed_amount > 0 means funded)
    s.confirmed_amount > 0
    -- Filter for investment plans (using the flags from the plans_plan table)
    AND (p.is_fixed_investment = 1 OR p.is_managed_portfolio = 1)
    -- Exclude deleted/inactive accounts
    AND u.is_account_deleted = 0
    AND u.is_active = 1
GROUP BY 
    s.id,u.first_name, u.last_name
HAVING 
    -- Must have at least one savings account and one investment plan
    COUNT(DISTINCT s.id) >= 1 
    AND COUNT(DISTINCT CASE WHEN p.is_fixed_investment = 1 OR p.is_managed_portfolio = 1 THEN p.id END) >= 1
ORDER BY 
    total_deposits DESC;
    
    
    