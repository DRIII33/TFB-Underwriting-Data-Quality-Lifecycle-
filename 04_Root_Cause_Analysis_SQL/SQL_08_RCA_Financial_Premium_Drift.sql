-- 4. High Severity RCA: System Alignment (204 Issues)
-- RCA Query: Financial Drift Magnitude Analysis
SELECT
ROUND(pc.TotalPremium - bc.TotalPremium, 2) as drift_amount,
COUNT(*) as record_count
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` pc
JOIN `driiiportfolio.raw_underwriting_data.bc_policy` bc ON pc.PolicyNumber = bc.PolicyNumber
WHERE ABS(pc.TotalPremium - bc.TotalPremium) > 0.01
GROUP BY 1
ORDER BY record_count DESC;
