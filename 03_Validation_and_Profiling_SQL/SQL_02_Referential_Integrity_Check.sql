-- 2. Referential Integrity & Geocoding Assessment
-- Detecting Orphan Risks and Missing Coastal Geocoding
SELECT
Orphan Location' as issue_type,
COUNT(*) as record_count
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` l
LEFT JOIN `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
ON l.BranchID = p.ID
WHERE p.ID IS NULL

UNION ALL

SELECT
Missing Coastal Geocoding' as issue_type,
COUNT(*) as record_count
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`
WHERE County IN ('Harris', 'Galveston', 'Nueces', 'Cameron')
AND (Latitude IS NULL OR Longitude IS NULL);
