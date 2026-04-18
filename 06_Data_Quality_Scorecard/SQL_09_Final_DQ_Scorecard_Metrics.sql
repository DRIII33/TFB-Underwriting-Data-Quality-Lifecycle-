-- The Data Quality Scorecard SQL
-- The Data Quality Scorecard SQL

WITH
DQ_Metrics AS (
-- Total Record Base for Percentages
SELECT
(
SELECT COUNT(*)
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
) AS total_policies,
(
SELECT COUNT(*)
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`
) AS total_locations,
(SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`)
AS total_vehicles,

-- Issue Counts from the Automated Issues Log
(
SELECT COUNT(*)
FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
WHERE Rule_Category = 'HB 2067 Compliance'
) AS hb2067_issues,
(
SELECT COUNT(*)
FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
WHERE Rule_Category = 'Referential Integrity'
) AS orphan_issues,
(
SELECT COUNT(*)
FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
WHERE Rule_Category = 'Catastrophe Modeling'
) AS geo_issues,
(
SELECT COUNT(*)
FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
WHERE Rule_Category = 'Data Standards'
) AS vin_issues,
(
SELECT COUNT(*)
FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
WHERE Rule_Category = 'System Alignment'
) AS financial_issues
)
SELECT
Accuracy' AS Dimension,
ROUND(
(
1 - (hb2067_issues + geo_issues + vin_issues + financial_issues)
/ NULLIF((total_policies + total_locations + total_vehicles), 0))
* 100,
2)
|| '%' AS Current_Score,
< 1.0% Error Rate' AS Dept_Target,
CASE
WHEN
(hb2067_issues + geo_issues + vin_issues + financial_issues)
/ NULLIF((total_policies + total_locations + total_vehicles), 0)
< 0.01
THEN 'PASS'
ELSE 'FAIL'
END
AS Status
FROM DQ_Metrics
UNION ALL
SELECT
Completeness (HB 2067)' AS Dimension,
ROUND((1 - (hb2067_issues / NULLIF(total_policies, 0))) * 100, 2) || '%'
AS Current_Score,
100% (No Nulls)' AS Dept_Target,
CASE WHEN hb2067_issues = 0 THEN 'PASS' ELSE 'FAIL' END AS Status
FROM DQ_Metrics
UNION ALL
SELECT
Consistency (PC vs BC)' AS Dimension,
CAST(financial_issues AS STRING) AS Current_Score,
0 Discrepancies' AS Dept_Target,
CASE WHEN financial_issues = 0 THEN 'PASS' ELSE 'FAIL' END AS Status
FROM DQ_Metrics
UNION ALL
SELECT
Integrity (Orphans)' AS Dimension,
CAST(orphan_issues AS STRING) AS Current_Score,
0 Orphans' AS Dept_Target,
CASE WHEN orphan_issues = 0 THEN 'PASS' ELSE 'FAIL' END AS Status
FROM DQ_Metrics
UNION ALL
SELECT
Validity (VIN Format)' AS Dimension,
ROUND((1 - (vin_issues / NULLIF(total_vehicles, 0))) * 100, 2) || '%'
AS Current_Score,
100%' AS Dept_Target,
CASE WHEN vin_issues = 0 THEN 'PASS' ELSE 'FAIL' END AS Status
FROM DQ_Metrics;
