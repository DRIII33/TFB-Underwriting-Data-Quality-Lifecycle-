-- 2. Critical RCA: Referential Integrity (20 Issues)
-- RCA Query: Identifying Source ID Patterns for Orphans
SELECT
BranchID,
County,
AddressLine1,
COUNT(*) as instances
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`
WHERE BranchID NOT IN (SELECT ID FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`)
GROUP BY 1, 2, 3;
