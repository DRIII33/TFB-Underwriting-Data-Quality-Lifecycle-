-- 1. Critical RCA: HB 2067 Statutory Compliance (140 Issues)
-- RCA Query: Temporal Pattern Analysis for HB 2067
SELECT
CreateTime,
Status,
COUNTIF(CancellationReasonCode IS NULL) as missing_count,
COUNTIF(CancellationReasonCode = 'INT_99') as unmapped_count
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
WHERE (Status = 'Canceled' AND CancellationReasonCode IS NULL)
OR (CancellationReasonCode = 'INT_99')
GROUP BY 1, 2
ORDER BY 1 ASC;
