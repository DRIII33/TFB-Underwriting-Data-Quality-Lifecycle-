-- 3. High Severity RCA: Catastrophe Modeling (594 Issues)
-- RCA Query: Geocoding Gap Analysis by County
SELECT
County,
COUNT(*) as total_missing,
Vendor API Failure' as suspected_origin
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`
WHERE County IN ('Harris', 'Galveston', 'Nueces', 'Cameron')
AND (Latitude IS NULL OR Longitude IS NULL)
GROUP BY County;
