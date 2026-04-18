-- 4. Financial Reconciliation Layer (System Alignment)
--4. Financial Reconciliation Layer (System Alignment)
CREATE OR REPLACE VIEW `driiiportfolio.raw_underwriting_data.vw_financial_reconciliation` AS
SELECT
pc.PolicyNumber,
pc.TotalPremium as PC_Premium,
bc.TotalPremium as BC_Premium,
ROUND(bc.TotalPremium - pc.TotalPremium, 2) as Adjustment_Amount,
CASE
WHEN ABS(pc.TotalPremium - bc.TotalPremium) > 0.01 THEN 'DISCREPANCY'
ELSE 'ALIGNED'
END as Alignment_Status
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` pc
JOIN `driiiportfolio.raw_underwriting_data.bc_policy` bc
ON pc.PolicyNumber = bc.PolicyNumber;
