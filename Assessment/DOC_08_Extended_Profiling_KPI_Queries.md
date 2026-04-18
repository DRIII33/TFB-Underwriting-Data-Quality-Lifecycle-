# Extended Profiling & KPI Queries
## Advanced Analytical Depth for Data Quality Excellence

**Document Owner:** Data Quality Analyst II  
**Author:** Daniel Rodriguez III  
**Date:** April 18, 2026  
**Version:** 1.0  
**Classification:** Internal – Technical  
**Query Engine:** BigQuery (with SQL Server equivalents noted)

---

## Table of Contents

1. [Profiling Query Framework](#profiling-query-framework)
2. [Dimension 1: Accuracy Profiling](#dimension-1-accuracy-profiling)
3. [Dimension 2: Completeness Profiling](#dimension-2-completeness-profiling)
4. [Dimension 3: Consistency Profiling](#dimension-3-consistency-profiling)
5. [Dimension 4: Timeliness Profiling](#dimension-4-timeliness-profiling)
6. [Dimension 5: Validity Profiling](#dimension-5-validity-profiling)
7. [Dimension 6: Integrity Profiling](#dimension-6-integrity-profiling)
8. [Advanced Aggregate Profiling](#advanced-aggregate-profiling)
9. [Temporal & Trend Analysis](#temporal--trend-analysis)
10. [Segment-Based Analytics](#segment-based-analytics)
11. [Anomaly Detection Queries](#anomaly-detection-queries)
12. [Dashboard Foundation Queries](#dashboard-foundation-queries)

---

## Profiling Query Framework

### Query Execution Model

```
PROFILING QUERY LAYERS (Execution Order):

Layer 1: Column-Level Profiling (Descriptive Statistics)
├─ Record counts
├─ Null value counts & rates
├─ Distinct value counts
├─ Min/Max/Mean values (numeric)
├─ Length distributions (string)
└─ Data type validation

Layer 2: Relationship Profiling (Data Integrity)
├─ Foreign key validation
├─ Referential integrity checks
├─ Parent-child relationships
└─ Orphaned record detection

Layer 3: Business Rule Profiling (Validation)
├─ Domain constraint violations
├─ Format standard violations
├─ Logical relationship violations
└─ Threshold exceedances

Layer 4: Trend & Temporal Profiling (Change Detection)
├─ Day-over-day variance
├─ Week-over-week trends
├─ Month-over-month patterns
├─ Seasonal decomposition
└─ Anomaly clustering

Layer 5: Segment-Based Profiling (Drill-Down Analysis)
├─ Geographic segmentation (by county, ZIP, region)
├─ Agent segmentation (by agency, producer, tier)
├─ Product segmentation (residential, auto, commercial)
├─ Risk segmentation (high-value, high-risk, coastal)
└─ Temporal segmentation (by date, quarter, year)
```

### Performance Optimization Techniques

```
QUERY OPTIMIZATION:

1. Partition Pruning
   └─ Filter on IngestionDate or DateKey early in query
   └─ Prevents unnecessary scanning of historical data
   └─ Reduces cost by 80%+ when filtering on partitioned column

2. Materialized Views (Pre-Aggregated)
   └─ Expensive aggregations pre-computed nightly
   └─ Queries reference materialized view (much faster)
   └─ Example: DQ_Metrics_Daily (refreshes 6:00 AM daily)

3. Approximate Aggregation Functions
   └─ Use APPROX_DISTINCT() instead of COUNT(DISTINCT) for large cardinality
   └─ Results within 2% error; 10x faster
   └─ Example: Distinct policy count (APPROX_DISTINCT vs. COUNT DISTINCT)

4. Clustering Hints
   └─ Cluster frequently filtered columns
   └─ Reduces scan time by co-locating related data
   └─ Example: Cluster on Status, County, AgentID

5. Join Strategies
   └─ Broadcast joins for small dimension tables
   └─ Hash joins for large fact tables
   └─ Specify join order hints for optimizer
```

---

---

# Dimension 1: Accuracy Profiling

**Definition:** Records conform to business rules and validation constraints.  
**Metric:** % of records failing validation rules  
**Target:** < 1.0% error rate

---

## Query 1.1: Overall Accuracy Score (6-Dimension Weighted)

```sql
-- QUERY: Overall Data Quality Accuracy Score
-- Purpose: Calculate composite accuracy across all validation rules
-- Frequency: Daily (6:00 AM after overnight batch)
-- Owner: Data Quality Analyst II

WITH DQ_Metrics AS (
  -- Collect baseline record counts
  SELECT
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`) AS total_policies,
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`) AS total_locations,
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`) AS total_vehicles,
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.bc_policy`) AS total_billingcenter,
    
    -- Count violations by category from Automated Issues Log
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
     WHERE Rule_Category = 'HB 2067 Compliance' 
     AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS hb2067_violations,
    
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
     WHERE Rule_Category = 'Referential Integrity' 
     AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS referential_violations,
    
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
     WHERE Rule_Category = 'Catastrophe Modeling' 
     AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS geocoding_violations,
    
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
     WHERE Rule_Category = 'Data Standards' 
     AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS data_standards_violations,
    
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
     WHERE Rule_Category = 'System Alignment' 
     AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS financial_violations
)

SELECT
  CURRENT_DATE() AS Report_Date,
  
  -- Accuracy Score (6.57% error rate = 93.43% accuracy)
  ROUND(
    (1 - (hb2067_violations + geocoding_violations + data_standards_violations + financial_violations) 
     / NULLIF((total_policies + total_locations + total_vehicles), 0)) * 100, 2
  ) AS Accuracy_Percent,
  
  -- Completeness Score (filled mandatory fields)
  ROUND(
    (1 - (hb2067_violations / NULLIF(total_policies, 0))) * 100, 2
  ) AS Completeness_Percent,
  
  -- Consistency Score (PC vs BC alignment)
  ROUND(
    (1 - (financial_violations / NULLIF(total_policies, 0))) * 100, 2
  ) AS Consistency_Percent,
  
  -- Timeliness (ETL load lag in hours)
  TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), 
    (SELECT MAX(load_completion_time) FROM `driiiportfolio.metadata.etl_job_log`), 
    HOUR) AS Timeliness_Hours,
  
  -- Validity Score (conformance to TDI codes + formats)
  ROUND(
    (1 - ((data_standards_violations + hb2067_violations) / NULLIF((total_vehicles + total_policies), 0))) * 100, 2
  ) AS Validity_Percent,
  
  -- Integrity Score (no orphaned records)
  ROUND(
    (1 - (referential_violations / NULLIF(total_locations, 0))) * 100, 2
  ) AS Integrity_Percent,
  
  -- Weighted Overall Score (20% each Accuracy, Completeness, Consistency + 15% Timeliness, Validity, 10% Integrity)
  ROUND(
    (0.20 * ROUND((1 - (hb2067_violations + geocoding_violations + data_standards_violations + financial_violations) 
                    / NULLIF((total_policies + total_locations + total_vehicles), 0)) * 100, 2) +
     0.20 * ROUND((1 - (hb2067_violations / NULLIF(total_policies, 0))) * 100, 2) +
     0.20 * ROUND((1 - (financial_violations / NULLIF(total_policies, 0))) * 100, 2) +
     0.15 * CASE WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), 
               (SELECT MAX(load_completion_time) FROM `driiiportfolio.metadata.etl_job_log`), HOUR) < 4 
             THEN 100 ELSE 50 END +
     0.15 * ROUND((1 - ((data_standards_violations + hb2067_violations) / NULLIF((total_vehicles + total_policies), 0))) * 100, 2) +
     0.10 * ROUND((1 - (referential_violations / NULLIF(total_locations, 0))) * 100, 2)
    ), 2
  ) AS Overall_DQ_Score,
  
  -- Violation Breakdown
  hb2067_violations AS HB2067_Violations,
  referential_violations AS Referential_Violations,
  geocoding_violations AS Geocoding_Violations,
  data_standards_violations AS Data_Standards_Violations,
  financial_violations AS Financial_Violations,
  
  -- Total Violations
  (hb2067_violations + referential_violations + geocoding_violations + 
   data_standards_violations + financial_violations) AS Total_Violations,
  
  -- Compliance Status
  CASE 
    WHEN (hb2067_violations + geocoding_violations + data_standards_violations + financial_violations) 
         / NULLIF((total_policies + total_locations + total_vehicles), 0) < 0.01 
    THEN 'PASS'
    ELSE 'FAIL'
  END AS Accuracy_Status,
  
  CASE 
    WHEN ROUND((1 - (hb2067_violations / NULLIF(total_policies, 0))) * 100, 2) = 100 
    THEN 'PASS'
    ELSE 'FAIL'
  END AS Completeness_Status,
  
  CASE 
    WHEN financial_violations = 0 
    THEN 'PASS'
    ELSE 'FAIL'
  END AS Consistency_Status

FROM DQ_Metrics;

-- Expected Output (April 18, 2026 baseline):
-- ┌────────────┬──────────┬─────────────┬────────────┐
-- │Report_Date │Accuracy  │Completeness │Consistency│
-- ├────────────┼──────────┼────────���────┼────────────┤
-- │2026-04-18  │93.43%    │97.85%       │59.20%      │
-- └────────────┴──────────┴─────────────┴────────────┘
```

---

## Query 1.2: Rule-Level Accuracy Distribution

```sql
-- QUERY: Accuracy Score by Individual Validation Rule
-- Purpose: Identify which rules have highest violation rates
-- Frequency: Daily
-- Owner: Data Quality Analyst II

SELECT
  CURRENT_DATE() AS Report_Date,
  Requirement_ID,
  Rule_Category,
  Severity,
  COUNT(*) AS Violation_Count,
  
  -- Calculate failure rate
  ROUND(
    COUNT(*) / (
      SELECT SUM(CASE 
        WHEN Rule_Category = 'HB 2067 Compliance' THEN 
          (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` 
           WHERE Status IN ('Canceled', 'NonRenewed', 'Declined'))
        WHEN Rule_Category = 'Referential Integrity' THEN 
          (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`)
        WHEN Rule_Category = 'Catastrophe Modeling' THEN 
          (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` 
           WHERE County IN ('Harris', 'Galveston', 'Nueces', 'Cameron'))
        WHEN Rule_Category = 'Data Standards' THEN 
          (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`)
        WHEN Rule_Category = 'System Alignment' THEN 
          (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`)
      END)
    ) * 100, 2
  ) AS Failure_Rate_Percent,
  
  -- Determine pass/fail against threshold
  CASE 
    WHEN Severity = 'CRITICAL' AND COUNT(*) > 0 THEN 'FAIL (0% threshold)'
    WHEN Severity = 'HIGH' AND COUNT(*) / (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`) > 0.01 THEN 'FAIL (1% threshold)'
    WHEN Severity = 'MEDIUM' AND COUNT(*) / (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`) > 0.05 THEN 'FAIL (5% threshold)'
    ELSE 'PASS'
  END AS Status,
  
  -- Time-to-first-violation (oldest issue in log for this rule)
  MIN(Detection_Timestamp) AS First_Detected,
  MAX(Detection_Timestamp) AS Last_Detected,
  TIMESTAMP_DIFF(MAX(Detection_Timestamp), MIN(Detection_Timestamp), HOUR) AS Hours_Active,
  
  -- Escalation level
  CASE 
    WHEN Severity = 'CRITICAL' THEN 'IMMEDIATE (1-4 hrs)'
    WHEN Severity = 'HIGH' THEN 'URGENT (24 hrs)'
    WHEN Severity = 'MEDIUM' THEN 'STANDARD (5 days)'
  END AS Escalation_SLA

FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
WHERE Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)
GROUP BY Requirement_ID, Rule_Category, Severity
ORDER BY Failure_Rate_Percent DESC;

-- Expected Output:
-- ┌─────────────┬────────────┬──────────────┬──────────┐
-- │Requirement  │Category    │Failure_Rate  │Status    │
-- ├─────────────┼────────────┼──────────────┼──────────┤
-- │VR-001-001   │HB 2067     │2.80%         │FAIL      │
-- │VR-003-001   │Fmt Std     │9.05%         │FAIL      │
-- │VR-005-001   │Geo Model   │100.00%       │FAIL      │
-- │VR-001-002   │Mandatory   │0.00%         │PASS      │
-- └─────────────┴────────────┴──────────────┴──────────┘
```

---

## Query 1.3: Field-Level Accuracy (Column-By-Column Validation)

```sql
-- QUERY: Accuracy Profile by Field/Column
-- Purpose: Identify which specific fields have data quality issues
-- Frequency: Weekly (detailed analysis)
-- Owner: Data Quality Analyst II

WITH Field_Accuracy AS (
  SELECT
    'CancellationReasonCode' AS Field_Name,
    'String' AS Data_Type,
    COUNT(*) AS Total_Records,
    COUNT(CASE WHEN CancellationReasonCode IS NOT NULL THEN 1 END) AS Non_Null_Count,
    COUNT(DISTINCT CancellationReasonCode) AS Distinct_Values,
    
    -- Null Rate
    ROUND(
      (COUNT(*) - COUNT(CASE WHEN CancellationReasonCode IS NOT NULL THEN 1 END)) 
      / COUNT(*) * 100, 2
    ) AS Null_Rate_Percent,
    
    -- Invalid Format Rate (should be alphanumeric, length 1-10)
    ROUND(
      COUNT(CASE WHEN CancellationReasonCode IS NOT NULL 
                  AND (LENGTH(CancellationReasonCode) > 10 
                       OR REGEXP_CONTAINS(CancellationReasonCode, r'[^a-zA-Z0-9|_]'))
                THEN 1 
      END) / COUNT(*) * 100, 2
    ) AS Invalid_Format_Percent,
    
    -- Top 5 Values (for enum/domain fields)
    [LIST OF TOP DISTINCT VALUES WITH COUNTS],
    
    'HB 2067 Compliance' AS Business_Impact,
    'CRITICAL' AS Priority
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
  WHERE Status IN ('Canceled', 'NonRenewed', 'Declined')
  
  UNION ALL
  
  SELECT
    'VIN' AS Field_Name,
    'String' AS Data_Type,
    COUNT(*) AS Total_Records,
    COUNT(CASE WHEN VIN IS NOT NULL THEN 1 END) AS Non_Null_Count,
    COUNT(DISTINCT VIN) AS Distinct_Values,
    ROUND((COUNT(*) - COUNT(CASE WHEN VIN IS NOT NULL THEN 1 END)) / COUNT(*) * 100, 2) AS Null_Rate,
    ROUND(
      COUNT(CASE WHEN VIN IS NOT NULL 
                  AND (LENGTH(VIN) != 17 OR REGEXP_CONTAINS(VIN, r'[^a-zA-Z0-9]'))
                THEN 1 
      END) / COUNT(*) * 100, 2
    ) AS Invalid_Format_Percent,
    'VIN Standardization' AS Business_Impact,
    'MEDIUM' AS Priority
  FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`
  
  UNION ALL
  
  SELECT
    'TotalPremium' AS Field_Name,
    'Decimal(10,2)' AS Data_Type,
    COUNT(*) AS Total_Records,
    COUNT(CASE WHEN TotalPremium IS NOT NULL THEN 1 END) AS Non_Null_Count,
    COUNT(DISTINCT TotalPremium) AS Distinct_Values,
    ROUND((COUNT(*) - COUNT(CASE WHEN TotalPremium IS NOT NULL THEN 1 END)) / COUNT(*) * 100, 2) AS Null_Rate,
    ROUND(
      COUNT(CASE WHEN TotalPremium <= 0 OR TotalPremium > 99999999.99 THEN 1 END) 
      / COUNT(*) * 100, 2
    ) AS Invalid_Value_Percent,
    'Financial Integrity' AS Business_Impact,
    'CRITICAL' AS Priority
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
)

SELECT *
FROM Field_Accuracy
ORDER BY Priority DESC, Invalid_Format_Percent DESC;

-- SQL Server Equivalent (Partial):
/*
SELECT TOP 20
  'CancellationReasonCode' as FieldName,
  COUNT(*) as TotalCount,
  SUM(CASE WHEN CancellationReasonCode IS NULL THEN 1 ELSE 0 END) as NullCount,
  ROUND(
    SUM(CASE WHEN CancellationReasonCode IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
  ) as NullPercent,
  COUNT(DISTINCT CancellationReasonCode) as DistinctCount
FROM pc_policyperiod
WHERE Status = 'Canceled'
GROUP BY 1
*/
```

---

---

# Dimension 2: Completeness Profiling

**Definition:** All mandatory fields for underwriting and reporting are populated.  
**Metric:** Fill rate for mandatory TDI fields  
**Target:** 100% (No Nulls)

---

## Query 2.1: Completeness Index by Table

```sql
-- QUERY: Completeness Score for All Tables
-- Purpose: Measure fill rates for mandatory fields
-- Frequency: Daily
-- Owner: Data Quality Analyst II

WITH Mandatory_Fields AS (
  SELECT
    'pc_policyperiod' AS Table_Name,
    COUNT(*) AS Total_Records,
    
    -- Core mandatory fields
    COUNT(CASE WHEN PolicyNumber IS NOT NULL THEN 1 END) AS PolicyNumber_Filled,
    COUNT(CASE WHEN Status IS NOT NULL THEN 1 END) AS Status_Filled,
    COUNT(CASE WHEN EffectiveDate IS NOT NULL THEN 1 END) AS EffectiveDate_Filled,
    COUNT(CASE WHEN ExpirationDate IS NOT NULL THEN 1 END) AS ExpirationDate_Filled,
    COUNT(CASE WHEN AgentID IS NOT NULL THEN 1 END) AS AgentID_Filled,
    
    -- HB 2067 mandatory field (if canceled/declined/nonrenewed)
    COUNT(CASE WHEN Status NOT IN ('Canceled', 'NonRenewed', 'Declined') 
               OR CancellationReasonCode IS NOT NULL THEN 1 END) AS CancellationReasonCode_Compliant,
    
    -- Overall completeness index
    ROUND(
      (
        COUNT(CASE WHEN PolicyNumber IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN Status IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN EffectiveDate IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN ExpirationDate IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN AgentID IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN Status NOT IN ('Canceled', 'NonRenewed', 'Declined') 
                   OR CancellationReasonCode IS NOT NULL THEN 1 END)
      ) / (COUNT(*) * 6) * 100, 2
    ) AS Completeness_Index_Percent
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
  
  UNION ALL
  
  SELECT
    'pc_policylocation' AS Table_Name,
    COUNT(*) AS Total_Records,
    COUNT(CASE WHEN Location_ID IS NOT NULL THEN 1 END) AS Location_ID_Filled,
    COUNT(CASE WHEN LocationNumber IS NOT NULL THEN 1 END) AS LocationNumber_Filled,
    COUNT(CASE WHEN BranchID IS NOT NULL THEN 1 END) AS BranchID_Filled,
    COUNT(CASE WHEN AddressLine1 IS NOT NULL THEN 1 END) AS AddressLine1_Filled,
    COUNT(CASE WHEN County IS NOT NULL THEN 1 END) AS County_Filled,
    COUNT(CASE WHEN County NOT IN ('Harris', 'Galveston', 'Nueces', 'Cameron') 
               OR (Latitude IS NOT NULL AND Longitude IS NOT NULL) THEN 1 END) AS Geocoding_Compliant,
    
    ROUND(
      (
        COUNT(CASE WHEN Location_ID IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN LocationNumber IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN BranchID IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN AddressLine1 IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN County IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN County NOT IN ('Harris', 'Galveston', 'Nueces', 'Cameron') 
                   OR (Latitude IS NOT NULL AND Longitude IS NOT NULL) THEN 1 END)
      ) / (COUNT(*) * 6) * 100, 2
    ) AS Completeness_Index_Percent
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`
  
  UNION ALL
  
  SELECT
    'pc_vehicle' AS Table_Name,
    COUNT(*) AS Total_Records,
    COUNT(CASE WHEN PolicyNumber IS NOT NULL THEN 1 END) AS PolicyNumber_Filled,
    COUNT(CASE WHEN VehicleNumber IS NOT NULL THEN 1 END) AS VehicleNumber_Filled,
    COUNT(CASE WHEN VIN IS NOT NULL AND LENGTH(VIN) = 17 THEN 1 END) AS VIN_Valid,
    0 AS Field_4,
    0 AS Field_5,
    0 AS Field_6,
    
    ROUND(
      (
        COUNT(CASE WHEN PolicyNumber IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN VehicleNumber IS NOT NULL THEN 1 END) +
        COUNT(CASE WHEN VIN IS NOT NULL AND LENGTH(VIN) = 17 THEN 1 END)
      ) / (COUNT(*) * 3) * 100, 2
    ) AS Completeness_Index_Percent
    
  FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`
)

SELECT *
FROM Mandatory_Fields
ORDER BY Completeness_Index_Percent ASC;

-- Expected Output:
-- ┌─────────────────┬──────────┬───────────────┐
-- │Table_Name       │Records   │Completeness % │
-- ├─────────────────┼──────────┼───────────────┤
-- │pc_policyperiod  │5000      │97.85%         │
-- │pc_policylocation│7500      │97.33%         │
-- │pc_vehicle       │3800      │98.42%         │
-- └─────────────────┴──────────┴───────────────┘
```

---

## Query 2.2: Missing Data Trend Analysis (Day-Over-Day)

```sql
-- QUERY: Completeness Trend - Track Missing Field Changes Over Time
-- Purpose: Detect if null rates are increasing/decreasing
-- Frequency: Daily
-- Owner: Data Quality Analyst II

WITH Daily_Completeness AS (
  SELECT
    CAST(CreateTime AS DATE) AS Report_Date,
    'CancellationReasonCode' AS Field_Name,
    'pc_policyperiod' AS Table_Name,
    COUNT(*) AS Total_Records,
    COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END) AS Canceled_Records,
    COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
               AND CancellationReasonCode IS NOT NULL THEN 1 END) AS Populated_Records,
    
    ROUND(
      (COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
                  AND CancellationReasonCode IS NOT NULL THEN 1 END) 
       / NULLIF(COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END), 0)) * 100, 2
    ) AS Completion_Rate_Percent,
    
    -- Calculate variance from previous day
    LAG(
      ROUND(
        (COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
                    AND CancellationReasonCode IS NOT NULL THEN 1 END) 
         / NULLIF(COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END), 0)) * 100, 2
      )
    ) OVER (ORDER BY CAST(CreateTime AS DATE)) AS Prior_Day_Rate,
    
    -- Trend indicator
    CASE 
      WHEN LAG(
        ROUND(
          (COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
                      AND CancellationReasonCode IS NOT NULL THEN 1 END) 
           / NULLIF(COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END), 0)) * 100, 2
        )
      ) OVER (ORDER BY CAST(CreateTime AS DATE)) IS NULL
      THEN '→ BASELINE'
      WHEN ROUND(
        (COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
                    AND CancellationReasonCode IS NOT NULL THEN 1 END) 
         / NULLIF(COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END), 0)) * 100, 2
      ) > LAG(
        ROUND(
          (COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
                      AND CancellationReasonCode IS NOT NULL THEN 1 END) 
           / NULLIF(COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END), 0)) * 100, 2
        )
      ) OVER (ORDER BY CAST(CreateTime AS DATE))
      THEN '↑ IMPROVING'
      WHEN ROUND(
        (COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
                    AND CancellationReasonCode IS NOT NULL THEN 1 END) 
         / NULLIF(COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END), 0)) * 100, 2
      ) < LAG(
        ROUND(
          (COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') 
                      AND CancellationReasonCode IS NOT NULL THEN 1 END) 
           / NULLIF(COUNT(CASE WHEN Status IN ('Canceled', 'NonRenewed', 'Declined') THEN 1 END), 0)) * 100, 2
        )
      ) OVER (ORDER BY CAST(CreateTime AS DATE))
      THEN '↓ DEGRADING'
      ELSE '→ STABLE'
    END AS Trend
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
  WHERE CreateTime >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY Report_Date
)

SELECT *
FROM Daily_Completeness
ORDER BY Report_Date DESC;

-- Expected Output (April 17-18, 2026):
-- ┌─────────────┬──────────────┬──────────┬────────┐
-- │Report_Date  │Field_Name    │Rate %    │Trend   │
-- ├─────────────┼──────────────┼──────────┼────────┤
-- │2026-04-18   │Reason Code   │97.85%    │→ STABLE│
-- │2026-04-17   │Reason Code   │97.85%    │↓ DEGR..│
-- │2026-04-16   │Reason Code   │98.57%    │↑ IMPR..│
-- └─────────────┴──────────────┴──────────┴────────┘
```

---

---

# Dimension 3: Consistency Profiling

**Definition:** Data is uniform across systems and maintains referential integrity.  
**Metric:** Mismatch count between PolicyCenter and BillingCenter  
**Target:** 0 Discrepancies

---

## Query 3.1: Cross-System Premium Reconciliation

```sql
-- QUERY: PolicyCenter vs. BillingCenter Premium Reconciliation
-- Purpose: Identify financial discrepancies between systems
-- Frequency: Nightly (after BillingCenter load)
-- Owner: Data Quality Analyst II

WITH Premium_Variance AS (
  SELECT
    pc.PolicyNumber,
    pc.Status AS PC_Status,
    bc.Status AS BC_Status,
    pc.TotalPremium AS PC_Premium,
    bc.TotalPremium AS BC_Premium,
    ROUND(bc.TotalPremium - pc.TotalPremium, 2) AS Variance_Amount,
    ROUND(ABS(bc.TotalPremium - pc.TotalPremium), 2) AS Absolute_Variance,
    
    -- Variance percentage
    CASE 
      WHEN pc.TotalPremium = 0 THEN 'ZERO_DENOMINATOR'
      ELSE ROUND(ABS(bc.TotalPremium - pc.TotalPremium) / pc.TotalPremium * 100, 2)
    END AS Variance_Percent,
    
    -- Classification
    CASE 
      WHEN ABS(bc.TotalPremium - pc.TotalPremium) <= 0.01 THEN 'ALIGNED'
      WHEN ABS(bc.TotalPremium - pc.TotalPremium) BETWEEN 0.01 AND 10 THEN 'MINOR'
      WHEN ABS(bc.TotalPremium - pc.TotalPremium) BETWEEN 10 AND 100 THEN 'MODERATE'
      WHEN ABS(bc.TotalPremium - pc.TotalPremium) > 100 THEN 'MAJOR'
    END AS Variance_Severity,
    
    -- Root cause hypothesis
    CASE 
      WHEN pc.TotalPremium = bc.TotalPremium THEN 'No discrepancy'
      WHEN bc.TotalPremium > pc.TotalPremium THEN 'BillingCenter over-charging (pro-rata error?)'
      WHEN bc.TotalPremium < pc.TotalPremium THEN 'BillingCenter under-charging (credit applied?)'
    END AS Hypothesis
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` pc
  JOIN `driiiportfolio.raw_underwriting_data.bc_policy` bc
    ON pc.PolicyNumber = bc.PolicyNumber
  WHERE pc.IsMostRecentModel = 1
)

-- Summary Statistics
SELECT
  COUNT(*) AS Total_Policies,
  COUNT(CASE WHEN Absolute_Variance <= 0.01 THEN 1 END) AS Aligned_Count,
  COUNT(CASE WHEN Absolute_Variance > 0.01 THEN 1 END) AS Discrepancy_Count,
  
  ROUND(
    COUNT(CASE WHEN Absolute_Variance <= 0.01 THEN 1 END) / COUNT(*) * 100, 2
  ) AS Alignment_Rate_Percent,
  
  ROUND(SUM(Absolute_Variance), 2) AS Total_Variance_Sum,
  ROUND(AVG(Absolute_Variance), 2) AS Avg_Variance,
  MIN(Absolute_Variance) AS Min_Variance,
  MAX(Absolute_Variance) AS Max_Variance,
  
  -- Distribution by severity
  COUNT(CASE WHEN Variance_Severity = 'ALIGNED' THEN 1 END) AS Aligned,
  COUNT(CASE WHEN Variance_Severity = 'MINOR' THEN 1 END) AS Minor_Issues,
  COUNT(CASE WHEN Variance_Severity = 'MODERATE' THEN 1 END) AS Moderate_Issues,
  COUNT(CASE WHEN Variance_Severity = 'MAJOR' THEN 1 END) AS Major_Issues,
  
  -- Financial Impact
  ROUND(SUM(CASE WHEN Variance_Severity = 'MAJOR' THEN Absolute_Variance ELSE 0 END), 2) AS Financial_Impact_Major

FROM Premium_Variance;

-- Expected Output (April 18, 2026):
-- Total_Policies: 5000
-- Aligned_Count: 4796 (95.92%)
-- Discrepancy_Count: 204 (4.08%)
-- Total_Variance_Sum: $25,847.53
-- Avg_Variance: $5.17
-- Max_Variance: $498.75 (on major premium)
```

---

## Query 3.2: Cross-System Record Existence Validation

```sql
-- QUERY: Validate Bidirectional Record Existence
-- Purpose: Detect orphaned records in either direction
-- Frequency: Nightly
-- Owner: Data Quality Analyst II

WITH Missing_Records AS (
  -- Policies in PC but NOT in BC (shouldn't happen after 4-hour lag)
  SELECT
    'PC_Orphan' AS Orphan_Type,
    pc.PolicyNumber,
    pc.Status AS Record_Status,
    pc.CreateTime AS Created_Date,
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), pc.CreateTime, HOUR) AS Age_Hours,
    NULL AS Mismatch_Field
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` pc
  LEFT JOIN `driiiportfolio.raw_underwriting_data.bc_policy` bc
    ON pc.PolicyNumber = bc.PolicyNumber
  WHERE bc.PolicyNumber IS NULL
    AND pc.CreateTime < TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 4 HOUR)
  
  UNION ALL
  
  -- Policies in BC but NOT in PC (data corruption in PC)
  SELECT
    'BC_Orphan' AS Orphan_Type,
    bc.PolicyNumber,
    'Unknown' AS Record_Status,
    CAST(CURRENT_TIMESTAMP() AS DATE) AS Created_Date,
    999 AS Age_Hours,
    'PC_MISSING' AS Mismatch_Field
    
  FROM `driiiportfolio.raw_underwriting_data.bc_policy` bc
  LEFT JOIN `driiiportfolio.raw_underwriting_data.pc_policyperiod` pc
    ON pc.PolicyNumber = bc.PolicyNumber
  WHERE pc.PolicyNumber IS NULL
)

SELECT
  Orphan_Type,
  COUNT(*) AS Orphan_Count,
  ROUND(COUNT(*) / (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`) * 100, 2) AS Percent_of_Total,
  STRING_AGG(PolicyNumber, ', ' LIMIT 10) AS Sample_PolicyNumbers,
  MAX(Age_Hours) AS Oldest_Age_Hours,
  
  CASE 
    WHEN Orphan_Type = 'PC_Orphan' AND COUNT(*) > 0 
    THEN 'ETL Failure: BillingCenter load incomplete'
    WHEN Orphan_Type = 'BC_Orphan' AND COUNT(*) > 0 
    THEN 'Data Corruption: Escalate to DBA'
  END AS Root_Cause_Hypothesis,
  
  CASE 
    WHEN COUNT(*) = 0 THEN 'PASS (No orphans detected)'
    WHEN COUNT(*) <= 5 THEN 'CAUTION (Minor orphan count)'
    WHEN COUNT(*) > 5 THEN 'ALERT (Significant orphan count)'
  END AS Severity

FROM Missing_Records
GROUP BY Orphan_Type
ORDER BY Percent_of_Total DESC;
```

---

---

# Dimension 4: Timeliness Profiling

**Definition:** Data available when needed; reflects current operational status.  
**Metric:** Data load lag (hours)  
**Target:** < 4 hours

---

## Query 4.1: ETL Batch Performance Monitoring

```sql
-- QUERY: ETL Job Execution History & Performance Metrics
-- Purpose: Track data pipeline timing and identify delays
-- Frequency: Real-time monitoring (every 30 min)
-- Owner: Data Quality Analyst II

WITH ETL_Performance AS (
  SELECT
    job_name,
    job_date,
    CAST(job_start_time AS TIME) AS Start_Time,
    CAST(job_end_time AS TIME) AS End_Time,
    TIMESTAMP_DIFF(job_end_time, job_start_time, SECOND) AS Duration_Seconds,
    ROUND(TIMESTAMP_DIFF(job_end_time, job_start_time, SECOND) / 60.0, 2) AS Duration_Minutes,
    
    -- Source record count
    source_record_count,
    
    -- Target record count
    target_record_count,
    
    -- Variance
    source_record_count - target_record_count AS Record_Count_Delta,
    ROUND(ABS(source_record_count - target_record_count) / source_record_count * 100, 2) AS Record_Count_Variance_Percent,
    
    -- Job status
    job_status,
    
    -- Error details (if failed)
    error_message,
    
    -- Load lag calculation (time from job end to data available for queries)
    TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), job_end_time, HOUR) AS Hours_Since_Completion,
    
    -- Performance assessment
    CASE 
      WHEN job_status = 'FAILED' THEN 'RED (Job failed)'
      WHEN TIMESTAMP_DIFF(job_end_time, job_start_time, SECOND) > 3600 THEN 'YELLOW (Slow: >1 hour)'
      WHEN Record_Count_Variance_Percent > 5 THEN 'YELLOW (Data loss >5%)'
      WHEN ABS(source_record_count - target_record_count) > 0 THEN 'YELLOW (Record mismatch)'
      ELSE 'GREEN (Healthy)'
    END AS Health_Status,
    
    -- Trend (compare to 7-day average)
    ROUND(
      TIMESTAMP_DIFF(job_end_time, job_start_time, SECOND) / 
      AVG(TIMESTAMP_DIFF(job_end_time, job_start_time, SECOND)) 
        OVER (PARTITION BY job_name ORDER BY job_date ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING), 2
    ) AS Trend_vs_7DayAvg
    
  FROM `driiiportfolio.metadata.etl_job_log`
  WHERE job_date >= CURRENT_DATE() - 7
)

SELECT
  job_name,
  job_date,
  Start_Time,
  End_Time,
  Duration_Minutes,
  source_record_count,
  target_record_count,
  Record_Count_Delta,
  Record_Count_Variance_Percent,
  job_status,
  Health_Status,
  Hours_Since_Completion,
  
  CASE 
    WHEN Hours_Since_Completion < 1 THEN 'FRESH (< 1 hour old)'
    WHEN Hours_Since_Completion < 4 THEN 'CURRENT (< 4 hours old)'
    WHEN Hours_Since_Completion < 24 THEN 'RECENT (< 24 hours old)'
    ELSE 'STALE (> 24 hours old)'
  END AS Data_Freshness,
  
  Trend_vs_7DayAvg

FROM ETL_Performance
ORDER BY job_date DESC, job_name;

-- Expected Output (April 18, 2026 8:00 AM):
-- ┌──────────────┬────────────┬────────┬──────────┐
-- │job_name      │job_date    │Minutes │Status    │
-- ├──────────────┼────────────┼────────┼──────────┤
-- │DQ_Batch_LL   │2026-04-18  │42.5    │GREEN     │
-- │Informatica   │2026-04-18  │38.3    │GREEN     │
-- │BigQuery_Load │2026-04-18  │15.2    │GREEN     │
-- └──────────────┴────────────┴────────┴──────────┘

-- Query identifies: Data loaded 2.5 hours after batch start; within 4-hour SLA ✓
```

---

## Query 4.2: Real-Time Data Freshness Dashboard

```sql
-- QUERY: Current Data Availability & Freshness
-- Purpose: Show how fresh data is in each system
-- Frequency: Real-time (every 15 minutes)
-- Owner: Data Quality Analyst II

SELECT
  'PolicyCenter' AS System_Name,
  COUNT(*) AS Total_Records,
  MAX(UpdateTime) AS Most_Recent_Update,
  TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), MINUTE) AS Minutes_Since_Last_Update,
  TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) AS Hours_Since_Last_Update,
  
  CASE 
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 1 THEN '🟢 FRESH'
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 4 THEN '🟡 OK'
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 24 THEN '🟠 AGING'
    ELSE '🔴 STALE'
  END AS Freshness_Status,
  
  CASE 
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 4 THEN 'PASS'
    ELSE 'FAIL'
  END AS SLA_Status

FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`

UNION ALL

SELECT
  'BillingCenter' AS System_Name,
  COUNT(*) AS Total_Records,
  MAX(UpdateTime) AS Most_Recent_Update,
  TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), MINUTE) AS Minutes_Since_Last_Update,
  TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) AS Hours_Since_Last_Update,
  
  CASE 
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 1 THEN '🟢 FRESH'
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 4 THEN '🟡 OK'
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 24 THEN '🟠 AGING'
    ELSE '🔴 STALE'
  END AS Freshness_Status,
  
  CASE 
    WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(UpdateTime), HOUR) < 4 THEN 'PASS'
    ELSE 'FAIL'
  END AS SLA_Status

FROM `driiiportfolio.raw_underwriting_data.bc_policy`

UNION ALL

SELECT
  'BigQuery (Cleansed Views)' AS System_Name,
  COUNT(*) AS Total_Records,
  MAX(CURRENT_TIMESTAMP()) AS Most_Recent_Update,  -- Views updated in real-time
  0 AS Minutes_Since_Last_Update,
  0 AS Hours_Since_Last_Update,
  '🟢 FRESH' AS Freshness_Status,
  'PASS' AS SLA_Status

FROM `driiiportfolio.raw_underwriting_data.vw_pc_policyperiod_cleansed`;
```

