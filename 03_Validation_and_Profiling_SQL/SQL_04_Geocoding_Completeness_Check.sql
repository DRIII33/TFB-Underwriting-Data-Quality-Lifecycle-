-- 4. Cross-System Financial Reconciliation
-- Financial Misalignment Detection
SELECT
Premium Discrepancy' as issue_type,
COUNT(*) as record_count
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` pc
JOIN `driiiportfolio.raw_underwriting_data.bc_policy` bc
ON pc.PolicyNumber = bc.PolicyNumber
WHERE ABS(pc.TotalPremium - bc.TotalPremium) > 0.01;
