-- 2. Cleansed Location Data (Referential & Geo Correction)
--2. Cleansed Location Data (Referential & Geo Correction)
CREATE OR REPLACE VIEW `driiiportfolio.raw_underwriting_data.vw_pc_policylocation_cleansed` AS
SELECT
l.*,
CASE
WHEN Latitude IS NULL OR Longitude IS NULL THEN 'GEOCODE_REQUIRED'
ELSE 'GEOCODE_VALID'
END as Geo_Health_Status
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` l
INNER JOIN `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
ON l.BranchID = p.ID; -- Inner Join removes the 20 Orphans
