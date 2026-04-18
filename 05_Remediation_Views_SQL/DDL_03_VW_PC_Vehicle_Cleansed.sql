-- 3. Cleansed Vehicle Data (Data Standardization)
--3. Cleansed Vehicle Data (Data Standardization)
CREATE OR REPLACE VIEW `driiiportfolio.raw_underwriting_data.vw_pc_vehicle_cleansed` AS
SELECT
PolicyNumber,
VIN as Original_VIN,
CASE
WHEN LENGTH(VIN) = 17 AND NOT REGEXP_CONTAINS(VIN, r'[^a-zA-Z0-9]') THEN VIN
ELSE 'INVALID_FORMAT'
END as Sanitized_VIN
FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`;