---

---

# Dimensions 5 & 6: Validity & Integrity Profiling

**Validity:** Data values conform to format/type/domain requirements  
**Integrity:** No orphaned/disconnected records; referential integrity maintained

---

## Query 5.1: Validity Score - Format Compliance

```sql
-- QUERY: Format Validation Across All Text Fields
-- Purpose: Identify format violations (VIN, ZIP, Phone, etc.)
-- Frequency: Daily
-- Owner: Data Quality Analyst II

WITH Format_Validation AS (
  SELECT
    'VIN' AS Format_Name,
    'Vehicle Identification Number' AS Description,
    COUNT(*) AS Total_Records,
    
    -- Valid VINs (exactly 17 alphanumeric, no special chars)
    COUNT(CASE WHEN LENGTH(VIN) = 17 
               AND NOT REGEXP_CONTAINS(VIN, r'[^a-zA-Z0-9]')
               AND NOT REGEXP_CONTAINS(VIN, r'[0IOQ]')
          THEN 1 END) AS Valid_Count,
    
    -- Invalid reasons
    COUNT(CASE WHEN LENGTH(VIN) != 17 THEN 1 END) AS Invalid_Length,
    COUNT(CASE WHEN REGEXP_CONTAINS(VIN, r'[^a-zA-Z0-9]') THEN 1 END) AS Invalid_Characters,
    COUNT(CASE WHEN REGEXP_CONTAINS(VIN, r'[0IOQ]') THEN 1 END) AS Prohibited_Chars,
    COUNT(CASE WHEN VIN IS NULL THEN 1 END) AS Null_Count,
    
    ROUND(
      COUNT(CASE WHEN LENGTH(VIN) = 17 
                 AND NOT REGEXP_CONTAINS(VIN, r'[^a-zA-Z0-9]')
                 AND NOT REGEXP_CONTAINS(VIN, r'[0IOQ]')
            THEN 1 END) / COUNT(*) * 100, 2
    ) AS Validity_Percent
    
  FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`
  
  UNION ALL
  
  SELECT
    'ZIP Code' AS Format_Name,
    'Postal ZIP Code (5-digit)' AS Description,
    COUNT(*) AS Total_Records,
    
    COUNT(CASE WHEN REGEXP_CONTAINS(ZipCode, r'^[0-9]{5}$') 
          THEN 1 END) AS Valid_Count,
    
    COUNT(CASE WHEN LENGTH(ZipCode) != 5 THEN 1 END) AS Invalid_Length,
    COUNT(CASE WHEN NOT REGEXP_CONTAINS(ZipCode, r'^[0-9]*$') THEN 1 END) AS Invalid_Characters,
    0 AS Prohibited_Chars,
    COUNT(CASE WHEN ZipCode IS NULL THEN 1 END) AS Null_Count,
    
    ROUND(
      COUNT(CASE WHEN REGEXP_CONTAINS(ZipCode, r'^[0-9]{5}$') THEN 1 END) 
      / COUNT(*) * 100, 2
    ) AS Validity_Percent
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`
  
  UNION ALL
  
  SELECT
    'Phone' AS Format_Name,
    'Phone Number (10 digits)' AS Description,
    COUNT(*) AS Total_Records,
    
    COUNT(CASE WHEN REGEXP_CONTAINS(REPLACE(PhoneNumber, '-', ''), r'^[0-9]{10}$') 
          THEN 1 END) AS Valid_Count,
    
    COUNT(CASE WHEN LENGTH(REPLACE(PhoneNumber, '-', '')) != 10 THEN 1 END) AS Invalid_Length,
    COUNT(CASE WHEN NOT REGEXP_CONTAINS(REPLACE(PhoneNumber, '-', ''), r'^[0-9]*$') THEN 1 END) AS Invalid_Characters,
    0 AS Prohibited_Chars,
    COUNT(CASE WHEN PhoneNumber IS NULL THEN 1 END) AS Null_Count,
    
    ROUND(
      COUNT(CASE WHEN REGEXP_CONTAINS(REPLACE(PhoneNumber, '-', ''), r'^[0-9]{10}$') 
            THEN 1 END) / COUNT(*) * 100, 2
    ) AS Validity_Percent
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
)

SELECT *
FROM Format_Validation
ORDER BY Validity_Percent ASC;

-- Expected Output:
-- ┌──────────┬──────────┬────────┬────────┐
-- │Format    │Valid     │Invalid │Percent │
-- ├──────────┼──────────┼────────┼────────┤
-- │VIN       │3456      │344     │90.95%  │
-- │ZIP Code  │7450      │50      │99.33%  │
-- │Phone     │4950      │50      │99.00%  │
-- └──────────┴──────────┴────────┴────────┘
```

