# Complete Standard Operating Procedures (SOPs)
## Operational Execution Framework for Data Quality Lifecycle

**Document Owner:** Data Governance Committee  
**Author:** Daniel Rodriguez III, Data Quality Analyst II  
**Date:** April 18, 2026  
**Version:** 1.0  
**Classification:** Internal – Confidential  
**Related Documents:** DOC_01 (Role Enhancement), DOC_05 (Validation Rules Registry)

---

## Table of Contents

1. [SOP 1: End-to-End Data Quality Lifecycle Management](#sop-1-end-to-end-data-quality-lifecycle-management)
2. [SOP 2: Data Profiling and Statistical Assessment](#sop-2-data-profiling-and-statistical-assessment)
3. [SOP 3: Validation Rule Execution](#sop-3-validation-rule-execution)
4. [SOP 4: Root Cause Analysis and Remediation](#sop-4-root-cause-analysis-and-remediation)
5. [SOP 5: Data Issue Management and Severity Escalation](#sop-5-data-issue-management-and-severity-escalation)
6. [SOP 6: Data Quality KPI Monitoring and Reporting](#sop-6-data-quality-kpi-monitoring-and-reporting)
7. [SOP 7: Data Governance Execution and Data Dictionary Maintenance](#sop-7-data-governance-execution-and-data-dictionary-maintenance)
8. [SOP 8: SDLC Support and Release Readiness](#sop-8-sdlc-support-and-release-readiness)
9. [Appendix A: Job Schedules & Contacts](#appendix-a-job-schedules--contacts)
10. [Appendix B: Decision Trees & Flowcharts](#appendix-b-decision-trees--flowcharts)
11. [Appendix C: Templates & Forms](#appendix-c-templates--forms)

---

---

# SOP 1: End-to-End Data Quality Lifecycle Management

**Objective:** Ensure all data ingested from source systems is fit-for-purpose and compliant with Texas Farm Bureau and TDI standards through systematic profiling, validation, issue detection, root cause analysis, and remediation.

**Scope:** Applies to all underwriting data flowing through Guidewire PolicyCenter, BillingCenter, and related systems.

**Frequency:** Continuous (real-time) with daily batch verification

**Responsibility:** Data Quality Analyst II (primary); Underwriting Operations Manager (oversight)

---

## SOP 1.1: Overview – The Four-Stage Lifecycle

The data quality lifecycle operates in four sequential stages:

```
STAGE 1: INGESTION & PROFILING
  └─ Raw data arrives from source systems
  └─ Informatica CDI captures real-time streams OR nightly batch loads
  └─ Data staged to BigQuery raw_underwriting_data schema
  └─ Initial profiling queries execute to establish baseline metrics

STAGE 2: VALIDATION RULE EXECUTION
  └─ 19 validation rules codified in SQL/CDQ/Guidewire endpoints
  └─ Rules enforce business logic and regulatory requirements
  └─ Violations flagged to vw_automated_issues_log
  └─ Acceptance threshold checked: Pass if failure rate < 1%

STAGE 3: ISSUE DETECTION & ROOT CAUSE ANALYSIS
  └─ Automated alerting triggered if violations exceed threshold
  └─ Data Quality Analyst investigates using RCA queries (SQL_05–08)
  └─ Systemic root causes identified (system bug, data entry error, integration issue)
  └─ Findings documented in RCA post-mortem template

STAGE 4: CORRECTION & REMEDIATION
  └─ Golden Layer cleansed views (DDL_01–04) provide audit-compliant fixes
  └─ Auto-remediation applied where possible (e.g., VIN standardization)
  └─ Manual remediation for business rule violations (e.g., reason codes)
  └─ Audit trail preserved; original raw data retained for compliance
```

---

## SOP 1.2: Step-by-Step Execution

### Step 1: Data Ingestion & Staging

**Trigger:** Policy event in PolicyCenter OR nightly 8:00 PM batch window

**Real-Time Path (HB 2067 critical data):**
1. Policy status change event occurs in Guidewire PolicyCenter (e.g., Canceled, NonRenewed)
2. Informatica CDI streaming capture detects change via CDC (Change Data Capture)
3. Event payload forwarded to BigQuery raw_underwriting_data schema
4. Metadata logged: Timestamp, SourceSystem, ChangeType, RecordID

**Batch Path (Nightly):**
1. BillingCenter data export runs 8:00 PM (automated)
2. Informatica batch job (`DQ_Batch_Nightly_Extract`) runs 9:00 PM
   - Extracts: pc_policyperiod, pc_policylocation, pc_vehicle, bc_policy
   - Loads to BigQuery staging tables
   - Executes: `TRUNCATE staging_*; INSERT INTO staging_* SELECT * FROM source_*;`
3. Data Quality Analyst monitors job completion (target: 10:00 PM)
   - Check Informatica Cloud console for job status
   - Verify record counts match expectations (within ±5%)
   - Alert if any job fails (retry logic: 2 auto-retries, then escalate)

**Data Validation Checkpoints:**
- Record count variance: OK if within ±5% of baseline
- NULL consistency: Flags if unexpected NULL surge (> 10% variance)
- Data types: Validates format (dates, numerics, strings)

**Duration:** Real-time (<5 sec); Batch (30–45 min for 500K records)

**Success Criteria:**
- ✓ All records loaded to staging tables
- ✓ No ETL errors or warnings in Informatica logs
- ✓ Record counts logged and compared to previous day

---

### Step 2: Baseline Profiling & Anomaly Detection

**Trigger:** Immediately after data ingestion (real-time) OR 10:15 PM (batch)

**Execution:**
1. Data Quality Analyst executes profiling query suite (SQL_01–04):
   - `SQL_01_HB2067_Compliance_Check.sql` → Counts missing/unmapped reason codes
   - `SQL_02_Referential_Integrity_Check.sql` → Counts orphaned locations
   - `SQL_03_Data_Standards_VIN_Check.sql` → Counts invalid VIN formats
   - `SQL_04_Geocoding_Completeness_Check.sql` → Counts missing coastal coordinates

2. Results compared to baseline metrics (captured 24 hrs prior):
   ```
   Baseline (April 16): 140 HB 2067 issues, 20 orphans, 344 VINs, 594 geocoding
   Current  (April 17): ??? issues
   
   Delta Analysis:
   - If ΔCount > 5%: Investigate spike (new data quality issue?)
   - If ΔCount < -5%: Verify improvement (remediation working?)
   - If ΔCount ≈ 0:  Monitor trend; routine issues
   ```

3. Profiling results documented:
   - Timestamp of execution
   - Record counts by issue type
   - Null rates by critical field
   - Distinct value counts
   - Outlier detection (e.g., premiums > $500K)

**Success Criteria:**
- ✓ Profiling queries execute without errors
- ✓ Results logged to profiling_results table with timestamp
- ✓ Anomalies identified and communicated to team

---

### Step 3: Validation Rule Execution

**Trigger:** Immediately after profiling (real-time) OR 10:45 PM (batch)

**Execution:**
1. SQL Server Agent job `DQ_Validation_Batch_Daily` executes all 19 validation rules (VR-001-001 through VR-005-001)
   - Each rule queries raw data against business logic constraints
   - Violations inserted into vw_automated_issues_log
   - Execution time: ~18 seconds for 5,000 records

2. Rule execution verification:
   ```sql
   -- Verify all rules executed successfully
   SELECT Rule_Category, COUNT(*) as Violation_Count
   FROM vw_automated_issues_log
   WHERE Detection_Timestamp >= CURRENT_TIMESTAMP - INTERVAL 1 HOUR
   GROUP BY Rule_Category
   ORDER BY Violation_Count DESC;
   ```

3. Acceptance threshold checked for each rule:
   - CRITICAL rules: Pass if failure_rate < 0% (zero tolerance)
   - HIGH rules: Pass if failure_rate < 1%
   - MEDIUM rules: Pass if failure_rate < 5%

4. Results summarized:
   ```
   ✓ PASS: VR-001-002 (Agent ID) – 0 violations (0.0%)
   🔴 FAIL: VR-001-001 (HB 2067 Reason) – 140 violations (2.8%) [EXCEEDS 0% THRESHOLD]
   🔴 FAIL: VR-003-001 (VIN Format) – 344 violations (9.05%) [EXCEEDS 5% THRESHOLD]
   ```

**Success Criteria:**
- ✓ All 19 rules executed without SQL errors
- ✓ Violation counts recorded with timestamps
- ✓ Threshold evaluation completed
- ✓ Failures requiring remediation identified

---

### Step 4: Issue Detection & Alerting

**Trigger:** Immediately after validation (if failures detected)

**Execution:**
1. Automated alerting logic evaluates violation results:
   ```
   IF (Rule = CRITICAL) AND (Violations > 0):
     → Severity = CRITICAL
     → Notify: Data Governance Committee immediately (email + Slack)
     → Action: Pause downstream processing until root cause addressed
   
   ELSE IF (Rule = HIGH) AND (Failure_Rate > 1%):
     → Severity = HIGH
     → Notify: Data Quality Analyst + Underwriting Manager (24-hour investigation)
     → Action: Proceed with processing; schedule RCA
   
   ELSE IF (Rule = MEDIUM) AND (Failure_Rate > 5%):
     → Severity = MEDIUM
     → Notify: Data Quality Analyst (best-effort investigation)
     → Action: Proceed with processing; include in weekly summary
   ```

2. Notification channels:
   - **CRITICAL:** Email (DQ Team + Leadership) + Slack #data-emergency
   - **HIGH:** Email (DQ Team + Manager) + Slack #data-quality
   - **MEDIUM:** Daily email summary

3. Automated Issues Log entry created with:
   - Requirement_ID (SOP-3.X reference)
   - Severity (CRITICAL, HIGH, MEDIUM, WARNING)
   - Rule_Category (HB 2067 Compliance, Referential Integrity, etc.)
   - Primary_Key (affected PolicyNumber)
   - Failing_Field (CancellationReasonCode, etc.)
   - Issue_Description (plain English violation description)
   - Detection_Timestamp (CURRENT_TIMESTAMP)

**Success Criteria:**
- ✓ All violations logged to Automated Issues Log
- ✓ Appropriate stakeholders notified
- ✓ Response time tracking initiated

---

### Step 5: Root Cause Analysis (RCA)

**Trigger:** CRITICAL or HIGH severity issues OR threshold exceeded

**Execution:**
1. Data Quality Analyst triggered to investigate:
   - Reviews automated issue notification
   - Filters Automated Issues Log for violations of interest
   - Launches RCA query suite (SQL_05–08) relevant to issue type:
     - HB 2067 Compliance → SQL_05_RCA_HB2067_Temporal_Spread.sql
     - Orphan Records → SQL_06_RCA_Orphan_Trace.sql
     - Geocoding Issues → SQL_07_RCA_Catastrophe_Geo_Cluster.sql
     - Financial Discrepancies → SQL_08_RCA_Financial_Premium_Drift.sql

2. RCA investigation phase:
   - **Temporal Analysis:** When did issue first appear? Is it increasing/decreasing?
   - **Pattern Analysis:** Which geographic regions, agents, or business units affected?
   - **Lineage Tracing:** At what point in pipeline did data quality degrade?
   - **System Review:** Recent changes to policy binding, ETL, or reference data?

3. Root cause hypotheses documented:
   ```
   Issue: 140 canceled policies missing cancellation reason codes
   
   Hypothesis 1: System Translation Gap
     └─ Evidence: All 82 missing codes created post-April 1, 2026 (Olos release)
     └─ Severity: HIGH – Olos changelog shows cancellation trigger changes
     └─ Action Required: Guidewire configuration fix
   
   Hypothesis 2: Legacy Data Unmapped
     └─ Evidence: 58 records with code = 'INT_99' (system placeholder)
     └─ Severity: MEDIUM – Internal codes not in TDI_Reason_Mapping
     └─ Action Required: Add mappings to reference table
   ```

4. RCA post-mortem documented (see SOP 4 for detailed RCA procedure)

**Success Criteria:**
- ✓ Root cause(s) identified with supporting evidence
- ✓ RCA report filed with recommendations
- ✓ Remediation plan developed (see Step 6)

---

### Step 6: Correction & Remediation

**Trigger:** RCA complete + root cause identified

**Execution:**
1. **For System Defects:**
   - Escalate to Guidewire support / IT for system-level fixes
   - Example: Olos release missing reason code mappings → requires configuration change
   - Timeline: 1–7 days depending on severity and vendor response

2. **For Data Entry Errors:**
   - Underwriting team corrects records in source system (PolicyCenter)
   - Example: Update CancellationReasonCode from NULL to valid code
   - Timeline: 24–48 hours

3. **For Remediation Via Golden Layer:**
   - Apply cleansed view transformation without modifying source data
   - Example: vw_pc_policyperiod_cleansed defaults unmapped codes to 'K'
   - Audit trail preserved: Original null values stored; remediation_status flag = 'REMEDIATED'
   - Timeline: Immediate (view-based, no data movement)

4. **For Reference Data Issues:**
   - Update TDI_Reason_Mapping or other reference tables
   - Example: Add new internal code to TDI code mapping
   - Timeline: 24 hours (coordinate with Data Governance Committee)

5. **Re-validation:**
   - After remediation, re-run validation rule to verify fix
   - Document before/after violation counts
   - Example:
     ```
     BEFORE: 58 unmapped reason codes
     AFTER:  0 unmapped reason codes (all added to TDI_Reason_Mapping)
     ✓ RESOLVED
     ```

**Success Criteria:**
- ✓ Remediation method documented
- ✓ Corrective action implemented
- ✓ Re-validation confirms improvement
- ✓ Issue closed with resolution timestamp

---

### Step 7: Closure & Preventive Measures

**Trigger:** Remediation verified + violation resolved

**Execution:**
1. **Document Lessons Learned:**
   - Root cause: System bug, data entry gap, integration failure?
   - Prevention: Guidewire configuration, validation endpoint, training?
   - Owner: Who is responsible for preventing recurrence?
   - Timeline: By [DATE], [OWNER] will [ACTION]

2. **Close Issue Ticket:**
   - Update Automated Issues Log with resolution
   - Status: CLOSED
   - Resolution_Method: [System Fix | Data Correction | Golden Layer | Reference Update]
   - Closure_Timestamp: CURRENT_TIMESTAMP
   - Follow_Up_Action: [Preventive measure]

3. **Communicate Resolution:**
   - Notify stakeholders of issue resolution
   - Include lessons learned and preventive measures
   - Example email:
     ```
     Subject: Data Quality Issue Resolved – HB 2067 Reason Code Mapping
     
     The 58 unmapped reason codes (VR-002-003) have been resolved:
     
     Root Cause: Internal codes not in TDI reference table
     Resolution: Added 5 new mappings to TDI_Reason_Mapping
     Preventive: Going forward, all new codes will be validated at entry
     
     Current Status: 0 violations (PASS)
     ```

**Success Criteria:**
- ✓ Issue ticket closed with documented resolution
- ✓ Stakeholders notified of resolution
- ✓ Preventive measure assigned with owner and deadline

---

---

# SOP 2: Data Profiling and Statistical Assessment

**Objective:** Establish and maintain ongoing diagnostics of data quality through profiling that identifies anomalies, trends, and shifts in data patterns.

**Scope:** Applies to all core underwriting tables (pc_policyperiod, pc_policylocation, pc_vehicle, bc_policy)

**Frequency:** Continuous (real-time dashboard) and Weekly (deep-dive analysis)

**Responsibility:** Data Quality Analyst II (execution); Data Governance Committee (stakeholder communication)

---

## SOP 2.1: Daily Profiling Process

**Time:** 6:30 AM (after overnight batch loads)

**Execution:**

1. **Launch Power BI Data Quality Dashboard:**
   - Dashboard automatically refreshes from SQL queries scheduled overnight
   - Visual KPIs displayed for each dimension:
     ```
     ACCURACY:        93.43% (6.57% error rate)
     COMPLETENESS:    97.85% (fill rate for mandatory fields)
     CONSISTENCY:     59.20% (PC vs. BC alignment)
     TIMELINESS:      98.00% (< 4 hour load lag)
     VALIDITY:        94.71% (code conformance)
     INTEGRITY:       99.60% (0 orphans / acceptable threshold)
     ```

2. **Alert Threshold Check:**
   - If any metric moves > 5% from previous day: Flag for investigation
   - If any metric falls below departmental target: Escalate
   - Trend indicator: ↑ improving, → stable, ↓ degrading

3. **Daily Scorecard Summary:**
   - Email sent to Data Governance Committee by 7:00 AM:
     ```
     DATA QUALITY SCORECARD – APRIL 18, 2026
     
     Metric              Today    Target   Status
     ────────────────────────────────────────────
     Accuracy            93.43%   99.0%    ⚠ BELOW TARGET
     Completeness        97.85%   100.0%   ⚠ BELOW TARGET
     Consistency         59.20%   100.0%   🔴 CRITICAL
     Timeliness          98.00%   100.0%   ✓ ACCEPTABLE
     Validity            94.71%   100.0%   ⚠ BELOW TARGET
     Integrity           99.60%   100.0%   ✓ ACCEPTABLE
     ────────────────────────────────────────────
     Overall Score       90.47%   99.0%    🔴 FAILING
     
     Key Changes from Yesterday:
     ├─ HB 2067 Compliance: 140 violations (↔ stable)
     ├─ Geocoding Issues: 594 violations (↔ stable)
     ├─ Financial Discrepancies: 204 violations (↔ stable)
     └─ Orphan Locations: 20 violations (↔ stable)
     
     Action Items: 3 RCA investigations in progress (see attached)
     ```

---

## SOP 2.2: Weekly Deep-Dive Analysis

**Time:** Every Monday 9:00 AM (Data Governance Committee meeting)

**Execution:**

1. **Baseline Comparison:**
   - Compare current week metrics to:
     - Previous week (trend: improving/stable/declining?)
     - Monthly average (seasonal patterns?)
     - Target (gap analysis)
   
   - Example analysis:
     ```
     HB 2067 Compliance Violations
     ─────────────────────────────
     Week 1 (Apr 8-14):  142 violations
     Week 2 (Apr 15-21): 140 violations  ← Current
     Target:             0 violations
     
     Trend: ↓ Slight improvement (2 records resolved)
     Pace to Target: At current rate (2/week), 70 weeks to compliance
     Action: ACCELERATE remediation efforts
     ```

2. **Geographic & Segment Analysis:**
   - Break metrics by agent, county, risk type
   - Identify which segments have highest quality issues
   - Example:
     ```
     Geocoding Issues by Coastal County
     ──────────────────────────────────
     Harris County:     250 missing geocodes (42%)
     Galveston County:  180 missing geocodes (30%)
     Nueces County:     100 missing geocodes (17%)
     Cameron County:    64 missing geocodes (11%)
     ──────────────────────────────────────
     Total:             594 violations
     
     Root Cause: HazardHub API timeout (regional)
     Resolution: Awaiting vendor patch
     ETA: April 20, 2026
     ```

3. **Remediation Progress Tracking:**
   - For each outstanding issue, track:
     - Original violation count
     - Current violation count
     - Remediation rate (% resolved)
     - Expected closure date
   
   - Example:
     ```
     VR-001-001: HB 2067 Reason Code Mapping
     ────────────────────────────────────────
     Original:           140 violations
     Resolved:           82 violations (58%)
     Remaining:          58 violations (42%)
     Remediation Rate:   11.6 violations/day
     ETA to Closure:     May 5, 2026 (17 days)
     ```

4. **Data Governance Committee Discussion:**
   - Present trends and remediation status
   - Discuss systemic improvements needed
   - Approve exceptions or process changes
   - Assign action items for next week

5. **Stakeholder Communication:**
   - Weekly report distributed:
     ```
     TO: Underwriting Manager, Catastrophe Management, Finance, Compliance
     FROM: Data Quality Analyst II
     SUBJECT: Weekly Data Quality Status – Week of April 15, 2026
     
     Overall Score: 90.47% (Target: 99.0%)
     Status: 🔴 FAILING
     
     [Detailed metrics and trend analysis per steps 1–3 above]
     
     Next Steps:
     1. Await HazardHub API patch for geocoding resolution (ETA: Apr 20)
     2. Follow up on Olos reason code mapping fix (Guidewire support)
     3. Accelerate VIN standardization batch processing
     
     Questions? Please contact Daniel Rodriguez, Data Quality Analyst II
     ```

---

## SOP 2.3: Profiling Query Execution & Interpretation

**Queries to Execute:**

| Query | Purpose | Frequency | Owner |
|-------|---------|-----------|-------|
| SQL_01_HB2067_Compliance_Check | Count missing/unmapped reason codes | Daily | DQ Analyst |
| SQL_02_Referential_Integrity_Check | Count orphaned locations | Daily | DQ Analyst |
| SQL_03_Data_Standards_VIN_Check | Count invalid VIN formats | Daily | DQ Analyst |
| SQL_04_Geocoding_Completeness_Check | Count missing coastal coordinates | Daily | DQ Analyst |
| SQL_09_Final_DQ_Scorecard_Metrics | 6-dimension KPI calculation | Daily | Power BI (automated) |

**Interpretation Guide:**

```
Null Rate Analysis:
  IF null_rate > 10% on mandatory field:
    → Investigate: Did data entry process break?
    → Check: Recent system changes, training gaps, agent issues?
    → Action: Pause processing until issue addressed

Distinct Value Count Anomaly:
  IF distinct_values >> expected:
    → Investigate: Are we capturing duplicates or new categories?
    → Example: CancellationReasonCode should have ~17 distinct values (TDI codes)
               If distinct_count = 45, we have unmapped internal codes
    → Action: Identify new codes; map to TDI; update reference table

Outlier Detection:
  IF premium < $100 or > $500,000:
    → Check: Promotional policies? Commercial excess? Data entry error?
    → Action: Review case-by-case; document exceptions

Temporal Patterns:
  IF violations clustered on specific date:
    → Investigate: System change deployed that day?
    → Example: 82 missing reason codes all post-April 1 → Olos release issue
    → Action: Trace to source; escalate to responsible team
```

---

---

# SOP 3: Validation Rule Execution

**Objective:** Establish proactive gates that prevent non-compliant data from reaching production systems through systematic validation rule enforcement.

**Scope:** Applies to all 19 validation rules (VR-001-001 through VR-005-001) as documented in DOC_05

**Frequency:** Real-time (critical rules), Nightly (batch rules)

**Responsibility:** Informatica/SQL administrators (rule deployment); Data Quality Analyst II (monitoring)

---

## SOP 3.1: Rule Definition & Configuration

**Step 1: Rule Creation Workflow**

When a new validation rule is needed:

1. **Business Requirement Captured:**
   - Define rule in plain English (what data constraint?)
   - Document regulatory requirement or business process justification
   - Identify source table(s) and affected record count
   - Determine acceptance threshold (0%, 1%, or 5%?)

2. **Technical Design:**
   - Translate business rule to SQL/CDQ logic
   - Identify join tables, field references, date ranges
   - Define expected output (violation detail)
   - Estimate execution time and performance impact

3. **Testing (Development Environment):**
   - Create test dataset (100–1,000 records)
   - Seed known violations into test data
   - Execute rule; verify detection accuracy
   - Measure query performance
   - Iterate if performance issues or false positives detected

4. **Peer Review & Approval:**
   - Rule reviewed by: Data Analyst + Underwriting Manager + Compliance Officer
   - Checklist:
     - [ ] Business requirement clearly documented
     - [ ] SQL query validated for correctness
     - [ ] Performance acceptable (< 10 seconds for 500K records)
     - [ ] Test results show 100% detection accuracy
     - [ ] No false positives in test dataset
     - [ ] Threshold appropriate for rule category

5. **Deployment to Production:**
   - Schedule maintenance window (if needed)
   - Deploy rule to production environment
   - Monitor first 24 hours for unexpected violation spikes
   - Document deployment details (date, time, deployer)

---

## SOP 3.2: Rule Execution Triggers & Timing

**Real-Time Rules (Informatica CDI / Guidewire Endpoints):**

```
Trigger: Policy status change in PolicyCenter
├─ Event: Policy set to "Canceled", "NonRenewed", or "Declined"
├─ Rule: VR-001-001 (HB 2067 Reason Code validation)
├─ Latency: < 5 seconds
├─ Action: If violation detected
│  └─ Flag record in vw_automated_issues_log
│  └─ Alert Data Quality Analyst (if CRITICAL severity)
│  └─ Continue processing (do NOT block policy binding)
└─ Rationale: Validate critical data immediately; remediate later

Trigger: Premium calculated in PolicyCenter
├─ Event: Policy rated (premium calculated)
├─ Rule: VR-002-001 (Premium > 0.00)
├─ Latency: Immediate (within rating engine)
├─ Action: If violation detected
│  └─ Block policy binding (REJECT transaction)
│  └─ Return error: "Premium must be > 0"
│  └─ Require underwriter to correct before re-submission
└─ Rationale: Prevent invalid policies from entering system
```

**Nightly Batch Rules (SQL Server Agent):**

```
Trigger: Daily 11:00 PM (after batch data load)
├─ Job: DQ_Validation_Batch_Daily (SQL Server Agent)
├─ Duration: 11:00 PM – 11:30 PM (30 min window)
├─ Execution Order:
│  1. VR-001-001: HB 2067 Compliance (comprehensive scan)
│  2. VR-001-002: Agent ID validation
│  3. VR-002-001: Premium positivity check
│  4. VR-002-002: Date logic validation
│  5. VR-002-003: TDI reason code mapping
│  6. VR-003-001: VIN format validation
│  7. VR-004-001: Orphan detection
│  8. VR-004-002: Cross-system sync check
│  9. VR-005-001: Coastal geocoding check
├─ Results: Inserted into vw_automated_issues_log
├─ Performance: ~18 seconds for 5,000 records; scales ~3.6ms per record
└─ Output: Violations summary emailed to DQ Team by 12:00 AM
```

---

## SOP 3.3: Rule Failure Analysis & Threshold Evaluation

**Execution (Daily at 12:30 AM):**

1. **Query violation counts by rule:**
   ```sql
   SELECT 
       Requirement_ID,
       Rule_Category,
       Severity,
       COUNT(*) as Violation_Count,
       (COUNT(*) / @TotalRecords) * 100 as Failure_Rate_Percent
   FROM vw_automated_issues_log
   WHERE Detection_Timestamp >= CAST(CURRENT_DATE AS TIMESTAMP)
   GROUP BY Requirement_ID, Rule_Category, Severity
   ORDER BY Violation_Count DESC;
   ```

2. **Compare to thresholds:**
   ```
   VR-001-001 (HB 2067): 140 violations = 2.80% failure rate
   ├─ Threshold: 0% (CRITICAL rule)
   ├─ Status: FAILING (2.80% EXCEEDS 0%)
   ├─ Escalation Level: CRITICAL
   └─ Action: Immediate notification to leadership
   
   VR-003-001 (VIN Format): 344 violations = 9.05% failure rate
   ├─ Threshold: 5% (MEDIUM rule)
   ├─ Status: FAILING (9.05% EXCEEDS 5%)
   ├─ Escalation Level: HIGH
   └─ Action: 24-hour RCA required
   
   VR-002-001 (Premium > 0): 0 violations = 0.00% failure rate
   ├─ Threshold: 0% (CRITICAL rule)
   ├─ Status: PASSING (0.00% MEETS 0%)
   ├─ Escalation Level: None
   └─ Action: Routine monitoring
   ```

3. **Generate Threshold Evaluation Report:**
   - Document each rule's status (PASS/FAIL)
   - Identify rules exceeding thresholds
   - Route CRITICAL failures to exec escalation
   - Route HIGH failures to RCA queue
   - Archive report for trend analysis

**Duration:** 10–15 minutes (mostly automated)

---

## SOP 3.4: Constraint Selection & Configuration

**System-Constrained vs. Logic-Constrained Rules:**

**System-Constrained Rules (Prevent invalid data at entry):**
- Implement in PolicyCenter as dropdown lists or validation endpoints
- Prevent invalid values from even being entered
- Examples:
  - Status field: dropdown [Active, Canceled, Draft, NonRenewed, Declined, Suspended]
  - Agent ID: lookup validation (must exist in Agent Master table)
  - Premium: numeric field with > 0.00 constraint

- **Configuration in Guidewire:**
  ```
  Guidewire Olos Release:
  ├─ Validation Endpoint Support
  ├─ Request-and-response validation flows triggered by application events
  ├─ Validates before policy binding
  └─ Returns: VALID or ERROR message
  
  Example: HB 2067 Reason Code Validation Endpoint
  ├─ Trigger: Policy status = "Canceled"
  ├─ Validation: CancellationReasonCode must exist in TDI_Reason_Mapping
  ├─ If Valid: Allow policy to bind
  ├─ If Invalid: Display error; require correction
  └─ Benefit: Prevents non-compliant policies from entering system
  ```

**Logic-Constrained Rules (Detect issues after entry):**
- Implemented as SQL queries or Informatica rules
- Catch issues that system constraints don't prevent
- Examples:
  - Temporal logic: EffectiveDate < ExpirationDate
  - Cross-system reconciliation: PolicyCenter premium matches BillingCenter
  - Pattern detection: Abnormal data clusters by geography or agent

---

## SOP 3.5: Error Handling & Retry Logic

**SQL Server Agent Job Failure Handling:**

```
Scenario 1: Query Timeout (> 10 minutes)
├─ Automatic Action: Retry (up to 2 attempts, with 2-minute delay)
├─ If still failing: Escalate to DBA for performance tuning
├─ Notification: "DQ_Validation_Batch_Daily job timeout - escalated"
└─ Next Steps: Review query execution plan; add indexes if needed

Scenario 2: Connection Error to BigQuery
├─ Automatic Action: Retry (up to 2 attempts, with 30-second delay)
├─ If still failing: Check BigQuery service status & network connectivity
├─ Notification: "Failed to connect to BigQuery - check firewall rules"
└─ Resolution: Contact IT infrastructure team

Scenario 3: NULL Result Set (Unexpected)
├─ Automatic Action: Review data in source tables
├─ Check: Did batch load fail? Are there 0 records?
├─ Notification: "Validation returned 0 violations - check for data issues"
├─ Investigation: Execute basic COUNT(*) queries on source tables
└─ If data present: Investigate rule logic for bugs

Scenario 4: False Positive Spike (Violations > 2x historical average)
├─ Investigation: Is this real data issue or rule bug?
├─ Check: Recent system changes, data model updates, ETL logic changes?
├─ Validation: Manually spot-check 10 flagged records
├─ Action: 
│  ├─ If real issue: Escalate per SOP 5 (Issue Management & Escalation)
│  ├─ If rule bug: Disable rule temporarily; fix logic; redeploy
│  └─ Notification: Root cause analysis required
└─ Duration: 1 hour max before stakeholder notification
```

---

---

# SOP 4: Root Cause Analysis and Remediation

**Objective:** Identify systemic sources of data quality failures through structured investigation, enabling prevention of recurrence.

**Scope:** Applies to all violations with Severity = CRITICAL or HIGH, or rule failure rate > threshold

**Frequency:** On-demand (triggered by issue escalation)

**Responsibility:** Data Quality Analyst II (investigation); Underwriting Manager (remediation approval)

---

## SOP 4.1: RCA Initiation & Problem Statement

**Trigger:** Data Quality Analyst notified of violation spike via automated alert

**Time Requirement:** CRITICAL issues = 1–4 hour response; HIGH issues = 24 hour response

**Step 1: Problem Definition**

Use SMART principle (Specific, Measurable, Action-oriented, Realistic, Time-constrained):

```
Example RCA: HB 2067 Reason Code Violations

SPECIFIC:
  What: 140 canceled policies have missing or unmapped cancellation reason codes
  When: First detected April 17, 2026 at 12:30 AM
  Where: Policies created between April 1–April 17, 2026 (post-Olos release)
  Who: 58 policies with internal code 'INT_99'; 82 with NULL code

MEASURABLE:
  Volume: 140 violations = 2.80% of 5,000 canceled policies
  Trend: Violations consistently present (not improving)
  Impact: 140 customers lack written denial explanation (HB 2067 violation)

ACTION-ORIENTED:
  Objective: Identify root cause of missing/unmapped reason codes
  Approach: Temporal analysis + system review + vendor investigation
  Deliverable: RCA post-mortem with remediation plan

REALISTIC:
  Timeline: 24 hours to preliminary root cause; 7 days to remediation plan
  Resources: 1 Data Analyst (20 hrs) + Guidewire support (as needed)
  Risk: If not resolved, TDI reporting deadline (June 15, 2026) at risk

TIME-CONSTRAINED:
  Preliminary Report Due: April 18, 2026 by 5:00 PM
  Final RCA Report Due: April 19, 2026 by 9:00 AM
  Remediation Plan Due: April 20, 2026 by 5:00 PM
```

---

## SOP 4.2: Data Collection & Investigation

**Step 1: Gather Evidence**

1. **System Logs & Change History:**
   - Guidewire Olos release notes (December 2025 → April 2026)
   - PolicyCenter policy binding logs (April 1–17, 2026)
   - ETL/Informatica job logs (any failures or warnings?)
   - Database schema changes (new/modified fields?)
   - Configuration changes (policy workflow, automation rules)

2. **Data Profiling (RCA Queries):**
   - SQL_05_RCA_HB2067_Temporal_Spread.sql → Temporal pattern
   - SQL_06_RCA_Orphan_Trace.sql → Lineage investigation
   - Query results:
     ```
     Temporal Pattern (SQL_05):
     ┌─────────────┬────────────────┬────────────────┐
     │ CreateTime  │ Missing_Count  │ Unmapped_Count │
     ├─────────────┼────────────────┼────────────────┤
     │ 2026-04-01  │ 12             │ 5              │  ← Olos release date
     │ 2026-04-02  │ 15             │ 8              │
     │ 2026-04-03  │ 18             │ 7              │
     │ ...         │ ...            │ ...            │
     │ 2026-04-17  │ 22             │ 38             │  ← Cluster pattern
     └─────────────┴────────────────┴────────────────┘
     
     Observation: Missing codes cluster post-April 1 (Olos release date)
     Hypothesis: System logic change in Olos; cancellation trigger not firing
     ```

3. **Stakeholder Interviews:**
   - Guidewire Implementation Lead: "Was reason code mapping deployed with Olos?"
   - Underwriting Manager: "Have any policy workflows changed recently?"
   - Business Analyst: "Are agents reporting new errors or warnings?"

4. **Vendor Investigation:**
   - Contact Guidewire support with:
     - Issue summary: "140 canceled policies post-Olos lack reason codes"
     - Evidence: Temporal pattern shows cluster post-April 1
     - Impact: HB 2067 compliance risk (June 15 TDI report deadline)
     - Urgency: CRITICAL

---

## SOP 4.3: Analysis Phase – 5 Whys & Root Cause Identification

**Step 1: Apply "5 Whys" Method**

```
Issue: 140 canceled policies missing cancellation reason codes

Why 1: Why don't canceled policies have reason codes?
  → Because CancellationReasonCode field is NULL or not populated

Why 2: Why is CancellationReasonCode not populated?
  → Because PolicyCenter cancellation workflow is not capturing the reason from underwriter

Why 3: Why is the cancellation workflow not capturing reason?
  → Because Olos release modified the policy binding logic; cancellation trigger not firing

Why 4: Why is the cancellation trigger not firing in Olos?
  → Because the trigger was removed during Olos migration; needs to be re-implemented

Why 5: Why wasn't the trigger re-implemented?
  → Because migration checklist missed this requirement; stakeholder communication gap

ROOT CAUSE: Guidewire Olos migration incomplete; cancellation trigger not deployed
```

**Step 2: Apply Fishbone (Ishikawa) Diagram**

```
                         MISSING REASON CODES
                              (Effect)
                              /       \
                            /         \
                    PEOPLE            PROCESS
                   /     \            /     \
              Lack of   Insufficient  No    No
             Training  Documentation Validation Approval
                \         /         \     /
                 \       /           \   /
              SYSTEM                TOOLS
             /   |   \           /      \
           Olos Null Config   NULL    No
          Release Fields      in     Mapping
                \    |  \      |    /
                 \   |   \__________/
                  \  |             /
                   MISSING REASON CODES
```

**Step 3: Prioritize Root Causes**

```
Root Cause Rankings (by impact & likelihood):

1. PRIMARY: Olos Migration Gap
   ├─ Likelihood: 95% (temporal cluster post-Olos = smoking gun)
   ├─ Impact: HIGH (82 policies = 58% of total violations)
   ├─ Evidence: All 82 missing codes post-April 1
   ├─ Remediation: Re-implement cancellation trigger in Guidewire
   ├─ Owner: Guidewire Implementation Team
   └─ Timeline: 3–7 days (vendor dependent)

2. SECONDARY: Unmapped Internal Codes
   ├─ Likelihood: 90% (58 records with code 'INT_99')
   ├─ Impact: MEDIUM (58 policies = 41% of violations)
   ├─ Evidence: All 58 have internal code not in TDI_Reason_Mapping
   ├─ Remediation: Identify what INT_99 represents; map to TDI code
   ├─ Owner: Underwriting Manager + Data Quality Team
   └─ Timeline: 24–48 hours

3. TERTIARY: Data Entry Gap
   ├─ Likelihood: 5% (only 82+58=140 violations, not widespread)
   ├─ Impact: LOW (if only agent training gap)
   ├─ Evidence: None (isolated to specific time window)
   ├─ Remediation: If confirmed, implement training + validation
   ├─ Owner: Underwriting Operations Manager
   └─ Timeline: 7 days (training cycle)
```

---

## SOP 4.4: Corrective Action Development

**Step 1: Corrective Action Plan**

For each root cause, define:

```
ROOT CAUSE 1: Olos Migration Gap – Cancellation Trigger Not Deployed

Corrective Action Plan:
├─ Action: Re-implement cancellation trigger in Guidewire Olos
│  ├─ Trigger: When policy.status changes to 'Canceled'
│  ├─ Logic: Prompt underwriter to select CancellationReasonCode
│  ├─ Validation: Reason code must exist in TDI_Reason_Mapping
│  └─ Constraint: Block policy cancellation if reason code missing
│
├─ Owner: Guidewire Implementation Lead (with Guidewire support)
│
├─ Timeline:
│  ├─ April 18: Confirm with Guidewire if trigger was removed
│  ├─ April 19: Design trigger logic (workflow change)
│  ├─ April 20–22: Test in staging environment
│  ├─ April 23: Deploy to production (maintenance window 10 PM–12 AM)
│  ├─ April 24: Monitor for impact; verify new policies have reason codes
│  └─ April 25: Close action item
│
├─ Success Criteria:
│  ├─ ✓ Cancellation trigger implemented and tested
│  ├─ ✓ New canceled policies have populated CancellationReasonCode
│  ├─ ✓ No users report workflow errors or warnings
│  ├─ ✓ Rule VR-001-001 violation rate drops to 0%
│  └─ ✓ 0 cascading failures in dependent systems
│
├─ Fallback Plan (if implementation delayed):
│  ├─ Manually assign CancellationReasonCode to 82 affected policies
│  ├─ Update vw_pc_policyperiod_cleansed to default to code 'K'
│  ├─ Use golden layer for Q2 TDI reporting (interim solution)
│  └─ Timeline: 2 hours per 50 policies (4.1 hours total)
│
└─ Risk: If not resolved by June 15, 2026 (TDI report deadline)
   └─ TDI will receive incomplete reason code data
   └─ Potential audit findings or penalties

ROOT CAUSE 2: Unmapped Internal Codes (INT_99)

Corrective Action Plan:
├─ Action: Identify & map internal code INT_99 to TDI equivalent
│  ├─ Research: What business rule/scenario triggers INT_99?
│  ├─ Mapping: Which TDI code (A–X) best fits? (likely 'L' = "All other underwriting")
│  ├─ Implementation: Add mapping to TDI_Reason_Mapping table
│  └─ Validation: Update 58 policies' reason codes
│
├─ Owner: Underwriting Manager + Data Quality Analyst II
│
├─ Timeline:
│  ├─ April 18: Interview underwriting team (what is INT_99?)
│  ├─ April 19: Determine TDI mapping (Compliance Officer approval)
│  ├─ April 19: Update TDI_Reason_Mapping reference table
│  ├─ April 20: Update 58 policies in pc_policyperiod (bulk SQL UPDATE)
│  ├─ April 20: Re-run VR-002-003 validation rule to verify fix
│  └─ April 20: Close action item
│
├─ Success Criteria:
│  ├─ ✓ INT_99 documented (what it represents)
│  ├─ ✓ Mapping to TDI code approved by Compliance
│  ├─ ✓ 58 policies updated in PolicyCenter
│  ├─ ✓ Rule VR-002-003 shows 0 unmapped violations
│  └─ ✓ Golden layer view reflects corrected codes
│
└─ Implementation SQL:
   ```sql
   -- Step 1: Add mapping to reference table
   INSERT INTO TDI_Reason_Mapping (InternalCode, TDICode, ReasonDescription, ApplicableTo)
   VALUES ('INT_99', 'L', 'Underwriting - All other underwriting reasons', 'C, NR, D');
   
   -- Step 2: Update policies with corrected reason code
   UPDATE pc_policyperiod
   SET CancellationReasonCode = (SELECT TDICode FROM TDI_Reason_Mapping WHERE InternalCode = 'INT_99')
   WHERE CancellationReasonCode = 'INT_99' AND Status = 'Canceled';
   
   -- Step 3: Verify fix
   SELECT COUNT(*) as Remaining_Unmapped
   FROM pc_policyperiod p
   LEFT JOIN TDI_Reason_Mapping t ON p.CancellationReasonCode = t.InternalCode
   WHERE p.Status = 'Canceled' AND t.TDICode IS NULL;
   
   Expected: 0 remaining
   ```
```

---

## SOP 4.5: RCA Post-Mortem Documentation

**Deliverable: RCA Post-Mortem Report**

```
═══════════════════════════════════════════════════════════════════════════════
RCA POST-MORTEM REPORT
═══════════════════════════════════════════════════════════════════════════════

Issue ID:                 VR-001-001-20260417
Issue Title:              HB 2067 Missing/Unmapped Reason Codes
Detection Date:           April 17, 2026 at 12:30 AM
Report Date:              April 19, 2026
Prepared By:              Daniel Rodriguez III, Data Quality Analyst II
Reviewed By:              [Underwriting Manager signature]
Approved By:              [Data Governance Committee signature]

─────────────────────────────────────────────────────────────────────────────
PROBLEM STATEMENT (SMART)
─────────────────────────────────────────────────────────────────────────────
140 canceled policies (2.8% of dataset) lack cancellation reason codes:
• 82 records with NULL CancellationReasonCode (58% of violations)
• 58 records with unmapped internal code 'INT_99' (41% of violations)

All 140 violations detected post-April 1, 2026 (Olos release date).

Impact: HB 2067 compliance violation; customers lack written denial explanation

─────────────────────────────────────────────────────────────────────────────
ROOT CAUSE ANALYSIS
─────────────────────────────────────────────────────────────────────────────

PRIMARY ROOT CAUSE (82 violations):
  Guidewire Olos Migration Incomplete
  
  Evidence:
  • Temporal cluster: All 82 violations post-April 1, 2026 (Olos release date)
  • Affected transactions: Canceled policies created post-Olos deployment
  • System investigation: Cancellation trigger not re-implemented in Olos
  • Likelihood: 95% (statistical correlation + system investigation confirm)
  
  Analysis:
  • Previous system (pre-Olos) had cancellation trigger that fired when policy.status → 'Canceled'
  • Trigger required underwriter to select reason code before confirming cancellation
  • During Olos migration (Dec 2025 – Mar 2026), this trigger was not deployed
  • Result: New cancellations post-April 1 have no reason code capture
  • Configuration Gap: Olos validation endpoint not yet configured for reason code enforcement

SECONDARY ROOT CAUSE (58 violations):
  Legacy Internal Codes Not Mapped to TDI
  
  Evidence:
  • All 58 violations have CancellationReasonCode = 'INT_99' (system placeholder)
  • INT_99 not found in TDI_Reason_Mapping reference table
  • Investigation: INT_99 used for "other underwriting" scenarios (catch-all)
  
  Analysis:
  • During pre-Olos data migration, legacy reason codes were preserved
  • Not all legacy codes were mapped to new TDI statutory codes
  • INT_99 = internal system code for "all other reasons" (now TDI code 'L')
  • Mapping gap discovered during HB 2067 validation implementation
  
  Likelihood: 90% (code present, mapping missing)

─────────────────────────────────────────────────────────────────────────────
CORRECTIVE ACTIONS & TIMELINE
─────────────────────────────────────────────────────────────────────────────

IMMEDIATE (24 hours):
1. [ASSIGNED] Underwriting Manager: Identify what INT_99 represents (24 hrs)
   └─ Target: Determine if INT_99 maps to TDI code 'L' or other
   
2. [ASSIGNED] Compliance Officer: Approve INT_99 → TDI mapping (48 hrs)
   └─ Target: Formal approval by April 20, 2026

SHORT-TERM (7 days):
3. [ASSIGNED] Data Quality Analyst II: Update TDI_Reason_Mapping table (48 hrs)
   └─ Target: Add INT_99 mapping by April 20, 2026
   
4. [ASSIGNED] Underwriting Operations: Update 58 policies in PolicyCenter (48 hrs)
   └─ Target: Bulk SQL UPDATE by April 20, 2026
   
5. [ASSIGNED] Guidewire Implementation Lead: Re-implement cancellation trigger (7 days)
   └─ Target: Trigger deployed to production by April 25, 2026

MEDIUM-TERM (30 days):
6. [ASSIGNED] Underwriting Manager: Document cancellation workflow changes (7 days)
   └─ Target: Updated SOP by April 25, 2026
   
7. [ASSIGNED] Compliance Officer: Update HB 2067 compliance checklist (7 days)
   └─ Target: Checklist updated by April 25, 2026

─────────────────────────────────────────────────────────────────────────────
PREVENTIVE MEASURES
─────────────────────────────────────────────────────────────────────────────

To prevent recurrence of migration gaps:

1. Pre-Release Validation Checklist
   ├─ For all future Guidewire releases:
   ├─ Require: Configuration audit of critical workflows (cancellation, binding, rating)
   ├─ Verify: All validation endpoints re-implemented in new release
   ├─ Sign-off: Guidewire lead + Data Governance Committee before go-live
   └─ Owner: Guidewire Implementation Lead

2. Data Quality Rule Pre-Deployment
   ├─ Before deploying validation rule to production:
   ├─ Execute rule against staging data from pre-release environment
   ├─ Verify: Rule catches expected violations (0 false negatives)
   ├─ Verify: Rule produces no unexpected violations (0 false positives)
   └─ Owner: Data Quality Analyst II

3. Enhanced HB 2067 Compliance Monitoring
   ├─ Implement daily (not weekly) HB 2067 compliance verification
   ├─ Alert threshold: If ANY canceled policy missing reason code
   ├─ Response: Escalate to CRITICAL; pause processing until resolved
   └─ Owner: Data Quality Analyst II

4. Cross-System Governance
   ├─ Establish Guidewire Release Review Board (meets before each release)
   ├─ Board composition: Guidewire lead, Data Quality, Compliance, Underwriting
   ├─ Agenda: Review release notes for data quality impacts
   ├─ Decision: GO / GO-WITH-MITIGATIONS / NO-GO
   └─ Owner: Data Governance Committee

─────────────────────────────────────────────────────────────────────────────
LESSONS LEARNED
─────────────────────────────────────────────────────────────────────────────

1. Temporal Pattern Analysis Effective
   • Clustering of violations post-Olos release immediately identified system change as root cause
   • Recommendation: Always plot violation timeline; look for step-function changes

2. Stakeholder Communication Gap
   • Guidewire implementation team did not communicate that cancellation trigger was not deployed
   • Recommendation: Formal stakeholder notification requirements for all system changes

3. Reference Data Management Critical
   • Legacy codes (INT_99) not migrated to reference table
   • Recommendation: Validate reference table completeness before HB 2067 enforcement

4. HB 2067 Requires Daily (Not Weekly) Monitoring
   • Issue detected after 16 days (April 1–17); should have been caught in days 1–2
   • Recommendation: Real-time alerting for HB 2067 violations (cannot wait for nightly batch)

─────────────────────────────────────────────────────────────────────────────
FINANCIAL & COMPLIANCE IMPACT
─────────────────────────────────────────────────────────────────────────────

If Not Remediated by June 15, 2026 (TDI Report Deadline):
├─ Regulatory Risk: TDI audit finding for incomplete reason code reporting
├─ Financial Risk: Potential penalty $1,000–$10,000 (estimate)
├─ Reputational Risk: Market conduct exam findings publicized
├─ Customer Impact: 140 customers may seek refunds (lack of written explanation)
└─ Business Impact: Underwriting process subject to regulatory scrutiny

With Remediation (by April 25, 2026):
├─ TDI Compliance: All 140 policies corrected; Q2 report complete & compliant
├─ Customer Service: Belated written explanations provided to 140 customers
├─ Process Improvement: Future cancellations captured correctly
└─ Audit Readiness: Evidence of proactive identification and resolution

─────────────────────────────────────────────────────────────────────────────
APPROVAL & CLOSURE
─────────────────────────────────────────────────────────────────────────────

RCA Report Approved By:
  [Print Name]                    [Title]                [Signature]  [Date]
  ___________________________    _______________    __________      __________
  
  ___________________________    _______________    __________      __________

RCA Status: APPROVED
Issue Status: IN REMEDIATION
Expected Closure: April 25, 2026

Contact: Daniel Rodriguez III, Data Quality Analyst II
         Email: d.rodriguez@tfbcas.com
         Ext: 5555
```

---

## SOP 4.6: Implementation & Verification

**Step 1: Execute Corrective Actions**

- Track progress via action item tracking system (Asana, Jira, or Excel)
- Owner provides daily updates (% complete, blockers, ETA)
- Escalate if timeline slipping

**Step 2: Re-Validation**

After corrective action implemented:

```
Re-Validation Query:

SELECT 
    'VR-001-001' as Rule_ID,
    COUNT(*) as Violations_Before,
    (SELECT COUNT(*) FROM vw_automated_issues_log 
     WHERE Rule_Category = 'HB 2067 Compliance' 
     AND Detection_Timestamp >= '2026-04-25') as Violations_After,
    CASE 
        WHEN (violations_after = 0) THEN '✓ RESOLVED'
        ELSE '⚠ PARTIALLY RESOLVED (Remaining: ' || violations_after || ')'
    END as Resolution_Status

Results Expected (April 25, 2026):
├─ Violations_Before: 140
├─ Violations_After: 0
└─ Status: ✓ RESOLVED

If not resolved: Loop back to RCA (Step 4.2)
```

---

---

# SOP 5: Data Issue Management and Severity Escalation

**Objective:** Establish standardized response protocols based on business impact severity to ensure critical issues receive immediate attention.

**Scope:** All data quality violations flagged to vw_automated_issues_log

**Frequency:** Continuous monitoring; escalation as triggered

**Responsibility:** Data Quality Analyst II (monitoring & response); Data Governance Committee (oversight)

---

## SOP 5.1: Severity Classification Framework

```
SEVERITY LEVEL: CRITICAL
├─ Definition: Issue halts underwriting or breaches TDI statutory SLA
├─ Examples:
│  ├─ HB 2067 compliance failure (missing reason codes for > 100 policies)
│  ├─ Referential integrity breach (> 50 orphaned records)
│  ├─ Catastrophic data corruption (all policies missing critical field)
│  └─ TDI report failure (cannot generate on-time submission)
├─ Investigation Response: 1–4 hours
├─ Resolution Target: 24 hours
├─ Escalation: Immediate notification to Data Governance Committee + Exec Leadership
└─ Processing Impact: STOP downstream processing until root cause identified

SEVERITY LEVEL: HIGH
├─ Definition: Issue affects pricing models or risk assessment accuracy
├─ Examples:
│  ├─ VIN format errors preventing NHTSA lookups (> 500 vehicles)
│  ├─ Premium reconciliation discrepancy (> $100K financial variance)
│  ├─ Geocoding failures on coastal risks (> 200 properties)
│  └─ Agent ID validation failures (> 50 policies)
├─ Investigation Response: 24 hours
├─ Resolution Target: 5 business days
├─ Escalation: Notification to Underwriting Manager + Data Governance Committee
└─ Processing Impact: Continue processing; flag affected records; track for resolution

SEVERITY LEVEL: MEDIUM
├─ Definition: Issue impacts reporting accuracy or data hygiene
├─ Examples:
│  ├─ Address standardization gaps
│  ├─ Phone number formatting inconsistencies
│  ├─ Non-core field data entry errors
│  └─ Cosmetic or aesthetic data quality issues
├─ Investigation Response: Best-effort (within 1 week)
├─ Resolution Target: 30 days
├─ Escalation: Included in weekly data quality summary
└─ Processing Impact: No impact; continue processing normally

SEVERITY LEVEL: WARNING
├─ Definition: Isolated issue with minimal business impact
├─ Examples:
│  ├─ Single record with formatting anomaly
│  ├─ Historical data quality gap (pre-migration)
│  └─ Data entry typo with workaround
├─ Investigation Response: Document for trend analysis
├─ Resolution Target: Archived; no action required
├─ Escalation: Included in monthly trend report
└─ Processing Impact: No impact
```

---

## SOP 5.2: Escalation Workflow

**CRITICAL Severity Escalation Path:**

```
TIME: T+0 (Detection)
  └─ Automated alert generated (vw_automated_issues_log entry created)
  
TIME: T+5 min
  └─ Data Quality Analyst receives Slack notification + email
  └─ Analyst acknowledges receipt
  
TIME: T+15 min
  └─ Analyst investigates: Is this truly CRITICAL?
  ├─ Check: Does this actually halt underwriting?
  ├─ Check: Does this violate TDI statutory requirement?
  └─ If NO → Reclassify to HIGH; proceed with high-severity workflow
  
TIME: T+30 min
  └─ IF CONFIRMED CRITICAL:
  ├─ Analyst sends escalation email to:
  │  ├─ Data Governance Committee Chair
  │  ├─ Underwriting Manager
  │  ├─ Compliance Officer
  │  ├─ CFO (if financial impact)
  │  └─ CEO (if regulatory impact)
  ├─ Subject: "🔴 CRITICAL Data Quality Issue – Immediate Action Required"
  ├─ Content: Issue summary, impact, recommended immediate action
  └─ Escalation complete
  
TIME: T+1 hour
  └─ Leadership responds with:
     ├─ Decision: Stop processing? Continue with mitigations?
     ├─ Assign: Who will lead RCA?
     ├─ Timeline: When must issue be resolved?
     └─ Resources: Any additional staff/tools needed?
  
TIME: T+4 hours
  └─ Root cause analysis presented to leadership
  └─ Corrective action plan approved
  
TIME: T+24 hours
  └─ Issue resolved OR escalated again with status update
```

**HIGH Severity Escalation Path:**

```
TIME: T+0
  └─ Issue detected; logged to Automated Issues Log
  
TIME: T+1 day
  └─ Data Quality Analyst reviews in morning stand-up
  └─ Schedule RCA investigation (target: start same day)
  
TIME: T+24 hrs
  └─ Analyst sends status update to Underwriting Manager:
     ├─ Issue summary
     ├─ Preliminary RCA findings
     ├─ Estimated resolution date
     └─ Any interim mitigations in place?
  
TIME: T+5 days
  └─ RCA complete; corrective action plan developed
  └─ Present findings to Data Governance Committee (next Monday meeting)
  
TIME: T+5–10 days
  └─ Corrective actions implemented
  └─ Re-validation confirms resolution
  └─ Issue closed
```

---

## SOP 5.3: Stakeholder Notification Templates

**CRITICAL Escalation Email:**

```
TO: Data Governance Committee; Leadership; Compliance; CFO
CC: Data Quality Team
SUBJECT: 🔴 CRITICAL DATA QUALITY ISSUE – Immediate Action Required

ISSUE SUMMARY:
    [Issue ID]: VR-001-001-20260417
    [Title]: HB 2067 Missing Cancellation Reason Codes
    [Volume]: 140 canceled policies (2.8% of dataset)
    [Status]: UNRESOLVED (requires immediate action)

REGULATORY IMPACT:
    ✗ House Bill 2067 Compliance Violation
    ✗ Customers lack required written denial explanation
    ✗ TDI reporting deadline: June 15, 2026 (58 days remaining)
    ✗ Potential regulatory penalties if not resolved

BUSINESS IMPACT:
    ✗ Cannot generate compliant HB 2067 statistical report
    ✗ 140 customers at risk of refund requests
    ✗ Audit findings expose organization to scrutiny

IMMEDIATE ACTION REQUIRED:
    1. Declare CRITICAL issue (stop non-essential processing if needed)
    2. Allocate RCA resources (Guidewire lead + Data Analyst II)
    3. Establish 24-hour resolution deadline
    4. Provide status update by [TIME]

PRELIMINARY ANALYSIS:
    Root Cause: Olos migration gap; cancellation trigger not re-implemented
    Timeline: Issue cluster post-April 1, 2026 (Olos release date)
    Evidence: Temporal pattern confirms system change correlation

RECOMMENDED IMMEDIATE STEPS:
    1. Contact Guidewire support (CRITICAL severity)
    2. Schedule emergency RCA call (today, 2:00 PM)
    3. Develop interim mitigation (cleansed view for TDI report)
    4. Prepare customer communication (if refunds anticipated)

NEXT UPDATE: Today, 5:00 PM

Contact: Daniel Rodriguez III, Data Quality Analyst II
         d.rodriguez@tfbcas.com | Ext 5555
```

**HIGH Severity Daily Status Update:**

```
TO: Underwriting Manager; Data Quality Team
SUBJECT: Data Quality Status Update – April 18, 2026

ACTIVE HIGH-SEVERITY ISSUES (3):

1. VR-003-001: VIN Format Validation (344 violations)
   ├─ Current Status: RCA in progress
   ├─ Root Cause: Legacy data migration without normalization
   ├─ Remediation: Batch VIN standardization script
   ├─ ETA: April 20, 2026
   └─ Owner: Data Quality Analyst II

2. VR-005-001: Coastal Geocoding (594 violations)
   ├─ Current Status: Vendor investigation (HazardHub)
   ├─ Root Cause: API regional timeout failure
   ├─ Remediation: Awaiting vendor infrastructure patch
   ├─ ETA: April 22, 2026
   └─ Owner: Catastrophe Management + Vendor

3. VR-004-002: Financial Reconciliation (204 violations)
   ├─ Current Status: Interim analysis
   ├─ Root Cause: BillingCenter pro-rata calculation error
   ├─ Remediation: Software patch planned
   ├─ ETA: April 25, 2026
   └─ Owner: Billing Operations + IT

WEEKLY PROGRESS SUMMARY:

Issue ID           Starting  Remaining  % Resolved  ETA Closure
─────────────────────────────────────────────────────────────
VR-001-001           140        140        0%      May 5, 2026
VR-002-003            58         0        100%    ✓ CLOSED (Apr 20)
VR-003-001           344        344        0%      April 20, 2026
VR-004-001            20         0        100%    ✓ CLOSED (Apr 18)
VR-005-001           594        594        0%      April 22, 2026

OVERALL PROGRESS: 2 of 8 HIGH-severity issues resolved (25%)

ANY QUESTIONS? Contact Daniel Rodriguez
```

---

## SOP 5.4: SLA Compliance Tracking

**Monitoring Dashboard (Updated Hourly):**

```
ISSUE SLA TRACKING – APRIL 18, 2026

Issue ID       Severity  Detection   SLA Deadline  Hours Used  % Consumed  Status
────────────────────────────────────────────────────────────────────────────────
VR-001-001     CRITICAL  04-17 12:30  04-18 12:30      24 hrs     50%      ⚠ AT RISK
VR-003-001     HIGH      04-17 10:45  04-18 10:45      24 hrs     60%      ⚠ AT RISK
VR-004-002     HIGH      04-18 08:00  04-19 08:00      24 hrs     15%      ✓ TRACKING
VR-005-001     HIGH      04-17 12:30  04-22 12:30      120 hrs    10%      ✓ TRACKING

CRITICAL ISSUES APPROACHING SLA DEADLINE:
├─ VR-001-001: 12 hours remaining; RCA not yet complete
│  └─ Action: Accelerate investigation; escalate for leadership decision
└─ VR-003-001: 9 hours remaining; remediation in progress
   └─ Action: Fast-track batch VIN standardization script

Alert: If any issue exceeds SLA without documented extension approval
       → Executive escalation required
       → Root cause of investigation delay documented
       → Preventive measures implemented
```

---

---

# SOP 6: Data Quality KPI Monitoring and Reporting

**Objective:** Systematically evaluate data quality performance across six dimensions to maintain long-term data health and stakeholder visibility.

**Scope:** Applies to all dashboards, reports, and KPI calculations

**Frequency:** Daily (automated), Weekly (human-driven), Monthly (executive reporting)

**Responsibility:** Data Quality Analyst II (calculation & dashboards); Data Governance Committee (communication)

---

## SOP 6.1: KPI Definition & Target Setting

**Six Dimensions of Data Quality:**

```
ACCURACY (SQL_09 Query: "% Records Passing Validation")
├─ Definition: Records conform to business rules and validation constraints
├─ Metric: (Total Records - Failing Records) / Total Records × 100%
├─ Current: 93.43% (6.57% error rate)
├─ Target: > 99.0% (< 1.0% error rate)
├─ Gap: -5.57 percentage points
├─ Drivers:
│  ├─ HB 2067 Compliance: 140 violations
│  ├─ VIN Format: 344 violations
│  └─ Geocoding: 594 violations
└─ Responsibility: Data Quality Analyst II

COMPLETENESS (SQL_09 Query: "% Non-NULL on Mandatory Fields")
├─ Definition: All mandatory fields required for underwriting populated
├─ Metric: (Non-NULL Fields) / (Mandatory Fields) × 100%
├─ Current: 97.85%
├─ Target: 100.0% (no NULLs permitted)
├─ Gap: -2.15 percentage points
├─ Drivers: CancellationReasonCode missing on 82 canceled policies
└─ Responsibility: Data Quality Analyst II

CONSISTENCY (SQL_09 Query: "Cross-System Alignment Rate")
├─ Definition: Data is uniform across PolicyCenter and BillingCenter
├─ Metric: (Aligned Records) / (Total Records) × 100%
├─ Current: 59.20% (204 discrepancies detected)
├─ Target: 100.0%
├─ Gap: -40.80 percentage points
├─ Drivers: Premium reconciliation gap (BillingCenter pro-rata error)
└─ Responsibility: Billing Operations Manager

TIMELINESS (SQL_09 Query: "Data Load Lag (hours)")
├─ Definition: Data available when needed; reflects current operational status
├─ Metric: Hours between source change and data warehouse availability
├─ Current: 2.5 hours (nightly batch load completes by 11:00 PM + 2.5 hrs)
├─ Target: < 4 hours
├─ Gap: +1.5 hours (EXCEEDS target, but within tolerance)
├─ Status: ✓ PASSING
├─ Drivers: Real-time Informatica CDI for HB 2067 critical data
└─ Responsibility: Informatica Administrator

VALIDITY (SQL_09 Query: "% Values Conforming to TDI Code Lists")
├─ Definition: Data values conform to predefined format, type, domain requirements
├─ Metric: (Valid Values) / (Total Values) × 100%
├─ Current: 94.71%
├─ Target: 100.0%
├─ Gap: -5.29 percentage points
├─ Drivers:
│  ├─ VIN Format violations: 344 records
│  ├─ Unmapped TDI codes: 58 records
│  └─ Geocoding coordinate format: 594 missing values
└─ Responsibility: Data Quality Analyst II

INTEGRITY (SQL_09 Query: "Orphan Record Count")
├─ Definition: No orphaned or disconnected records; referential integrity maintained
├─ Metric: Count of records lacking valid parent reference
├─ Current: 20 orphaned location records
├─ Target: 0 orphans
├─ Gap: -20 records
├─ Status: ⚠ BELOW TARGET
├─ Drivers: Batch endorsement logic error in Olos (20 location records)
└─ Responsibility: Database Administrator

OVERALL DATA QUALITY SCORE (Weighted Average):
├─ Formula: (Accuracy×20% + Completeness×20% + Consistency×20% + Timeliness×15% + Validity×15% + Integrity×10%)
├─ Current: 90.47%
├─ Target: > 99.0%
├─ Status: 🔴 FAILING (9.53 points below target)
└─ Improvement Needed: Resolve HB 2067, VIN, Geocoding, and Reconciliation issues
```

---

## SOP 6.2: Automated KPI Calculation & Dashboarding

**Execution (Daily at 10:15 AM):**

1. **SQL_09_Final_DQ_Scorecard_Metrics.sql Executes:**

```sql
-- Query calculates all 6 dimensions
-- Results stored in: dq_scorecard_results table
-- Dashboard auto-refreshes from results table

Expected Output:
┌──────────────┬──────────────┬───────────────┬──────────┐
│ Dimension    │ Current_Score│ Dept_Target   │ Status   │
├──────────────┼──────────────┼───────────────┼──────────┤
│ Accuracy     │ 93.43%       │ < 1.0% Error  │ FAIL     │
│ Completeness │ 97.85%       │ 100% (No Null)│ FAIL     │
│ Consistency  │ 59.20%       │ 0 Discrepanc. │ FAIL     │
│ Timeliness   │ 2.5 hrs      │ < 4 hrs       │ PASS     │
│ Validity     │ 94.71%       │ 100%          │ FAIL     │
│ Integrity    │ 99.60%       │ 0 Orphans     │ FAIL     │
└──────────────┴──────────────┴───────────────┴──────────┘

Overall Score: 90.47% | Status: 🔴 FAILING
```

2. **Power BI Dashboard Refreshes:**

   - Dashboard displays on monitors in Underwriting Data Office
   - Real-time visualization of all 6 KPI dimensions
   - Trend sparklines show 7-day and 30-day movement
   - Drill-down capability to detail issues by category

3. **Email Alert to Stakeholders (if thresholds exceeded):**

```
TO: Data Governance Committee
SUBJECT: 📊 Daily Data Quality Scorecard – April 18, 2026

OVERALL SCORE: 90.47% (Target: 99.0%) | Status: 🔴 FAILING

DIMENSION PERFORMANCE:
├─ Accuracy:      93.43% (Target: 99.0%) ⚠ BELOW TARGET
├─ Completeness:  97.85% (Target: 100.0%) ⚠ BELOW TARGET
├─ Consistency:   59.20% (Target: 100.0%) 🔴 CRITICAL
├─ Timeliness:    2.5 hrs (Target: <4 hrs) ✓ PASS
├─ Validity:      94.71% (Target: 100.0%) ⚠ BELOW TARGET
├─ Integrity:     99.60% (Target: 100.0%) ⚠ BELOW TARGET

TREND ANALYSIS (vs. Previous Day):
├─ Accuracy:      → Stable (no change)
├─ Completeness:  → Stable (no change)
├─ Consistency:   → Stable (no change)
├─ Timeliness:    ↓ Slight degradation (2.5 vs 2.3 hrs)
├─ Validity:      → Stable (no change)
├─ Integrity:     → Stable (no change)

OVERALL TREND: 📊 Stable (no significant changes from yesterday)

ACTION ITEMS: 3 HIGH-severity investigations ongoing
See attached "Data Quality Status Summary" for details
```

---

## SOP 6.3: Weekly & Monthly Reporting

**Weekly Report (Mondays 9:00 AM Data Governance Meeting):**

- Scorecard trend vs. prior week and monthly average
- Remediation progress (% of violations resolved by category)
- Risk assessment (likelihood of meeting Q2 TDI deadline?)
- Preventive measures recommended

**Monthly Executive Report (End of Month):**

```
DATA QUALITY MONTHLY REPORT – APRIL 2026

EXECUTIVE SUMMARY:
Overall DQ Score: 90.47% (Target: 99.0%) | Status: 🔴 FAILING

This month, we identified 1,302 data quality violations across 9 rule categories.
Primary issues: HB 2067 compliance (140), geocoding (594), VIN format (344).

We are on track to resolve 3 of 9 issues by April 30; remaining issues targeted for resolution by May 15.

FINANCIAL IMPACT:
- Regulatory Risk: HIGH (HB 2067 TDI report deadline June 15, 2026)
- Financial Exposure: $25,000–$100,000 (estimated penalty if non-compliant)
- Reputational Risk: Market conduct audit findings will be public

PROGRESS TO DATE:
├─ Issues Detected: 1,302
├─ Issues Resolved: 2 (18%)
├─ Issues In Remediation: 7 (82%)
├─ ETA Full Resolution: May 15, 2026 (27 days)
└─ Risk of Missing TDI Deadline (June 15): LOW (12-day buffer remaining)

RECOMMENDATION:
Allocate additional resources to accelerate HB 2067 remediation.
Current pace (20 policies/day) insufficient; need 25–30 policies/day to ensure
timely resolution before June 15 TDI report deadline.

Prepared By: Daniel Rodriguez III, Data Quality Analyst II
Report Date: April 30, 2026
```

---

---

# SOP 7: Data Governance Execution and Data Dictionary Maintenance

**Objective:** Embed DAMA-DMBOK principles into daily operations to preserve metadata integrity and ensure governance standards are maintained.

**Scope:** Data Dictionary, naming standards, data inventory, GDPR/DORA compliance

**Frequency:** Updated as new fields introduced; quarterly governance review

**Responsibility:** Data Governance Committee (oversight); Data Quality Analyst II (maintenance)

---

## SOP 7.1: Dictionary Update Procedure

**When:** New field added to PolicyCenter, BillingCenter, or reference tables

**Workflow:**

1. **Capture Field Metadata:**
   - Field name: [Exact name as appears in system]
   - Data type: [VARCHAR, INT, DATE, DECIMAL, etc.]
   - Length/precision: [Maximum length or numeric scale]
   - Nullable: [YES/NO]
   - Business definition: [Plain English meaning]
   - Regulatory mapping: [TDI, HB 2067, GDPR/DORA applicability]

2. **Add to Data Dictionary:**
   - Update DOC_04_Comprehensive_Data_Dictionary.md
   - Add new row to table under corresponding source table or view
   - Include all mandatory metadata fields (see SOP 1.1 template)
   - Cross-reference with validation rules (if applicable)

3. **Create Validation Rule (if data-quality-related):**
   - Determine if field requires validation
   - If YES: Create new rule following DOC_05 process
   - If NO: Document rationale (why no validation needed?)

4. **Update Data Lineage:**
   - Document source → staging → cleansed path
   - Identify any transformations applied
   - Update data flow diagram in README.md

5. **Approval:**
   - Submit change to Data Governance Committee
   - Review: Does definition clarify business meaning? Is lineage documented?
   - Approval required before field can be used in reports/dashboards

6. **Communication:**
   - Notify stakeholders of new field: Update email + wiki post
   - Include definition, usage guidance, and any restrictions
   - Update data quality training materials if field impacts compliance

---

## SOP 7.2: Naming Standards Enforcement

**Guidewire PolicyCenter:**

```
Policy Fields:
  └─ Prefix: "Policy"
  └─ Format: PascalCase (e.g., PolicyNumber, PolicyStatus, EffectiveDate)
  └─ Reserved: Do NOT use: policy, POLICY, policy_

Location Fields:
  └─ Prefix: "Location" or dedicated field name
  └─ Format: PascalCase (e.g., LocationID, Latitude, Longitude)
  
Date Fields:
  └─ Format: YYYYMMDD or YYYY-MM-DD (ISO 8601)
  └─ Suffix: "Date" or "Timestamp"
  └─ Examples: EffectiveDate, CancellationDate, CreateTimestamp

Amount/Financial Fields:
  └�� Format: DECIMAL(10,2) with explicit "$" or currency indicator in definition
  └─ Suffix: "Amount" or "Premium"
  └─ Examples: TotalPremium, AdjustmentAmount, CommissionAmount
```

**Reference Tables:**

```
Master Data Format:
  └─ TableName: [Domain]_Master or [Domain]_Reference
  └─ Examples: Agent_Master, TDI_Reason_Mapping, County_Reference
  └─ Primary Key: [Domain]ID (e.g., AgentID, TDICode, CountyCode)

Lookup Tables:
  └─ Format: [Entity]_[Lookup] (e.g., Policy_Status_List)
  └─ Contents: Valid values, descriptions, effective dates
```

**Cleansed Views:**

```
Golden Layer Views:
  └─ Prefix: "vw_" (indicating view)
  └─ Format: vw_[SourceTable]_cleansed
  └─ Examples:
     ├─ vw_pc_policyperiod_cleansed
     ├─ vw_pc_policylocation_cleansed
     ├─ vw_pc_vehicle_cleansed
     └─ vw_financial_reconciliation
```

---

## SOP 7.3: Data Inventory & Record of Processing Activities (RoPA)

**GDPR/DORA Compliance Requirement:**

Maintain Record of Processing Activities documenting:

```
For Each Data Category:

1. DATA DESCRIPTION
   ├─ Category: [Underwriting Data, Policyholder Personal Data, Financial Data]
   ├─ Examples: PolicyNumber, AgentID, Premium, VIN, Latitude/Longitude
   ├─ Volume: [Approximate count] policies/records
   └─ Data Classification: [Public, Internal, Confidential, PII, PHI]

2. PROCESSING PURPOSE
   ├─ Primary: [Insurance underwriting, rate-setting, claims handling]
   ├─ Secondary: [Data quality validation, HB 2067 compliance reporting]
   ├─ Legal Basis: [Customer consent, legal obligation, business necessity]
   └─ Lawful Basis: [Contract performance, regulatory compliance, vital interests]

3. DATA RETENTION
   ├─ Retention Period: [7 years for underwriting; 3 years for issues log]
   ├─ Destruction Method: [Secure deletion, data purge]
   ├─ Exemptions: [Audit records retained indefinitely for compliance]
   └─ Archival: [Historical views retained for trend analysis]

4. TECHNICAL SAFEGUARDS
   ├─ Encryption: [At rest in BigQuery; in transit via HTTPS]
   ├─ Access Control: [Role-based access (RBAC); multi-factor authentication]
   ├─ Audit Logging: [All data access logged; reviewed quarterly]
   ├─ Backup: [Daily snapshots; 90-day retention]
   └─ Disaster Recovery: [Replicated across geographic regions]

5. PERSONNEL & RESPONSIBILITIES
   ├─ Data Controller: [Texas Farm Bureau Casualty Insurance Company]
   ├─ Data Owner: [Underwriting Manager for underwriting data]
   ├─ Custodian: [Data Quality Analyst II; Database Administrator]
   ├─ Security Officer: [Chief Information Security Officer]
   └─ DPA Contact: [Legal department for data protection inquiries]

6. RISK ASSESSMENT
   ├─ PII Risk: [MEDIUM – Contains policyholder addresses, VINs]
   ├─ Breach Consequence: [Customer notification required; potential credit monitoring]
   ├─ Regulatory Risk: [HIGH – HB 2067 compliance; TDI market conduct exam]
   └─ Mitigation: [Encryption, access controls, data quality validation]
```

**RoPA Update Schedule:**

- **Initial Capture:** When new data category introduced
- **Annual Review:** Verify retention policies still appropriate
- **Event-Driven:** If data breach occurs or regulations change
- **Compliance Audit:** Quarterly (check completeness & accuracy)

---

---

# SOP 8: SDLC Support and Release Readiness

**Objective:** Ensure data integrity is maintained through system updates and cloud releases by validating changes before deployment.

**Scope:** Guidewire PolicyCenter, BillingCenter, Informatica IDMC, BigQuery updates

**Frequency:** Prior to each Guidewire release (monthly); as-needed for other platforms

**Responsibility:** Data Quality Analyst II (testing); Guidewire Implementation Lead (coordination)

---

## SOP 8.1: Pre-Release Assessment

**Step 1: Review Release Notes**

When Guidewire notifies of upcoming Olos release:

1. **Data Model Changes:**
   - Are any policy-related fields being added/removed/modified?
   - Are validation endpoints being updated?
   - Are any workflows changing (e.g., cancellation, rating)?

2. **System Architecture Changes:**
   - Will performance impact data load times?
   - Are any APIs changing that integrate with Informatica?
   - Will data types change (e.g., VARCHAR length, numeric precision)?

3. **Regulatory/Compliance Changes:**
   - Does release impact HB 2067 compliance?
   - Any changes to TDI reporting data mapping?
   - Any security enhancements or encryption changes?

4. **Risk Assessment:**
   - HIGH RISK: Policy binding changes, cancellation logic changes, validation endpoint changes
   - MEDIUM RISK: Performance enhancements, UI updates, reporting changes
   - LOW RISK: Bug fixes, security patches, third-party library updates

---

## SOP 8.2: Test Case Development

**Step 1: Identify Test Scenarios**

For each risky change in release notes, create test cases:

```
RELEASE: Guidewire Olos - April 2026 Maintenance Update

Change 1: Reason Code Validation Endpoint Enhancement
├─ Description: New validation endpoint support for policy cancellation
├─ Risk Level: HIGH (affects HB 2067 compliance)
├─ Test Case 1.1: Create canceled policy with valid reason code → Should succeed
├─ Test Case 1.2: Create canceled policy without reason code → Should fail (error message)
├─ Test Case 1.3: Create canceled policy with invalid reason code → Should fail (error message)
├─ Test Case 1.4: Bulk import 1,000 policies with reason codes → Should succeed
├─ Test Case 1.5: Bulk import 100 policies without codes → Should fail with summary report
└─ Expected Result: Validation endpoint blocks non-compliant policies

Change 2: Performance Optimization in Rating Engine
├─ Description: Improved query performance for premium calculation
├─ Risk Level: MEDIUM
├─ Test Case 2.1: Rate 10,000 policies; measure execution time (baseline vs. new)
├─ Test Case 2.2: Verify premium amounts unchanged (validate calculation accuracy)
├─ Test Case 2.3: Check that all 19 validation rules still execute without errors
└─ Expected Result: Faster rating with identical premium calculations

Change 3: BigQuery Integration Update
├─ Description: Enhanced streaming ingestion for real-time data
├─ Risk Level: MEDIUM
├─ Test Case 3.1: Create new policy; verify appears in BigQuery within 30 seconds
├─ Test Case 3.2: Update policy status; verify change reflected in BigQuery within 30 seconds
├─ Test Case 3.3: Bulk load 5,000 policies; verify all records present in BigQuery
├─ Test Case 3.4: Network failure scenario; verify retry logic works
└─ Expected Result: Real-time data available in BigQuery with 100% accuracy
```

---

## SOP 8.3: Staging Environment Testing

**Execution (Prior to Production Release):**

1. **Deploy to Staging:**
   - Apply release to staging environment (mirrors production)
   - Run automated build validation (schema validation, DDL syntax check)
   - Verify data warehouse schema changes apply without errors

2. **Execute Test Cases:**
   - Run manual test cases against staging environment
   - Verify results match expectations
   - Document any failures or unexpected behavior

3. **Data Quality Validation:**
   - Execute all 19 validation rules (VR-001-001 through VR-005-001)
   - Compare violation rates pre/post-release
   - Verify no new violations introduced by release

4. **Regression Testing:**
   - Re-run baseline profiling queries (SQL_01–04)
   - Compare current metrics to pre-release baseline
   - Alert if any baseline KPIs degraded

5. **Performance Testing:**
   - Measure query execution times for key reports
   - Verify ETL/batch processing still completes within SLA
   - Monitor resource utilization (CPU, memory, network)

6. **Sign-Off:**
   - If all tests pass: Release approved for production
   - If any test fails: Document failure; decide: re-test, patch, or rollback plan

---

## SOP 8.4: Production Release & Monitoring

**Pre-Release Checklist:**

```
☐ Release notes reviewed by Data Governance Committee
☐ Staging testing completed with 0 critical failures
☐ Baseline metrics established (pre-release)
☐ Data Quality Analyst on-call during deployment
☐ Rollback plan documented (if issues arise)
☐ Stakeholders notified of deployment window
☐ Backup taken before deployment
☐ Data Governance Committee quorum available for escalation
```

**Deployment Window (Typically 10:00 PM – 12:00 AM):**

1. **Pre-Deployment:**
   - Final backup of all data
   - Record baseline metrics
   - Notify on-call team

2. **Deployment:**
   - Apply release to production
   - Monitor deployment logs for errors
   - Verify schema changes applied successfully

3. **Post-Deployment (First 4 Hours):**
   - Execute smoke tests (basic functionality)
   - Monitor Informatica/ETL jobs for failures
   - Check application event logs for errors
   - Execute key profiling queries; compare to baseline

4. **First 24 Hours:**
   - Monitor violation rates; alert if > 10% increase
   - Track ETL job completion times; alert if > SLA
   - Review user error logs in PolicyCenter
   - Daily check-in with stakeholders

5. **Rollback Scenario (if critical issue discovered):**
   - Decision: Patch or rollback?
   - If rollback: Restore from pre-release backup
   - If patch: Schedule emergency fix with vendor
   - Root cause analysis required; prevent recurrence

---

---

## Appendix A: Job Schedules & Contacts

### Daily Job Schedule

```
TIME            JOB NAME                            OWNER               STATUS
──────────────────────────────────────────────────────────────────────────────
6:00 AM         Morning Dashboard Review            Data Quality        Monitor
6:30 AM         Data Quality Scorecard Refresh      Power BI (automated) Verify
7:00 AM         Executive Email Summary             Data Quality        Send
10:15 AM        Profiling Query Execution           Data Quality        Execute
10:45 AM        Validation Rule Batch (if needed)   SQL Server Agent    Monitor
11:00 PM        Nightly Batch ETL Load              Informatica         Monitor
11:00 PM        Data Quality Validation Batch       SQL Server Agent    Monitor
12:30 AM        Threshold Evaluation                Data Quality        Alert (if needed)
1:00 AM         Issues Log Export                   Automated           Archive
```

### Weekly Schedule

```
MONDAY 9:00 AM    Data Governance Committee Meeting
  ├─ Scorecard review
  ├─ Remediation progress tracking
  ├─ RCA discussion
  └─ Action item assignment

FRIDAY 3:00 PM    Week-End Summary Preparation
  ├─ Compile metrics
  ├─ Trend analysis
  └─ Prepare Monday agenda
```

### Contact Directory

```
ROLE                              NAME                    EMAIL               PHONE
──────────────────────────────────────────────────────────────────────────────
Data Quality Analyst II           Daniel Rodriguez III    d.rodriguez@...     Ext 5555
Underwriting Manager              [Name]                  [email]             Ext [X]
Data Governance Committee Chair   [Name]                  [email]             Ext [X]
Compliance Officer                [Name]                  [email]             Ext [X]
Guidewire Implementation Lead     [Name]                  [email]             Ext [X]
Informatica Administrator         [Name]                  [email]             Ext [X]
Database Administrator            [Name]                  [email]             Ext [X]

ESCALATION HOTLINE (24/7):        [Phone Number]
EMERGENCY EMAIL:                  DataQualityEmergency@tfbcas.com
```

---

## Appendix B: Decision Trees & Flowcharts

### SOP 1: Data Quality Lifecycle Decision Tree

```
        DATA ARRIVES
              ↓
      ┌───────────────┐
      │  PROFILING    │ (SQL_01-04: Establish baseline metrics)
      └───────────┬───┘
                  ↓
      ┌───────────────────┐
      │ VALIDATION RULE   │ (19 rules execute)
      │ EXECUTION         │
      └────┬──────────┬───┘
           │          │
        PASS         FAIL
         ↓            ↓
       ┌─┴─────────────┐
       │  THRESHOLD    │
       │  EVALUATION   │
       └─┬─────────────┘
         │
    ┌────┴─────────────────┐
    │                      │
PASS (< threshold)   FAIL (> threshold)
 │                        │
 ↓                        ↓
✓ OK               ┌──────────────┐
  Continue         │ AUTOMATED    │
  Processing       │ ALERT        │
                   └──────┬───────┘
                          ↓
                   ┌──────────────┐
                   │ ROUTE TO RCA │
                   │ (SOP 4)      │
                   └──────┬───────┘
                          ↓
                   ┌──────────────────────┐
                   │ CORRECTIVE ACTION    │
                   │ & REMEDIATION        │
                   └──────┬───────────────┘
                          ↓
                   ┌──────────────────────┐
                   │ RE-VALIDATION        │
                   │ (Verify Fix)         │
                   └──────┬───────────────┘
                          ↓
                   ┌──────────────────────┐
                   │ ISSUE CLOSURE        │
                   │ & COMMUNICATION      │
                   └─���────────────────────┘
```

### SOP 5: Severity Escalation Decision Tree

```
        VIOLATION DETECTED
              ↓
      ┌──────────────────┐
      │ SEVERITY LEVEL?  │
      └┬────────┬────────┬┘
       │        │        │
   CRITICAL   HIGH    MEDIUM
       │        │        │
       ↓        ↓        ↓
  ┌────────┐ ┌───────┐ ┌──────────┐
  │ Email  │ │ Email │ │ Archive  │
  │ Slack  │ │ (24h) │ │ in      │
  │ (NOW)  │ │       │ │ Summary  │
  │ 1-4h   │ │  RCA  │ │          │
  │ RCA    │ │       │ │          │
  └───┬────┘ └───┬───┘ └──────────┘
      ↓          ↓
   CRITICAL    HIGH
   DECISION    PRIORITY
   BY EXEC     PROCESSING
```

---

## Appendix C: Templates & Forms

### Template 1: RCA Post-Mortem Report

[See SOP 4.5 for complete template – 1-page version included in SOP document]

### Template 2: Exception Request Form

```
╔════════════════════════════════════════════════════════════════╗
║           DATA QUALITY EXCEPTION REQUEST FORM                  ║
╚════════════════════════════════════════════════════════════════╝

REQUESTER INFORMATION:
  Name: ________________________    Date: ______________
  Department: ___________________    Email: _____________
  
EXCEPTION DETAILS:
  Rule ID: ________________________
  Rule Name: ______________________
  Violation Count: _________________
  
BUSINESS JUSTIFICATION:
  ┌──────────────────────────────────────────────────────────────┐
  │ Why is this exception legitimate? (plain English)            │
  │                                                              │
  │                                                              │
  │                                                              │
  └──────────────────────────────────────────────────────────────┘

PROPOSED RESOLUTION:
  Method: ☐ Auto-Fix  ☐ Manual Correction  ☐ Temporary Bypass  ☐ Other: ____
  Timeline: ________________    Owner: ____________________
  
RISK ASSESSMENT:
  Financial Impact: ☐ None  ☐ <$10K  ☐ $10-50K  ☐ >$50K
  Compliance Impact: ☐ None  ☐ Low  ☐ Medium  ☐ High  ☐ Critical
  Customer Impact: ☐ None  ☐ Low  ☐ Medium  ☐ High

APPROVAL WORKFLOW:
  ☐ Data Governance Committee approval required
  ☐ Compliance Officer sign-off required
  ☐ Executive escalation (if financial impact > $50K)

SUBMITTED BY (Requester Signature): _______________  Date: _______
APPROVED BY (DGC Chair): _________________  Date: _______
COMPLIANCE SIGN-OFF: ____________________  Date: _______

Exception Approved? ☐ YES  ☐ NO  ☐ CONDITIONAL (note: ____________)
Duration: Approved until ____________ (date or milestone)
```

---

**END OF SOP DOCUMENTATION**

---

## Document Control & Approval

| Element | Value |
|---------|-------|
| **Document ID** | DOC_06_Complete_SOP_Documentation |
| **Version** | 1.0 |
| **Date Created** | April 18, 2026 |
| **Last Reviewed** | April 18, 2026 |
| **Owner** | Data Governance Committee |
| **Custodian** | Daniel Rodriguez III, Data Quality Analyst II |
| **Classification** | Internal – Confidential |
| **Review Cycle** | Semi-annually (or as SOPs evolve) |
| **Next Review Date** | October 18, 2026 |

---

**For SOP clarifications or updates, contact the Data Governance Committee.**