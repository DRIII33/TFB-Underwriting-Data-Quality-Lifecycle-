-- 3. Data Normalization Assessment (VIN Patterns)
-- Identifying Invalid VIN Format (Length != 17 or contains special characters)
SELECT
Invalid VIN Format' as issue_type,
COUNT(*) as record_count
FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`
WHERE LENGTH(VIN) != 17
OR REGEXP_CONTAINS(VIN, r'[^a-zA-Z0-9]');
