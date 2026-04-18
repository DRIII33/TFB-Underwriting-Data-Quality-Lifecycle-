-- 1. Cleansed Policy Data (Statutory Correction)
--1. Cleansed Policy Data (Statutory Correction)
CREATE OR REPLACE VIEW `driiiportfolio.raw_underwriting_data.vw_pc_policyperiod_cleansed` AS
SELECT
p.* EXCEPT(CancellationReasonCode),
COALESCE(t.TDICode, 'K') as Cleansed_TDICode, -- Defaulting unmapped to 'K' per business rule
CASE
WHEN t.TDICode IS NULL AND Status = 'Canceled' THEN 'REMEDIATED'
ELSE 'ORIGINAL'
END as Remediation_Status
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
LEFT JOIN `driiiportfolio.raw_underwriting_data.TDI_Reason_Mapping` t
ON p.CancellationReasonCode = t.InternalCode;