---

## Query 6.1: Integrity Assessment - Referential Integrity

```sql
-- QUERY: Orphan Record Detection & Integrity Score
-- Purpose: Verify all child records have valid parents
-- Frequency: Nightly
-- Owner: Data Quality Analyst II

WITH Integrity_Check AS (
  SELECT
    'pc_policylocation → pc_policyperiod' AS Relationship,
    COUNT(*) AS Total_Child_Records,
    
    -- Valid parent relationships
    COUNT(CASE WHEN p.ID IS NOT NULL THEN 1 END) AS With_Valid_Parent,
    
    -- Orphaned records (parent not found)
    COUNT(CASE WHEN p.ID IS NULL THEN 1 END) AS Orphaned_Records,
    
    ROUND(
      COUNT(CASE WHEN p.ID IS NOT NULL THEN 1 END) / COUNT(*) * 100, 2
    ) AS Integrity_Percent,
    
    -- Severity assessment
    CASE 
      WHEN COUNT(CASE WHEN p.ID IS NULL THEN 1 END) = 0 THEN 'PASS (No orphans)'
      WHEN COUNT(CASE WHEN p.ID IS NULL THEN 1 END) <= 5 THEN 'CAUTION (Minor orphans)'
      ELSE 'FAIL (Significant orphans detected)'
    END AS Severity
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` l
  LEFT JOIN `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
    ON l.BranchID = p.ID
    
  UNION ALL
  
  SELECT
    'pc_policyperiod → Agent_Master' AS Relationship,
    COUNT(*) AS Total_Child_Records,
    COUNT(CASE WHEN a.AgentID IS NOT NULL THEN 1 END) AS With_Valid_Parent,
    COUNT(CASE WHEN a.AgentID IS NULL THEN 1 END) AS Orphaned_Records,
    
    ROUND(
      COUNT(CASE WHEN a.AgentID IS NOT NULL THEN 1 END) / COUNT(*) * 100, 2
    ) AS Integrity_Percent,
    
    CASE 
      WHEN COUNT(CASE WHEN a.AgentID IS NULL THEN 1 END) = 0 THEN 'PASS'
      ELSE 'FAIL'
    END AS Severity
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
  LEFT JOIN `driiiportfolio.raw_underwriting_data.Agent_Master` a
    ON p.AgentID = a.AgentID
)

SELECT *
FROM Integrity_Check
ORDER BY Integrity_Percent ASC;

-- Expected Output (April 18, 2026):
-- ┌───────────┬───────┬────────┬──────────┐
-- │Relationship           │Orphans │Integrity│
-- ├───────────┼───────┼────────┼──────────┤
-- │Location→Policy        │20      │99.73%   │
-- │Policy→Agent           │0       │100.00%  │
-- └───────────┴───────┴────────┴──────────┘
```

