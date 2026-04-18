--1. Statutory Compliance Assessment (HB 2067)
-- Validation for HB 2067 Reason Code Reconciliation
SELECT
Missing Reason Code' as issue_type,
COUNT(*) as record_count
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
WHERE Status = 'Canceled' AND CancellationReasonCode IS NULL

UNION ALL

SELECT
Unmapped Reason Code (INT_99)' as issue_type,
COUNT(*) as record_count
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
LEFT JOIN `driiiportfolio.raw_underwriting_data.TDI_Reason_Mapping` t
ON p.CancellationReasonCode = t.InternalCode
WHERE p.Status = 'Canceled'
AND p.CancellationReasonCode IS NOT NULL
AND t.InternalCode IS NULL;
