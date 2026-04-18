--The Automated Issues Log (AIL) View
CREATE OR REPLACE VIEW `driiiportfolio.raw_underwriting_data.vw_automated_issues_log` AS

-- Rule 1: HB 2067 Statutory Compliance (Mandatory Fields/Value Constraints)
-- Target: pc_policyperiod
SELECT 
    'SOP-3.1' as Requirement_ID,
    'CRITICAL' as Severity,
    'HB 2067 Compliance' as Rule_Category,
    PolicyNumber as Primary_Key,
    'CancellationReasonCode' as Failing_Field,
    CASE 
        WHEN Status = 'Canceled' AND CancellationReasonCode IS NULL THEN 'Missing Cancellation Reason'
        ELSE 'Unmapped/Invalid TDI Reason Code'
    END as Issue_Description,
    CURRENT_TIMESTAMP() as Detection_Timestamp
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
LEFT JOIN `driiiportfolio.raw_underwriting_data.TDI_Reason_Mapping` t
  ON p.CancellationReasonCode = t.InternalCode
WHERE (p.Status = 'Canceled' AND p.CancellationReasonCode IS NULL)
   OR (p.Status = 'Canceled' AND p.CancellationReasonCode IS NOT NULL AND t.InternalCode IS NULL)

UNION ALL

-- Rule 2: Geocoding Accuracy (Logical Checks/Value Constraints)
-- Target: pc_policylocation
SELECT 
    'SOP-3.2' as Requirement_ID,
    'HIGH' as Severity,
    'Catastrophe Modeling' as Rule_Category,
    Location_ID as Primary_Key,
    'Latitude/Longitude' as Failing_Field,
    'Missing Coordinates in Coastal Risk County: ' || County as Issue_Description,
    CURRENT_TIMESTAMP() as Detection_Timestamp
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation`
WHERE County IN ('Harris', 'Galveston', 'Nueces', 'Cameron')
  AND (Latitude IS NULL OR Longitude IS NULL)

UNION ALL

-- Rule 3: Referential Integrity (Orphan Risks)
-- Target: pc_policylocation -> pc_policyperiod
SELECT 
    'SOP-3.3' as Requirement_ID,
    'CRITICAL' as Severity,
    'Referential Integrity' as Rule_Category,
    l.Location_ID as Primary_Key,
    'BranchID' as Failing_Field,
    'Orphan Location: BranchID not found in Policy table' as Issue_Description,
    CURRENT_TIMESTAMP() as Detection_Timestamp
FROM `driiiportfolio.raw_underwriting_data.pc_policylocation` l
LEFT JOIN `driiiportfolio.raw_underwriting_data.pc_policyperiod` p
  ON l.BranchID = p.ID
WHERE p.ID IS NULL

UNION ALL

-- Rule 4: Data Normalization (Format Standards - Regex)
-- Target: pc_vehicle
SELECT 
    'SOP-3.4' as Requirement_ID,
    'WARNING' as Severity,
    'Data Standards' as Rule_Category,
    PolicyNumber as Primary_Key,
    'VIN' as Failing_Field,
    'Invalid VIN Format: Incorrect length or illegal characters' as Issue_Description,
    CURRENT_TIMESTAMP() as Detection_Timestamp
FROM `driiiportfolio.raw_underwriting_data.pc_vehicle`
WHERE LENGTH(VIN) != 17 
   OR REGEXP_CONTAINS(VIN, r'[^a-zA-Z0-9]')

UNION ALL

-- Rule 5: Cross-System Reconciliation (Financial Integrity)
-- Target: pc_policyperiod vs bc_policy
SELECT 
    'SOP-3.5' as Requirement_ID,
    'HIGH' as Severity,
    'System Alignment' as Rule_Category,
    pc.PolicyNumber as Primary_Key,
    'TotalPremium' as Failing_Field,
    'Financial Drift: Discrepancy between PolicyCenter and BillingCenter' as Issue_Description,
    CURRENT_TIMESTAMP() as Detection_Timestamp
FROM `driiiportfolio.raw_underwriting_data.pc_policyperiod` pc
JOIN `driiiportfolio.raw_underwriting_data.bc_policy` bc
  ON pc.PolicyNumber = bc.PolicyNumber
WHERE ABS(pc.TotalPremium - bc.TotalPremium) > 0.01;


--Verification
SELECT Severity, Rule_Category, COUNT(*) as Issue_Count
FROM `driiiportfolio.raw_underwriting_data.vw_automated_issues_log`
GROUP BY 1, 2
ORDER BY Issue_Count DESC;