---

---

# Advanced Aggregate Profiling

---

## Query 7.1: Multi-Dimensional Aggregate Profile

```sql
-- QUERY: Comprehensive Aggregate Profile (All Key Metrics at Once)
-- Purpose: Single query for operational dashboard
-- Frequency: Daily (6:00 AM)
-- Owner: Data Quality Analyst II

SELECT
  CURRENT_DATE() AS Report_Date,
  'Aggregate Profile' AS Report_Type,
  
  -- TABLE METRICS
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`) AS PC_PolicyPeriod_Count,
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`) AS PC_Location_Count,
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`) AS PC_Vehicle_Count,
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.bc_policy`) AS BC_Policy_Count,
  
  -- RECORD CATEGORIZATION
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` WHERE Status = 'Active') AS Active_Policies,
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` WHERE Status = 'Canceled') AS Canceled_Policies,
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` WHERE Status = 'NonRenewed') AS NonRenewed_Policies,
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` WHERE Status = 'Declined') AS Declined_Policies,
  
  -- HB 2067 COMPLIANCE METRICS
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` 
   WHERE Status IN ('Canceled', 'NonRenewed', 'Declined')
   AND CancellationReasonCode IS NOT NULL) AS Policies_With_Reason_Code,
  
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` 
   WHERE Status IN ('Canceled', 'NonRenewed', 'Declined')
   AND CancellationReasonCode IS NULL) AS Policies_Missing_Reason_Code,
  
  -- FINANCIAL METRICS
  (SELECT ROUND(SUM(TotalPremium), 2) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`) AS Total_Premium_PC,
  (SELECT ROUND(SUM(TotalPremium), 2) FROM `driiiportfolio.raw_underwriting_data.bc_policy`) AS Total_Premium_BC,
  
  -- GEOGRAPHIC METRICS
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` 
   WHERE County IN ('Harris', 'Galveston', 'Nueces', 'Cameron')) AS Coastal_Locations,
  
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` 
   WHERE County IN ('Harris', 'Galveston', 'Nueces', 'Cameron')
   AND (Latitude IS NULL OR Longitude IS NULL)) AS Coastal_Missing_Geocodes,
  
  -- DATA QUALITY VIOLATION COUNTS (from AIL)
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
   WHERE Rule_Category = 'HB 2067 Compliance'
   AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS Violations_HB2067,
  
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
   WHERE Rule_Category = 'Referential Integrity'
   AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS Violations_Orphans,
  
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
   WHERE Rule_Category = 'Data Standards'
   AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS Violations_Format,
  
  (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
   WHERE Rule_Category = 'System Alignment'
   AND Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) AS Violations_Financial,
  
  -- CALCULATED HEALTH METRICS
  ROUND(
    (1 - ((SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
           WHERE Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)) 
    / ((SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`) +
       (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`) +
       (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`)))) * 100, 2
  ) AS Overall_Health_Percent;

-- Single-row output with all key metrics for dashboard display
```

---

---

# Temporal & Trend Analysis

---

## Query 8.1: 7-Day Quality Trend Analysis

```sql
-- QUERY: Data Quality Trends Over 7-Day Rolling Window
-- Purpose: Identify improving/degrading trends
-- Frequency: Daily
-- Owner: Data Quality Analyst II

WITH Daily_Metrics AS (
  SELECT
    CAST(Detection_Timestamp AS DATE) AS Report_Date,
    Rule_Category,
    COUNT(*) AS Violation_Count,
    
    -- Calculate 7-day rolling average
    AVG(COUNT(*)) OVER (
      PARTITION BY Rule_Category 
      ORDER BY CAST(Detection_Timestamp AS DATE) 
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS Rolling_7Day_Avg,
    
    -- Calculate variance from average
    COUNT(*) - AVG(COUNT(*)) OVER (
      PARTITION BY Rule_Category 
      ORDER BY CAST(Detection_Timestamp AS DATE) 
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS Variance_From_Avg,
    
    -- Trend indicator
    CASE 
      WHEN COUNT(*) < AVG(COUNT(*)) OVER (
             PARTITION BY Rule_Category 
             ORDER BY CAST(Detection_Timestamp AS DATE) 
             ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) THEN '↓ IMPROVING'
      WHEN COUNT(*) > AVG(COUNT(*)) OVER (
             PARTITION BY Rule_Category 
             ORDER BY CAST(Detection_Timestamp AS DATE) 
             ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) THEN '↑ DEGRADING'
      ELSE '→ STABLE'
    END AS Trend
    
  FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
  WHERE Detection_Timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  GROUP BY Report_Date, Rule_Category
)

SELECT
  Report_Date,
  Rule_Category,
  Violation_Count,
  ROUND(Rolling_7Day_Avg, 1) AS Rolling_7Day_Avg,
  Trend

FROM Daily_Metrics
ORDER BY Report_Date DESC, Rule_Category;

-- Expected Output (April 12-18, 2026):
-- ┌──────────────┬──────────────┬───────┬─────────┐
-- │Report_Date   │Rule_Category │Count  │Trend    │
-- ├──────────────┼──────────────┼───────┼─────────┤
-- │2026-04-18    │HB 2067       │140    │→ STABLE │
-- │2026-04-18    │Geo Model     │594    │→ STABLE │
-- │2026-04-17    │HB 2067       │140    │→ STABLE │
-- │2026-04-17    │Geo Model     │594    │→ STABLE │
-- └──────────────┴──────────────┴───────┴─────────┘

-- Interpretation: Both categories stable; no improvement/degradation over 7 days
```

---

---

# Segment-Based Analytics

---

## Query 9.1: Quality by Geographic Segment

```sql
-- QUERY: Data Quality Metrics by County/Geographic Segment
-- Purpose: Identify geographic hotspots for issues
-- Frequency: Weekly
-- Owner: Data Quality Analyst II

SELECT
  l.County,
  COUNT(*) AS Total_Locations,
  COUNT(CASE WHEN l.Latitude IS NOT NULL AND l.Longitude IS NOT NULL THEN 1 END) AS Geocoded_Count,
  ROUND(COUNT(CASE WHEN l.Latitude IS NOT NULL AND l.Longitude IS NOT NULL THEN 1 END) 
        / COUNT(*) * 100, 2) AS Geocoding_Percent,
  
  -- Coastal risk flag
  CASE 
    WHEN l.County IN ('Harris', 'Galveston', 'Nueces', 'Cameron') THEN 'COASTAL'
    ELSE 'INLAND'
  END AS Risk_Zone,
  
  -- Premium metrics
  ROUND(SUM(p.TotalPremium), 2) AS Total_Premium,
  ROUND(AVG(p.TotalPremium), 2) AS Avg_Premium_Per_Location,
  
  -- Cancellation metrics
  COUNT(CASE WHEN p.Status = 'Canceled' THEN 1 END) AS Canceled_Count,
  ROUND(COUNT(CASE WHEN p.Status = 'Canceled' THEN 1 END) / COUNT(*) * 100, 2) AS Cancellation_Rate_Percent,
  
  -- HB 2067 compliance by county
  COUNT(CASE WHEN p.Status IN ('Canceled', 'NonRenewed', 'Declined')
              AND p.CancellationReasonCode IS NOT NULL THEN 1 END) AS Canceled_With_Reason,
  COUNT(CASE WHEN p.Status IN ('Canceled', 'NonRenewed', 'Declined')
              AND p.CancellationReasonCode IS NULL THEN 1 END) AS Canceled_Missing_Reason,
  
  CASE 
    WHEN COUNT(CASE WHEN p.Status IN ('Canceled', 'NonRenewed', 'Declined')
                     AND p.CancellationReasonCode IS NULL THEN 1 END) = 0 
    THEN 'COMPLIANT'
    ELSE 'NON-COMPLIANT'
  END AS HB2067_Compliance_Status

FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` l
JOIN `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
  ON l.BranchID = p.ID
GROUP BY l.County
ORDER BY Risk_Zone DESC, Total_Locations DESC;

-- Expected Output:
-- ┌────────────┬─────────┬───────┬──────────┬──────────┐
-- │County      │Locations│Geocoded│Premium   │Compliance│
-- ├────────────┼─────────┼───────┼──────────┼──────────┤
-- │Harris      │580      │340    │58.62%    │COMPLIANT │
-- │Galveston   │420      │210    │50.00%    │NON-COMPL.│
-- │Dallas      │1200     │1200   │100.00%   │COMPLIANT │
-- └────────────┴─────────┴───────┴──────────┴──────────┘
```

---

---

# Anomaly Detection Queries

---

## Query 10.1: Statistical Anomaly Detection

```sql
-- QUERY: Identify Anomalous Records Using Statistical Methods
-- Purpose: Flag outliers and unusual patterns
-- Frequency: Weekly
-- Owner: Data Quality Analyst II

WITH Premium_Stats AS (
  SELECT
    ROUND(AVG(TotalPremium), 2) AS Mean_Premium,
    ROUND(STDDEV_POP(TotalPremium), 2) AS StdDev_Premium,
    MIN(TotalPremium) AS Min_Premium,
    MAX(TotalPremium) AS Max_Premium,
    COUNT(*) AS Record_Count
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`
  WHERE Status = 'Active'
),

Anomalies AS (
  SELECT
    p.PolicyNumber,
    p.TotalPremium,
    (p.TotalPremium - ps.Mean_Premium) / ps.StdDev_Premium AS Z_Score,
    
    CASE 
      WHEN ABS((p.TotalPremium - ps.Mean_Premium) / ps.StdDev_Premium) > 3 THEN 'EXTREME (3σ+)'
      WHEN ABS((p.TotalPremium - ps.Mean_Premium) / ps.StdDev_Premium) > 2 THEN 'OUTLIER (2σ+)'
      ELSE 'NORMAL'
    END AS Anomaly_Level,
    
    ps.Mean_Premium,
    ps.StdDev_Premium,
    ROUND(p.TotalPremium - ps.Mean_Premium, 2) AS Deviation_From_Mean,
    CASE 
      WHEN p.TotalPremium < 100 THEN 'POSSIBLE ERROR (< $100)'
      WHEN p.TotalPremium > 500000 THEN 'POSSIBLE ERROR (> $500K)'
      WHEN p.TotalPremium > (ps.Mean_Premium + 3 * ps.StdDev_Premium) THEN 'INVESTIGATE'
      WHEN p.TotalPremium < (ps.Mean_Premium - 3 * ps.StdDev_Premium) THEN 'INVESTIGATE'
      ELSE 'NORMAL'
    END AS Action_Required
    
  FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
  CROSS JOIN Premium_Stats ps
  WHERE p.Status = 'Active'
    AND (ABS((p.TotalPremium - ps.Mean_Premium) / ps.StdDev_Premium) > 2
      OR p.TotalPremium < 100
      OR p.TotalPremium > 500000)
)

SELECT *
FROM Anomalies
ORDER BY Z_Score DESC;

-- Expected Output:
-- ┌──────────┬──────────┬────────┬──────────┐
-- │PolicyNum │Premium   │Z_Score │Anomaly   │
-- ├──────────┼──────────┼────────┼──────────┤
-- │POL-99    │$850,000  │8.32    │EXTREME   │
-- │POL-88    │$15       │-2.45   │OUTLIER   │
-- └──────────┴──────────┴────────┴──────────┘

-- Analysis: Policy POL-99 is 8.32 standard deviations above mean (investigate for data entry error)
```

---

---

# Dashboard Foundation Queries

---

## Query 11.1: Real-Time KPI Dashboard Foundation

```sql
-- QUERY: Single Query to Power Executive Dashboard
-- Purpose: All KPIs in one optimized query (materialized nightly)
-- Frequency: Daily (6:00 AM refresh)
-- Owner: Data Quality Analyst II
-- Output: Power BI / Tableau data source

WITH Baseline AS (
  SELECT
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod`) AS total_policies,
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`) AS total_locations,
    (SELECT COUNT(*) FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`) AS total_vehicles
),

Issues AS (
  SELECT
    COUNT(*) AS total_violations,
    SUM(CASE WHEN Severity = 'CRITICAL' THEN 1 ELSE 0 END) AS critical_count,
    SUM(CASE WHEN Severity = 'HIGH' THEN 1 ELSE 0 END) AS high_count,
    SUM(CASE WHEN Rule_Category = 'HB 2067 Compliance' THEN 1 ELSE 0 END) AS hb2067_violations,
    SUM(CASE WHEN Rule_Category = 'Referential Integrity' THEN 1 ELSE 0 END) AS orphan_violations,
    SUM(CASE WHEN Rule_Category = 'Catastrophe Modeling' THEN 1 ELSE 0 END) AS geocoding_violations,
    SUM(CASE WHEN Rule_Category = 'Data Standards' THEN 1 ELSE 0 END) AS format_violations,
    SUM(CASE WHEN Rule_Category = 'System Alignment' THEN 1 ELSE 0 END) AS financial_violations
  FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
  WHERE Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)
)

SELECT
  CURRENT_TIMESTAMP() AS Report_Timestamp,
  CURRENT_DATE() AS Report_Date,
  
  -- Record Counts
  b.total_policies,
  b.total_locations,
  b.total_vehicles,
  (b.total_policies + b.total_locations + b.total_vehicles) AS total_records,
  
  -- Violation Summary
  i.total_violations,
  i.critical_count,
  i.high_count,
  i.hb2067_violations,
  i.orphan_violations,
  i.geocoding_violations,
  i.format_violations,
  i.financial_violations,
  
  -- Six Dimensions (Calculated)
  ROUND((1 - (i.hb2067_violations + i.geocoding_violations + i.format_violations + i.financial_violations) 
         / (b.total_policies + b.total_locations + b.total_vehicles)) * 100, 2) AS accuracy_percent,
  
  ROUND((1 - (i.hb2067_violations / NULLIF(b.total_policies, 0))) * 100, 2) AS completeness_percent,
  
  ROUND((1 - (i.financial_violations / NULLIF(b.total_policies, 0))) * 100, 2) AS consistency_percent,
  
  CASE WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), 
                           (SELECT MAX(load_completion_time) FROM `driiiportfolio.metadata.etl_job_log`), 
                           HOUR) < 4 THEN 100 ELSE 50 END AS timeliness_score,
  
  ROUND((1 - (i.format_violations / NULLIF(b.total_vehicles, 0))) * 100, 2) AS validity_percent,
  
  ROUND((1 - (i.orphan_violations / NULLIF(b.total_locations, 0))) * 100, 2) AS integrity_percent,
  
  -- Overall Score (20% each Accuracy, Completeness, Consistency; 15% Timeliness, Validity; 10% Integrity)
  ROUND(
    (0.20 * ROUND((1 - (i.hb2067_violations + i.geocoding_violations + i.format_violations + i.financial_violations) 
                   / (b.total_policies + b.total_locations + b.total_vehicles)) * 100, 2) +
     0.20 * ROUND((1 - (i.hb2067_violations / NULLIF(b.total_policies, 0))) * 100, 2) +
     0.20 * ROUND((1 - (i.financial_violations / NULLIF(b.total_policies, 0))) * 100, 2) +
     0.15 * CASE WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), 
                        (SELECT MAX(load_completion_time) FROM `driiiportfolio.metadata.etl_job_log`), 
                        HOUR) < 4 THEN 100 ELSE 50 END +
     0.15 * ROUND((1 - (i.format_violations / NULLIF(b.total_vehicles, 0))) * 100, 2) +
     0.10 * ROUND((1 - (i.orphan_violations / NULLIF(b.total_locations, 0))) * 100, 2)
    ), 2
  ) AS overall_dq_score,
  
  -- Status Indicators
  CASE 
    WHEN ROUND(
      (0.20 * ROUND((1 - (i.hb2067_violations + i.geocoding_violations + i.format_violations + i.financial_violations) 
                     / (b.total_policies + b.total_locations + b.total_vehicles)) * 100, 2) +
       0.20 * ROUND((1 - (i.hb2067_violations / NULLIF(b.total_policies, 0))) * 100, 2) +
       0.20 * ROUND((1 - (i.financial_violations / NULLIF(b.total_policies, 0))) * 100, 2) +
       0.15 * CASE WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), 
                            (SELECT MAX(load_completion_time) FROM `driiiportfolio.metadata.etl_job_log`), 
                            HOUR) < 4 THEN 100 ELSE 50 END +
       0.15 * ROUND((1 - (i.format_violations / NULLIF(b.total_vehicles, 0))) * 100, 2) +
       0.10 * ROUND((1 - (i.orphan_violations / NULLIF(b.total_locations, 0))) * 100, 2)
      ), 2) >= 99.0 THEN '🟢 EXCELLENT'
    WHEN ROUND(
      (0.20 * ROUND((1 - (i.hb2067_violations + i.geocoding_violations + i.format_violations + i.financial_violations) 
                     / (b.total_policies + b.total_locations + b.total_vehicles)) * 100, 2) +
       0.20 * ROUND((1 - (i.hb2067_violations / NULLIF(b.total_policies, 0))) * 100, 2) +
       0.20 * ROUND((1 - (i.financial_violations / NULLIF(b.total_policies, 0))) * 100, 2) +
       0.15 * CASE WHEN TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), 
                            (SELECT MAX(load_completion_time) FROM `driiiportfolio.metadata.etl_job_log`), 
                            HOUR) < 4 THEN 100 ELSE 50 END +
       0.15 * ROUND((1 - (i.format_violations / NULLIF(b.total_vehicles, 0))) * 100, 2) +
       0.10 * ROUND((1 - (i.orphan_violations / NULLIF(b.total_locations, 0))) * 100, 2)
      ), 2) >= 95.0 THEN '🟡 GOOD'
    ELSE '🔴 FAILING'
  END AS health_status

FROM Baseline b
CROSS JOIN Issues i;

-- Output: Single Row with 30+ KPI columns ready for dashboard
-- Refresh: Nightly at 6:00 AM (scheduled query in BigQuery)
-- Usage: Power BI dataset query directly references this
```

---

---

## Document Control

| Element | Value |
|---------|-------|
| **Document ID** | DOC_08_Extended_Profiling_KPI_Queries |
| **Version** | 1.0 |
| **Date Created** | April 18, 2026 |
| **Owner** | Data Quality Analyst II |
| **Query Language** | BigQuery (SQL); SQL Server equivalents noted |
| **Total Queries** | 15 comprehensive profiling queries |
| **Maintenance** | Update as new data dimensions introduced |
| **Review Cycle** | Quarterly (optimize slow queries; add new dimensions) |

---

**For query execution or optimization support, contact the Data Quality Analyst II.**