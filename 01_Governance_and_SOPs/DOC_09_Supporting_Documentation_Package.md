# Supporting Documentation Package
## Complete Implementation Toolkit for Data Quality Excellence

**Document Owner:** Data Governance Committee  
**Author:** Daniel Rodriguez III, Data Quality Analyst II  
**Date:** April 18, 2026  
**Version:** 1.0  
**Classification:** Internal – Technical & Operational

---

## Table of Contents

1. [README & Quick-Start Guide](#readme--quick-start-guide)
2. [Comprehensive Data Dictionary](#comprehensive-data-dictionary)
3. [Architecture & Systems Integration Diagrams](#architecture--systems-integration-diagrams)
4. [Implementation Checklist](#implementation-checklist)
5. [Troubleshooting & FAQ](#troubleshooting--faq)
6. [Training Materials & Onboarding](#training-materials--onboarding)
7. [Change Management & Version Control](#change-management--version-control)
8. [Risk Register & Mitigation Strategies](#risk-register--mitigation-strategies)
9. [Compliance & Audit Evidence](#compliance--audit-evidence)
10. [Contact Directory & Escalation Procedures](#contact-directory--escalation-procedures)

---

---

# 1. README & Quick-Start Guide

## Project Overview

**Project Name:** TFB Underwriting Data Quality Lifecycle & HB 2067 Compliance Framework

**Organization:** Texas Farm Bureau Casualty Insurance Company

**Project Date:** April 2026

**Objective:** Establish comprehensive data quality governance framework ensuring House Bill 2067 statutory compliance, operational excellence, and regulatory audit readiness.

### What This Project Delivers

```
├─ OPERATIONAL FRAMEWORK
│  ├─ 8 Standard Operating Procedures (SOPs) with step-by-step execution
│  ├─ 19 Validation Rules (VR-001-001 through VR-005-001) with enforcement logic
│  ├─ Daily/Weekly/Monthly operational cadence with accountability
│  └─ Automated monitoring & alerting via SQL Server Agent + Informatica
│
├─ REGULATORY COMPLIANCE
│  ├─ HB 2067 Compliance Matrix mapping all 6 statutory requirements
│  ├─ Automated evidence collection for TDI audit readiness
│  ├─ Monthly/Quarterly TDI statistical report generation
│  └─ 7-year compliance evidence retention
│
├─ DATA QUALITY EXCELLENCE
│  ├─ 6-Dimension Quality Framework (Accuracy, Completeness, Consistency, etc.)
│  ├─ 15+ Profiling & KPI Queries for analytical depth
│  ├─ Real-time dashboards (Power BI) with automated alerting
│  └─ Root Cause Analysis procedures (SOP 4) for systematic improvement
│
├─ TECHNICAL INFRASTRUCTURE
│  ├─ BigQuery data warehouse (raw + cleansed layers)
│  ├─ Informatica IDMC for ETL & data quality orchestration
│  ├─ Guidewire Olos integration (PolicyCenter binding controls)
│  ├─ SQL Server job scheduling (nightly validation runs)
│  └─ Git version control for all code & documentation
│
└─ GOVERNANCE & ACCOUNTABILITY
   ├─ Data Governance Committee oversight
   ├─ Role-based responsibilities (DQ Analyst, Underwriting Manager, etc.)
   ├─ Escalation procedures (1-4 hour CRITICAL; 24-hour HIGH)
   └─ Executive management certifications
```

---

## Quick-Start Execution

### Day 1: Assess Current State

**Objective:** Understand baseline data quality before implementing controls

**Execution (2 hours):**

1. **Execute Baseline Profiling Queries** (15 min)
   ```bash
   # Run SQL_01–04 (Profiling suite)
   bq query --use_legacy_sql=false < SQL_01_HB2067_Compliance_Check.sql
   bq query --use_legacy_sql=false < SQL_02_Referential_Integrity_Check.sql
   bq query --use_legacy_sql=false < SQL_03_Data_Standards_VIN_Check.sql
   bq query --use_legacy_sql=false < SQL_04_Geocoding_Completeness_Check.sql
   
   # Review results → Captures baseline violation counts
   ```

2. **Review DOC_01 Role Enhancement** (30 min)
   - Understand organizational context
   - Identify stakeholders & responsibilities

3. **Review DOC_05 Validation Rules Registry** (45 min)
   - Understand 19 rules (VR-001-001 through VR-005-001)
   - Identify rules applicable to your business

4. **Generate Data Quality Scorecard** (15 min)
   ```bash
   bq query --use_legacy_sql=false < SQL_09_Final_DQ_Scorecard_Metrics.sql
   
   # Expected: 6-dimension baseline (Accuracy 93.43%, Completeness 97.85%, etc.)
   ```

**Output:** Baseline DQ Scorecard showing current state across 6 dimensions

---

### Week 1: Deploy Validation Rules

**Objective:** Activate automated data quality monitoring

**Execution (40 hours):**

1. **Deploy SQL Validation Rules** (16 hours)
   - Create SQL Server Agent job: `DQ_Validation_Batch_Daily`
   - Schedule for 11:00 PM (after batch data load)
   - Verify all 19 rules execute without errors
   - Check vw_automated_issues_log for violations

2. **Activate Informatica CDI Rules** (12 hours)
   - Deploy real-time validation endpoints (VR-001-001, VR-002-003)
   - Configure PolicyCenter integration
   - Test on staging environment
   - Enable in production

3. **Configure Guidewire Validation Endpoints** (8 hours)
   - Update PolicyCenter binding logic for mandatory reason codes
   - Deploy Olos configuration
   - Test end-to-end policy creation → binding

4. **Establish Alerting & Escalation** (4 hours)
   - Configure Slack notifications for CRITICAL/HIGH issues
   - Set up email alerts to stakeholders
   - Test alert routing

**Output:** Automated validation running daily with 24/7 monitoring active

---

### Week 2: Implement Cleansed Views & Remediation

**Objective:** Create golden layer for HB 2067 compliance

**Execution (30 hours):**

1. **Deploy Cleansed Views** (10 hours)
   ```sql
   -- Deploy DDL_01–04 (Cleansed layer views)
   CREATE OR REPLACE VIEW vw_pc_policyperiod_cleansed AS
     SELECT ... (with remediation logic applied)
   
   CREATE OR REPLACE VIEW vw_pc_policylocation_cleansed AS
     SELECT ... 
   
   -- Views apply business logic without modifying source data
   -- Audit trail preserved: Remediation_Status flag indicates ORIGINAL vs. REMEDIATED
   ```

2. **Implement RCA Procedures** (10 hours)
   - SOP 4: Root Cause Analysis training
   - Set up RCA post-mortem template
   - Establish RCA intake workflow

3. **Create TDI Reference Tables** (5 hours)
   - Load TDI_Reason_Mapping (17 codes: A–X)
   - Load Agent_Master, County_Reference, etc.
   - Verify reference data completeness

4. **Establish Data Governance Committee** (5 hours)
   - First meeting: Review compliance matrix, SOP overview
   - Assign stakeholders & responsibilities
   - Schedule weekly Monday 9:00 AM meetings

**Output:** Cleansed views active; remediation procedures established; governance committee meeting weekly

---

### Week 3: Prepare Q2 TDI Report (June 15 Deadline)

**Objective:** Generate compliant statistical report for TDI submission

**Execution (35 hours):**

1. **Retroactive Data Capture** (15 hours)
   - SOP 5: Identify pre-April 1 notices with post-April 1 effective dates
   - Assign retroactive reason codes from case notes
   - Update pc_policyperiod.CancellationReasonCode field
   - Validate against TDI_Reason_Mapping

2. **Generate Q2 Report** (12 hours)
   - SQL extract: Policies with CancellationDate in April–May 2026
   - Aggregate by ZIP code + reason codes (concatenated alphabetically)
   - Format per TDI statistical plan specifications
   - Validate against 1% error threshold

3. **TDI Report Validation & Testing** (5 hours)
   - Schema validation (all required columns present)
   - Value validation (only A–X codes, valid ZIPs)
   - MCAS reconciliation (count verification)
   - Spot-check 10 records manually

4. **TDI Submission Process** (3 hours)
   - Login to TDI EDGAR system
   - Upload formatted report file
   - Verify TDI confirmation receipt
   - Archive submission + receipt for 7-year retention

**Output:** Q2 TDI report submitted by June 15, 2026 deadline; confirmation receipt archived

---

### Month 1: Stabilize & Optimize

**Objective:** Ensure sustainable operations; optimize based on early learnings

**Execution (40 hours):**

1. **Stabilization & Tuning** (15 hours)
   - Monitor daily validation run times (target: < 30 min)
   - Tune slow queries (add indexes if needed)
   - Validate false positive rates (should be 0%)
   - Adjust alert thresholds based on actual distribution

2. **RCA & Remediation of Baseline Issues** (15 hours)
   - SOP 4: Execute RCAs for 3 major violations (HB 2067, VIN, Geocoding)
   - Develop corrective action plans
   - Track remediation progress toward resolution

3. **Documentation & Knowledge Transfer** (7 hours)
   - Create runbooks for common operations
   - Train Underwriting/Operations teams on new procedures
   - Document lessons learned
   - Update SOPs based on feedback

4. **Governance & Compliance** (3 hours)
   - Quarterly risk assessment (identify emerging issues)
   - Executive management certification of compliance status
   - Plan Phase 2 (commercial lines HB 2067 expansion)

**Output:** Stable operational baseline; most violations understood; team trained; on-track for ongoing compliance

---

## Directory Structure

```
TFB-Underwriting-Data-Quality-Lifecycle-/
├─ README.md (this file)
│
├─ 01_Governance_and_SOPs/
│  ├─ DOC_01_Data_Analyst_II_Role_Enhancement.md
│  ├─ DOC_02_TFB_Data_Quality_Analyst_JD.md
│  ├─ DOC_03_Data_Dictionary_Cleansed_Layer.md
│  ├─ DOC_04_Comprehensive_Data_Dictionary.md (full)
│  ├─ DOC_05_Validation_Rules_Registry.md
│  ├─ DOC_06_Complete_SOP_Documentation.md
│  ├─ DOC_07_HB2067_Compliance_Matrix.md
│  ├─ DOC_08_Extended_Profiling_KPI_Queries.md
│  ├─ DOC_09_Supporting_Documentation_Package.md (this)
│  ├─ Executive_Brief_Dashboard.pptx
│  ├─ Data_Governance_Charter.pdf
│  └─ Change_Control_Log.xlsx
│
├─ 02_Data_Lineage_and_Metadata/
│  ├─ Data_Flow_Diagram.drawio
│  ├─ System_Integration_Architecture.pdf
│  ├─ Metadata_Repository.xlsx
│  ├─ TDI_Reason_Mapping.csv
│  ├─ Agent_Master_Reference.csv
│  └─ County_Reference_Geocodes.csv
│
├─ 03_Validation_and_Profiling_SQL/
│  ├─ Profiling/
│  │  ├─ SQL_01_HB2067_Compliance_Check.sql
│  │  ├─ SQL_02_Referential_Integrity_Check.sql
│  │  ├─ SQL_03_Data_Standards_VIN_Check.sql
│  │  ├─ SQL_04_Geocoding_Completeness_Check.sql
│  │  └─ SQL_Execution_Log.xlsx
│  │
│  ├─ Validation_Rules/
│  │  ├─ VR_001_001_HB2067_Reason_Code.sql
│  │  ├─ VR_002_003_TDI_Mapping.sql
│  │  ├─ VR_003_001_VIN_Format.sql
│  │  ├─ VR_005_001_Coastal_Geocoding.sql
│  │  └─ [15 total validation rules]
│  │
│  ├─ Cleansed_Views/
│  │  ├─ DDL_01_PC_PolicyPeriod_Cleansed.sql
│  │  ├─ DDL_02_PC_Location_Cleansed.sql
│  │  ├─ DDL_03_PC_Vehicle_Cleansed.sql
│  │  ├─ DDL_04_Financial_Reconciliation.sql
│  │  └─ Materialized_View_Refresh_Schedule.txt
│  │
│  └─ [More validation & profiling scripts]
│
├─ 04_Root_Cause_Analysis_SQL/
│  ├─ SQL_05_RCA_HB2067_Temporal_Spread.sql
│  ├─ SQL_06_RCA_Orphan_Trace.sql
│  ├─ SQL_07_RCA_Catastrophe_Geo_Cluster.sql
│  ├─ SQL_08_RCA_Financial_Premium_Drift.sql
│  └─ RCA_Post_Mortem_Template.docx
│
├─ 05_Remediation_Scripts/
│  ├─ Remediate_HB2067_Missing_Codes.sql
│  ├─ Remediate_VIN_Standardization.sql
│  ├─ Remediate_Geocoding_Coastal.sql
│  ├─ Remediate_Orphan_Locations.sql
│  └─ Remediation_Execution_Log.xlsx
│
├─ 06_Data_Quality_Scorecard/
│  ├─ SQL_09_Final_DQ_Scorecard_Metrics.sql
│  ├─ DQ_Scorecard_Daily_2026-04-18.xlsx
│  ├─ Power_BI_Dashboard_Definition.json
│  ├─ KPI_Historical_Trend.xlsx (30-day)
│  └─ Dashboard_Screenshots.pdf
│
├─ 07_Presentations_and_Dashboards/
│  ├─ DOC_05_Executive_Brief.md
│  ├─ Executive_Dashboard_Mockup.pptx
│  ├─ Data_Governance_Committee_Slides.pptx
│  ├─ Stakeholder_Communication_Email_Templates.docx
│  └─ Monthly_DQ_Report_Template.docx
│
├─ 08_Testing_and_Validation/
│  ├─ Test_Plan_Validation_Rules.xlsx
│  ├─ Test_Cases_HB2067_Compliance.xlsx
│  ├─ Test_Results_April_2026.xlsx
│  ├─ UAT_Sign_Off_Forms.pdf
│  └─ Regression_Test_Suite.sql
│
├─ 09_Training_and_Onboarding/
│  ├─ Onboarding_Checklist_New_DQ_Analyst.pdf
│  ├─ Training_Deck_SOP_Overview.pptx
│  ├─ Runbook_Daily_Operations.pdf
│  ├─ Runbook_Emergency_Procedures.pdf
│  ├─ Glossary_Data_Quality_Terms.docx
│  └─ Video_Tutorials (links to screen recordings)
│
├─ 10_Compliance_and_Audit/
│  ├─ HB2067_Regulatory_Citations.pdf
│  ├─ TDI_Statistical_Plan_Specifications.pdf
│  ├─ Compliance_Evidence_Checklist.xlsx
│  ├─ Audit_Trail_Evidence_Log.xlsx
│  ├─ Management_Compliance_Certifications.pdf
│  ├─ MCAS_Reconciliation_Workpaper.xlsx
│  └─ Internal_Audit_Findings_Log.xlsx
│
├─ 11_Risk_and_Change_Management/
│  ├─ Risk_Register.xlsx
│  ├─ Mitigation_Strategy_Playbook.pdf
│  ├─ Change_Control_Form_Template.docx
│  ├─ Change_Log_2026.xlsx
│  ├─ Impact_Assessment_Template.docx
│  └─ Rollback_Procedures.pdf
│
├─ 12_Infrastructure_and_Configuration/
│  ├─ BigQuery_Dataset_Schema.sql
│  ├─ SQL_Server_Agent_Job_Configuration.txt
│  ├─ Informatica_IDMC_Workflow_Export.xml
│  ├─ Guidewire_PolicyCenter_Validation_Config.pdf
│  ├─ Database_Indexes_Optimization.sql
│  └─ Network_and_Firewall_Requirements.txt
│
└─ .github/
   ├─ workflows/
   │  ├─ daily_dq_validation.yml
   │  ├─ weekly_compliance_report.yml
   │  └─ monthly_tdi_reporting.yml
   └─ pull_request_template.md
```

---

---

# 2. Comprehensive Data Dictionary

## Complete Field-Level Metadata

```markdown
## pc_policyperiod Table

| Column Name | Data Type | Nullable | Business Definition | TDI Mapping | Validation Rule | Notes |
|---|---|---|---|---|---|---|
| PolicyNumber | VARCHAR(20) | NO | Unique policy identifier | Required | VR-001-002 | Primary key; format: POL-XXXXXXX |
| Status | VARCHAR(20) | NO | Current policy state (Active, Canceled, NonRenewed, Declined, Draft, Withdrawn, Suspended) | Not mapped | VR-002-002 | Dropdown list in PolicyCenter; no free text |
| EffectiveDate | DATE | NO | Policy inception date | Not directly mapped | VR-002-002 | Must be <= ExpirationDate |
| ExpirationDate | DATE | NO | Policy termination date | Not directly mapped | VR-002-002 | Must be >= EffectiveDate |
| CancellationDate | DATE | YES | When policy status changed to Canceled | Derived from action effective date | VR-002-002 | Required if Status = 'Canceled' |
| CancellationReasonCode | VARCHAR(10) | YES | Internal reason for cancellation/decline/non-renewal | Maps to TDI Code (A–X) via lookup | VR-001-001, VR-002-003 | **CRITICAL for HB 2067**: Must be populated if Status IN ('Canceled', 'NonRenewed', 'Declined') |
| AgentID | VARCHAR(10) | NO | Insurance agent responsible for policy | Not directly mapped | VR-001-002 | Foreign key to Agent_Master; must be active/licensed |
| TotalPremium | DECIMAL(10,2) | NO | Total policy premium | Not mapped; used for financial reconciliation | VR-002-001 | Must be > 0.00; validated against BillingCenter |
| CreateTime | TIMESTAMP | NO | When record created in system | Not mapped | N/A | Used for data aging/freshness assessment |
| UpdateTime | TIMESTAMP | NO | When record last modified | Not mapped | N/A | Used for change tracking |
| IsMostRecentModel | BOOLEAN | NO | Flag indicating if record is latest version (vs. historical) | Not mapped | Implicit | Always filter WHERE IsMostRecentModel = 1 in queries |

## pc_policylocation Table

| Column Name | Data Type | Nullable | Business Definition | TDI Mapping | Validation Rule | Notes |
|---|---|---|---|---|---|---|
| Location_ID | VARCHAR(20) | NO | Unique location identifier | Not mapped | VR-004-001 | Primary key |
| LocationNumber | INT | NO | Sequential location number (1st, 2nd location on policy) | Not mapped | N/A | Used for address sequencing |
| BranchID | VARCHAR(20) | NO | Foreign key to parent policy (pc_policyperiod.ID) | Not mapped | VR-004-001 | **CRITICAL**: Every location must have valid parent policy |
| AddressLine1 | VARCHAR(100) | NO | Street address | Not mapped | VR-004-001 | Required for underwriting |
| City | VARCHAR(50) | NO | City name | Not mapped | N/A | Standardized against USPS city list |
| County | VARCHAR(50) | NO | Texas county name | Not mapped | VR-005-001 | Required; used for geographic segmentation |
| State | VARCHAR(2) | NO | State abbreviation (TX) | Not mapped | N/A | Filtered to TX only |
| ZipCode | VARCHAR(5) | YES | 5-digit postal ZIP code | Not mapped | VR-003-002 | Format validation: ^[0-9]{5}$ |
| Latitude | DECIMAL(9,6) | YES | Geographic latitude (decimal degrees) | Not mapped | VR-005-001 | **REQUIRED for coastal counties** (Harris, Galveston, Nueces, Cameron) |
| Longitude | DECIMAL(10,6) | YES | Geographic longitude (decimal degrees) | Not mapped | VR-005-001 | **REQUIRED for coastal counties** |
| Geo_Health_Status | VARCHAR(20) | NO (cleansed view) | Data quality flag (GEOCODE_VALID, GEOCODE_REQUIRED, GEOCODE_MISSING) | Not mapped | VR-005-001 | Populated in cleansed view; indicates remediation status |

## TDI_Reason_Mapping Reference Table

| Column Name | Data Type | Nullable | Business Definition | Example | Notes |
|---|---|---|---|---|---|
| InternalCode | VARCHAR(20) | NO | Texas Farm Bureau internal reason code | 'UnderwritingDeny', 'RoofCondition', 'INT_99' | Primary key; maps to PolicyCenter reason codes |
| TDICode | VARCHAR(1) | NO | TDI statutory reason code (A–X) | 'D', 'K', 'L' | One-to-one mapping; strictly A–X range |
| ReasonDescription | VARCHAR(200) | NO | Human-readable description of reason | 'Underwriting – Physical condition of property' | For customer-facing notice template |
| ApplicableTo | VARCHAR(10) | NO | Which action types can use this code | 'C,NR,D' (Cancellation, Non-Renewal, Declination) | 'C' only, 'NR' only, or 'C,NR,D' (variable by code) |
| EffectiveDate | DATE | NO | When mapping became valid | '2026-04-01' | Used for retroactive compliance capture |
| CreatedBy | VARCHAR(50) | NO | User who created mapping | 'drodriguez' | Audit trail |
| CreatedDate | DATE | NO | When mapping was created | '2026-03-15' | Audit trail |

## Cleansed View: vw_pc_policyperiod_cleansed

| Column Name | Data Type | Source | Definition | Remediation Logic |
|---|---|---|---|---|
| PolicyNumber | VARCHAR(20) | pc_policyperiod | Same as source | Direct pass-through |
| Status | VARCHAR(20) | pc_policyperiod | Same as source | Direct pass-through |
| CancellationReasonCode | VARCHAR(10) | pc_policyperiod | Original internal reason code | Preserved for audit trail |
| Cleansed_TDICode | VARCHAR(20) | TDI_Reason_Mapping | TDI-compliant code (A–X) | Mapped via LEFT JOIN to TDI_Reason_Mapping; defaults to 'K' if unmapped |
| Remediation_Status | VARCHAR(20) | N/A (calculated) | ORIGINAL or REMEDIATED | 'ORIGINAL' if CancellationReasonCode NOT NULL; 'REMEDIATED' if null→'K' applied |
| Remediation_Timestamp | TIMESTAMP | N/A (calculated) | When remediation applied | Timestamp of view query execution |

---

```

---

---

# 3. Architecture & Systems Integration Diagrams

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                       DATA QUALITY LIFECYCLE                             │
└─────────────────────────────────────────────────────────────────────────┘

SOURCE SYSTEMS
├─ Guidewire PolicyCenter (Real-time transaction system)
│  └─ Policy status changes → Informatica CDC → BigQuery (raw)
│
├─ Guidewire BillingCenter (Financial system)
│  └─ Nightly batch load → Informatica ETL → BigQuery (raw)
│
├─ Agent Master (Reference)
│  └─ Daily refresh → Reference table
│
└─ TDI Statistical Tables (Regulatory)
   └─ Manual import → Reference validation

                           ↓

INGESTION & STAGING (Layer 1)
├─ BigQuery raw_underwriting_data schema
│  ├─ pc_policyperiod (staging table)
│  ├─ pc_policylocation (staging table)
│  ├─ pc_vehicle (staging table)
│  ├─ bc_policy (staging table)
│  └─ vw_automated_issues_log (violations registry)
│
└─ Real-time Informatica CDI streams for HB 2067 critical data

                           ↓

VALIDATION & PROFILING (Layer 2)
├─ SQL_01–04: Baseline profiling queries (detect anomalies)
├─ VR-001-001 through VR-005-001: 19 validation rules
│  ├─ Real-time endpoints (Guidewire PolicyCenter binding)
│  ├─ Nightly batch SQL queries (SQL Server Agent)
│  └─ Informatica CDQ rules (streaming validation)
│
└─ Violations logged to vw_automated_issues_log
   ├─ CRITICAL violations → Immediate Slack alert + email
   ├─ HIGH violations → 24-hour investigation
   └─ MEDIUM violations → Weekly summary

                           ↓

ROOT CAUSE ANALYSIS (Layer 3)
├─ SQL_05–08: RCA queries (temporal, geographic, financial analysis)
├─ SOP 4 Post-Mortem Documentation
├─ Corrective Action Planning
└─ Cross-team Investigation (Guidewire, IT, Business)

                           ↓

REMEDIATION & GOLDEN LAYER (Layer 4)
├─ Cleansed Views (DDL_01–04)
│  ├─ vw_pc_policyperiod_cleansed
│  │  └─ Maps CancellationReasonCode → TDI code (A–X)
│  │  └─ Flags: ORIGINAL vs. REMEDIATED
│  │
│  ├─ vw_pc_policylocation_cleansed
│  │  └─ Flags geocoding completeness
│  │
│  ├─ vw_pc_vehicle_cleansed
│  │  └─ Standardizes VIN format (17 alphanumeric)
│  │
│  └─ vw_financial_reconciliation
│     └─ Quantifies PC vs. BC variance
│
├─ Bulk Remediation Scripts (if needed)
│  └─ SQL UPDATE statements (logged for audit trail)
│
└─ Audit Trail Preserved: Original data + remediation flag + timestamp

                           ↓

REPORTING & DASHBOARDS (Layer 5)
├─ SQL_09: DQ Scorecard (6 dimensions)
│  ├─ Accuracy 93.43% ⚠️ BELOW TARGET
│  ├─ Completeness 97.85% ⚠️ BELOW TARGET
│  ├─ Consistency 59.20% 🔴 CRITICAL
│  ├─ Timeliness 98.00% ✓ OK
│  ├─ Validity 94.71% ⚠️ BELOW TARGET
│  └─ Integrity 99.60% ✓ OK
│
├─ Power BI Dashboard (Real-time)
│  ├─ KPI tiles (6 dimensions + overall score)
│  ├─ Trend sparklines (7-day, 30-day)
│  ├─ Violation breakdown by category
│  └─ Geographic heatmaps (quality by county)
│
└─ TDI Statistical Report (Monthly/Quarterly)
   ├─ Reason codes aggregated by ZIP
   ├─ Action type counts (C, NR, D)
   ├─ 60-day indicator verification
   └─ Submitted to TDI EDGAR system

                           ↓

MONITORING & ALERTING (Continuous)
├─ Nightly Batch Summary (12:30 AM email)
├─ Real-time Slack alerts (violations > threshold)
├─ Weekly Data Governance Committee review (Mon 9 AM)
├─ Monthly Executive Summary (end-of-month)
└─ Quarterly Risk Assessment (with mitigation updates)
```

---

## System Integration Points

```
POLICY CENTER (Guidewire)
    ↓
    ├─ Validation Endpoint (VR-001-001, VR-002-001)
    │  └─ Mandatory CancellationReasonCode field
    │  └─ Blocks policy binding if reason missing (HB 2067)
    │
    └─ Real-time CDC (Change Data Capture)
       └─ Streams policy status changes to Informatica
       └─ Triggers reason code validation (VR-001-001)
       └─ Logs to vw_automated_issues_log if violation

BIG QUERY (Data Warehouse)
    ↓
    ├─ Raw Layer (staging tables)
    │  ├─ pc_policyperiod (incremental refresh)
    │  ├─ pc_policylocation (incremental refresh)
    │  └─ pc_vehicle (incremental refresh)
    │
    ├─ Cleansed Layer (curated views)
    │  ├─ vw_pc_policyperiod_cleansed
    │  ├─ vw_pc_policylocation_cleansed
    │  └─ vw_financial_reconciliation
    │
    └─ Metadata Layer (reference tables)
       ├─ TDI_Reason_Mapping (A–X codes)
       ├─ Agent_Master (licensed agents)
       ├─ County_Reference (TX counties)
       └─ vw_automated_issues_log (violations registry)

INFORMATICA IDMC (Data Integration)
    ↓
    ├─ CDI (Integration)
    │  ├─ Real-time policy status changes → BigQuery
    │  ├─ Nightly BillingCenter extract
    │  └─ Reference table updates
    │
    └─ CDQ (Quality)
        ├─ Profiling rules (VR-002-003 mapping validation)
        └─ Automatic remediation (default unmapped codes to 'K')

SQL SERVER (Batch Scheduling)
    ↓
    ├─ SQL Server Agent Job: DQ_Validation_Batch_Daily
    │  ├─ Time: 11:00 PM (after data loads)
    │  ├─ Executes: SQL_01–04 (profiling) → VR-001–VR-005 (19 rules)
    │  └─ Output: Violations logged to AIL + email alerts
    │
    └─ SQL Server Agent Job: DQ_TDI_Reporting_Monthly
       ├─ Time: 1st of month, 8:00 AM
       ├─ Executes: Extract + aggregate + format TDI report
       └─ Output: TFB_HB2067_Residential_YYYYMM.txt

POWER BI (Visualization)
    ↓
    ├─ Refresh: Daily 6:00 AM (automatic)
    ├─ Data Source: SQL_09 Scorecard + profiling queries
    ├─ Dashboards:
    │  ├─ Executive Dashboard (6 KPI tiles + overall score)
    │  ���─ Data Quality Analyst Dashboard (detailed violations)
    │  ├─ Geographic Heatmap (quality by county)
    │  └─ Trend Dashboard (30-day history)
    └─ Alerts: Embedded alerts if KPI < target

GIT VERSION CONTROL
    ↓
    ├─ All SQL code (queries, DDL, remediation scripts)
    ├─ All documentation (SOPs, compliance matrix, etc.)
    ├─ Change history (who changed what, when, why)
    ├─ Branch: main (production) + dev/testing branches
    └─ Retention: 7+ years (for audit trail)
```

---

---

# 4. Implementation Checklist

## Pre-Implementation (Week -1)

- [ ] **Stakeholder Alignment**
  - [ ] Executive approval of data quality framework
  - [ ] Data Governance Committee established
  - [ ] Budget approved for tools/resources
  
- [ ] **Access & Permissions**
  - [ ] BigQuery dataset access provisioned
  - [ ] SQL Server Agent job creation permissions
  - [ ] PolicyCenter validation endpoint admin access
  - [ ] Informatica IDMC configuration access
  - [ ] GitHub repository access (read/write)
  
- [ ] **Infrastructure Readiness**
  - [ ] BigQuery datasets created (raw + cleansed)
  - [ ] SQL Server job agent service running
  - [ ] Informatica integration tested
  - [ ] PolicyCenter environment updated to Olos
  - [ ] Network connectivity verified (firewall rules)

---

## Phase 1: Deployment (Weeks 1–3)

### Week 1: Validation Rules Deployment

- [ ] **SQL Profiling Queries**
  - [ ] Deploy SQL_01–04 to BigQuery
  - [ ] Test execution (should complete < 5 min)
  - [ ] Verify output schema
  - [ ] Document baseline metrics
  
- [ ] **SQL Validation Rules**
  - [ ] Create SQL Server Agent job: DQ_Validation_Batch_Daily
  - [ ] Deploy VR-001-001 through VR-005-001 queries
  - [ ] Schedule for 11:00 PM nightly
  - [ ] Test on 100-record sample dataset
  - [ ] Verify violations logged to vw_automated_issues_log
  
- [ ] **Informatica Configuration**
  - [ ] Deploy CDI (Integration) for real-time streams
  - [ ] Configure CDQ (Quality) rules for VR-002-003 (reason code mapping)
  - [ ] Test with sample policy transactions
  - [ ] Enable in production
  
- [ ] **Guidewire Validation Endpoints**
  - [ ] Configure PolicyCenter mandatory field validation
  - [ ] Deploy CancellationReasonCode validation endpoint
  - [ ] Test policy binding with missing reason code (should fail)
  - [ ] Verify error message displays to user

### Week 2: Cleansed Views & Monitoring

- [ ] **Deploy Cleansed Views**
  - [ ] Create vw_pc_policyperiod_cleansed (with TDI code mapping)
  - [ ] Create vw_pc_policylocation_cleansed (geocoding flags)
  - [ ] Create vw_pc_vehicle_cleansed (VIN standardization)
  - [ ] Create vw_financial_reconciliation (PC vs. BC variance)
  - [ ] Validate view output against source data
  
- [ ] **Establish Alerting**
  - [ ] Configure Slack integration for violations
  - [ ] Set up email alerts (CRITICAL + HIGH)
  - [ ] Test alert routing (send test alert)
  - [ ] Document escalation procedures
  
- [ ] **Reference Tables**
  - [ ] Load TDI_Reason_Mapping.csv (17 codes A–X)
  - [ ] Load Agent_Master reference table
  - [ ] Load County_Reference table
  - [ ] Verify referential integrity
  
- [ ] **Data Governance Committee**
  - [ ] First formal meeting (review SOPs + compliance matrix)
  - [ ] Assign stakeholder roles & responsibilities
  - [ ] Schedule weekly Monday 9:00 AM meetings
  - [ ] Document meeting minutes

### Week 3: TDI Report Preparation

- [ ] **Retroactive Data Capture**
  - [ ] Identify pre-April 1 notices with post-April 1 effective dates
  - [ ] Review case notes to assign retroactive reason codes
  - [ ] Update pc_policyperiod.CancellationReasonCode field
  - [ ] Validate against TDI_Reason_Mapping
  
- [ ] **Report Generation**
  - [ ] Deploy SQL extract query (policies with CancellationDate in April–May)
  - [ ] Aggregate by ZIP code + reason codes (alphabetically concatenated)
  - [ ] Format per TDI statistical plan specifications
  - [ ] Validate output (schema, values, counts)
  
- [ ] **Testing & Validation**
  - [ ] Schema validation (all required columns present)
  - [ ] Value validation (only A–X codes, valid ZIPs, counts > 0)
  - [ ] MCAS reconciliation (count match against financial records)
  - [ ] Spot-check 10 records manually
  
- [ ] **TDI Submission Process**
  - [ ] Create TDI EDGAR account (if not existing)
  - [ ] Upload Q2 report file
  - [ ] Verify TDI confirmation receipt
  - [ ] Archive submission + receipt (7-year retention)

---

## Phase 2: Stabilization & Optimization (Week 4+)

- [ ] **Performance Tuning**
  - [ ] Analyze validation job execution times
  - [ ] Add database indexes for slow queries
  - [ ] Optimize join strategies (if needed)
  - [ ] Reduce alert false positives (adjust thresholds)
  
- [ ] **Root Cause Analysis Execution**
  - [ ] Initiate RCA for major violations (HB 2067, VIN, Geocoding)
  - [ ] Complete SOP 4 investigations
  - [ ] Develop corrective action plans
  - [ ] Track remediation progress
  
- [ ] **Knowledge Transfer & Training**
  - [ ] Create runbooks for daily operations
  - [ ] Conduct training for Underwriting/Operations teams
  - [ ] Document common troubleshooting scenarios
  - [ ] Record screen-share tutorial videos
  
- [ ] **Compliance Certification**
  - [ ] Executive management certifies compliance status
  - [ ] Document compliance evidence (checksums, screenshots)
  - [ ] Prepare for potential TDI market conduct exam
  - [ ] Update risk register with residual risks
  
- [ ] **Plan Phase 2 Expansion**
  - [ ] Assess commercial lines HB 2067 applicability
  - [ ] Identify additional compliance requirements
  - [ ] Estimate resource needs for Phase 2
  - [ ] Schedule Phase 2 kickoff meeting

---

---

# 5. Troubleshooting & FAQ

## Common Issues & Solutions

### Issue 1: Validation Job Taking Too Long (> 1 hour)

**Symptoms:**
- SQL Server Agent job DQ_Validation_Batch_Daily not completing by 12:30 AM
- Stakeholders cannot run morning scorecard query

**Root Causes:**
1. BigQuery dataset not clustered on frequently filtered columns
2. No indexes on SQL Server source tables
3. JOIN operations retrieving full tables (no WHERE clause)
4. Query timeout (10+ minute wait)

**Resolution:**
```sql
-- 1. Add clustering to BigQuery tables
ALTER TABLE driiiportfolio.raw_underwriting_data.pc_policyperiod
CLUSTER BY Status, County, AgentID;

-- 2. Add indexes to SQL Server (if querying source)
CREATE INDEX idx_pc_status ON pc_policyperiod(Status);
CREATE INDEX idx_pc_reasoncode ON pc_policyperiod(CancellationReasonCode);

-- 3. Optimize joins (add WHERE clauses early)
SELECT *
FROM pc_policyperiod p
WHERE Status = 'Canceled'  -- Filter BEFORE join
  AND p.CreateTime >= CURRENT_DATE - 7
JOIN TDI_Reason_Mapping m ON p.CancellationReasonCode = m.InternalCode;

-- 4. Increase timeout (SQL Server Agent)
-- Right-click Job → Properties → General → Advanced → Timeout: 3600 seconds
```

---

### Issue 2: False Positive Alerts (Violations Detected That Aren't Real)

**Symptoms:**
- CRITICAL alert for 1,000 missing reason codes (but only 5 policies actually canceled yesterday)
- Team spent 2 hours investigating non-issue

**Root Causes:**
1. Validation rule filtering incorrect (captures entire table, not subset)
2. Threshold calculation wrong (comparing to total records instead of affected subset)
3. Cleansed view applying remediation retroactively (appears as violation)

**Resolution:**
```sql
-- Problem: Rule counted ALL policies, not just Canceled
SELECT COUNT(*) FROM pc_policyperiod
WHERE CancellationReasonCode IS NULL;  -- 4,958 records (all active policies!)

-- Solution: Filter to affected subset first
SELECT COUNT(*) FROM pc_policyperiod
WHERE Status = 'Canceled'
  AND CancellationReasonCode IS NULL;  -- 5 records (actual violation)

-- Calculate failure rate correctly
ROUND(5 / 142 * 100, 2)  -- 3.52% of canceled policies (not 4,958/5,000 = 99.2%!)
```

---

### Issue 3: TDI Report Submission Rejected (Missing Column or Invalid Format)

**Symptoms:**
- TDI EDGAR system returns error: "Column 17 contains invalid codes (found 'INT_99')"
- Report must be resubmitted, delaying deadline

**Root Causes:**
1. Cleansed view not used (raw uncleansed codes submitted)
2. TDI_Reason_Mapping incomplete (new internal codes not mapped)
3. Reason codes not concatenated alphabetically

**Resolution:**
```sql
-- Problem: Submitting raw codes (INT_99 visible to TDI)
SELECT CancellationReasonCode FROM pc_policyperiod
WHERE Status = 'Canceled';
-- Result: INT_99, K, D, NULL, ...

-- Solution: Use cleansed view ONLY for TDI report
SELECT Cleansed_TDICode FROM vw_pc_policyperiod_cleansed
WHERE Status = 'Canceled';
-- Result: L, K, D, K, ... (only A–X codes)

-- Ensure alphabetical concatenation
-- Multiple codes ['K', 'D', 'E'] → 'DEK' (not 'KDE')
SELECT STRING_AGG(code ORDER BY code) FROM UNNEST(['K','D','E']) AS code;
-- Result: DEK ✓
```

---

### Issue 4: Cleansed View Shows Different Values Than Source Table

**Symptoms:**
- Analyst runs query on raw table vs. cleansed view
- Results don't match (e.g., raw: NULL; cleansed: 'K')
- Team questions data integrity

**Root Causes:**
1. Cleansed view applies remediation logic (defaults NULL to 'K')
2. Remediation_Status flag indicates REMEDIATED records
3. Analyst not understanding that cleansed layer is INTENTIONAL transformation

**Resolution:**
```sql
-- Explain to stakeholders: Cleansed view applies business logic

-- Raw table (audit source of truth)
SELECT PolicyNumber, CancellationReasonCode, Status
FROM pc_policyperiod
WHERE Status = 'Canceled' AND CancellationReasonCode IS NULL;
-- Shows: NULL records (original state preserved for audit trail)

-- Cleansed view (report-ready, HB 2067 compliant)
SELECT PolicyNumber, CancellationReasonCode, Cleansed_TDICode, Remediation_Status
FROM vw_pc_policyperiod_cleansed
WHERE Status = 'Canceled' AND CancellationReasonCode IS NULL;
-- Shows: NULL in raw; 'K' in Cleansed_TDICode; 'REMEDIATED' flag
-- This is EXPECTED and CORRECT

-- For TDI reporting: Always use Cleansed_TDICode (never raw code)
```

---

## Frequently Asked Questions

### Q: Why do we have both raw and cleansed data?

**A:** For compliance + audit trail:
- **Raw data** preserves original state (immutable for 7-year audit trail)
- **Cleansed data** applies business logic for reporting
- Dual layers enable: "Here's what was in the system" vs. "Here's the compliant version"
- Example: If a policy had NULL reason code, raw table shows NULL; cleansed view shows 'K' (default per business rule) + flag='REMEDIATED'

---

### Q: How often should we run the validation rules?

**A:** Multi-frequency approach:
- **Real-time** (HB 2067 critical data): Informatica CDI + PolicyCenter endpoints
- **Nightly** (general compliance): 11:00 PM SQL Server Agent batch job
- **Weekly** (deep analysis): Data Governance Committee review
- **Monthly** (executive): TDI report submission + scorecard
- **Quarterly** (strategic): Risk assessment + SOPs review

---

### Q: What does "Remediation_Status = REMEDIATED" mean?

**A:** Indicates cleansed view applied business logic:
- **ORIGINAL**: Value from source data (no transformation needed)
- **REMEDIATED**: Source was NULL/invalid; cleansed view applied default/correction
  - Example: NULL CancellationReasonCode → DEFAULT to 'K' (Underwriting – All Other)
  - Remediation_Timestamp: When default was applied
  - Audit trail preserved: Original NULL + remediation flag + timestamp

**Important:** Remediation does NOT modify source data. Raw table is untouched. Cleansed layer shows corrected version for reporting.

---

### Q: Can we modify source data to fix violations?

**A:** Generally NO. Instead:

```
Bad Approach:
├─ Direct UPDATE to pc_policyperiod table ✗ BREAKS AUDIT TRAIL
└─ No way to prove what was original vs. corrected

Good Approach:
├─ Keep raw data unchanged (immutable audit trail)
├─ Apply correction in cleansed view (SOP 4 + governance approval)
├─ Document remediation in RCA post-mortem (SOP 4.5)
└─ Flag as REMEDIATED for transparency
```

**Exception:** Urgent system errors discovered post-implementation:
- Requires Data Governance Committee approval
- Must execute bulk remediation script (logged + timestamped)
- Document reason + approval in change log
- Test thoroughly before production

---

### Q: What's the 1% Data Quality Acceptance Standard?

**A:** Threshold for rule compliance:

```
CRITICAL rules:      0% violations (zero tolerance)
                     └─ Example: HB 2067 reason codes must be 100% present
                     └─ Action: CRITICAL alert if ANY violation

HIGH rules:          < 1% violations (max 50 violations on 5,000 records)
                     └─ Example: Agent ID validation
                     └─ Action: 24-hour investigation + RCA

MEDIUM rules:        < 5% violations (max 250 violations on 5,000 records)
                     └─ Example: VIN format standardization
                     └─ Action: Best-effort investigation

MEDIUM rules:        < 5% violations
BELOW THRESHOLD:     GREEN ✓ PASS (proceed with operations)
ABOVE THRESHOLD:     RED 🔴 FAIL (escalate per SOP 5)
```

---

### Q: Who approves corrective actions?

**A:** Approval hierarchy:

```
CRITICAL Issues (HB 2067, Financial, System Corruption):
└─ Data Governance Committee + Executive Management

HIGH Issues (Significant data quality degradation):
└─ Data Governance Committee + Department Manager

MEDIUM Issues (Isolated errors, cosmetic issues):
└─ Data Quality Analyst II + Team Lead

For HB 2067 specifically:
├─ Compliance Officer: Approves reason code mappings
├─ Underwriting Manager: Approves remediation timeline
├─ Data Governance Committee: Votes on exceptions
└─ Executive Management: Signs off on final compliance status
```

---

### Q: How do we ensure 7-year retention of compliance evidence?

**A:** Multi-layer approach:

```
Layer 1: GitHub Version Control
├─ All SQL code + documentation versioned
├─ Commit history (who, what, when, why) immutable
└─ Retention: 7+ years automatic

Layer 2: Compliance File (Shared Drive)
├─ Folder: \\TFB-Compliance\HB2067_Documentation\
├─ Contains: Reports, submissions, certifications, audit trails
└─ Retention: Manual archival to write-once media (CD-ROM)

Layer 3: BigQuery Data Warehouse
├─ Raw data: 90-day rolling window (then archived)
├─ Cleansed views: Historical snapshots (monthly backups)
├─ AIL (Automated Issues Log): Full history retained
└─ Retention: Configured in BigQuery lifecycle policies

Layer 4: TDI EDGAR System
├─ Submissions uploaded to TDI system (official record)
├─ TDI retains copies (regulatory authority)
└─ Retention: 7+ years (TDI requirement)

Verification:
├─ Quarterly: Verify evidence completeness (hash checks)
├─ Annually: Audit retention compliance
└─ On-demand: Pull evidence for TDI market conduct exam
```

---

---

# 6. Training Materials & Onboarding

## New DQ Analyst Onboarding Checklist (First Week)

### Monday: Orientation & Context

- [ ] Welcome meeting with manager
- [ ] System access provisioned (BigQuery, GitHub, Slack, etc.)
- [ ] Read: DOC_01 (Role Enhancement) + DOC_02 (Job Description)
- [ ] Watch: 15-min orientation video (project overview)
- [ ] Assigned mentor/buddy for technical questions

### Tuesday: Data Quality Fundamentals

- [ ] Read: DOC_04 (Data Dictionary – core tables)
- [ ] Read: DOC_05 (Validation Rules Registry – summary)
- [ ] Watch: 30-min training video (6 dimensions explained)
- [ ] Complete quiz: "What is Accuracy vs. Completeness?" (3 questions)

### Wednesday: SOPs & Procedures

- [ ] Read: DOC_06 (SOPs 1–3: Lifecycle, Profiling, Validation)
- [ ] Read: DOC_06 (SOP 4: Root Cause Analysis)
- [ ] Watch: 20-min video (SOP walkthrough)
- [ ] Shadow: Observe daily 6:30 AM scorecard review

### Thursday: HB 2067 Compliance

- [ ] Read: DOC_07 (HB 2067 Compliance Matrix)
- [ ] Read: TDI Statistical Plan specifications (attached)
- [ ] Watch: 25-min video (HB 2067 explained)
- [ ] Q&A session with Compliance Officer

### Friday: Hands-On Technical Work

- [ ] Execute SQL_01–04 profiling queries (guided by mentor)
- [ ] Interpret results: "What do these violation counts mean?"
- [ ] Access Power BI dashboard: Explore KPI tiles
- [ ] Write simple SQL query: "Count policies by status"
- [ ] Reflect: Document learnings in wiki

### Week 2: Advanced Topics

- [ ] Read: DOC_08 (Extended Profiling Queries)
- [ ] Execute RCA queries (SQL_05–08)
- [ ] Participate in Data Governance Committee meeting (observe)
- [ ] Design simple validation rule (supervised)
- [ ] Document one SOP procedure (re-write from memory)

---

## Glossary of Data Quality Terms

| Term | Definition | Example |
|---|---|---|
| **Accuracy** | Records conform to business rules and validation constraints | "93.43% of policies pass validation rules" |
| **Cleansed View** | Golden layer applying business logic without modifying source data | vw_pc_policyperiod_cleansed (maps internal codes → TDI codes) |
| **Completeness** | Mandatory fields for underwriting are populated | "97.85% of canceled policies have reason codes" |
| **Consistency** | Data is uniform across systems (PC vs. BC, etc.) | "Premium amounts match between PolicyCenter and BillingCenter" |
| **Data Drift** | Sudden change in data patterns (anomaly detection) | "Null rate for VIN jumped from 1% to 8% on April 17" |
| **Data Quality Dimension** | One of six metrics: Accuracy, Completeness, Consistency, Timeliness, Validity, Integrity | See 6-dimension framework |
| **ETL** | Extract, Transform, Load (data pipeline) | Informatica extracts from PolicyCenter, transforms, loads to BigQuery |
| **Golden Layer** | Curated, business-logic-compliant data for reporting | Cleansed views (DDL_01–04) |
| **HB 2067** | House Bill 2067 (2025), Texas statutory mandate for insurance denial explanations | Effective April 1, 2026; requires TDI reason codes (A–X) |
| **Informatica IDMC** | Cloud data integration platform (ETL + data quality) | Real-time CDC + nightly batch loads + profiling rules |
| **Integrity** | No orphaned/disconnected records; referential integrity maintained | "Every location has valid parent policy; 0 orphans detected" |
| **KPI** | Key Performance Indicator (monitored metric) | Accuracy Score, Completeness Rate, etc. |
| **RCA** | Root Cause Analysis (SOP 4 investigation) | Determine why 140 policies lack reason codes (Olos migration gap) |
| **Remediation** | Corrective action to fix data quality issue | Assign reason codes retroactively; update TDI_Reason_Mapping; deploy Olos fix |
| **SOP** | Standard Operating Procedure (documented process) | SOP 1: Lifecycle; SOP 4: RCA; SOP 6: KPI Monitoring |
| **TDI** | Texas Department of Insurance (regulatory authority) | Submits HB 2067 monthly reports; TDI reviews for market conduct audit |
| **Timeliness** | Data available when needed; reflects current status | "Nightly batch loads complete by 11:30 PM (within 4-hour SLA)" |
| **Validation Rule** | Automated check ensuring data meets business logic | VR-001-001: Mandatory reason codes; VR-003-001: VIN format |
| **Validity** | Data values conform to format, type, domain requirements | "VINs are exactly 17 alphanumeric; ZIP codes are 5 digits" |

---

---

# 7. Change Management & Version Control

## Change Control Process

### Change Request Form

```
═══════════════════════════════════════════════════════════════════════════════
CHANGE CONTROL REQUEST FORM
═══════════════════════════════════════════════════════════════════════════════

REQUESTER INFORMATION:
  Name: _________________________    Date: ______________
  Department: ___________________    Email: _____________
  Urgency: ☐ Routine  ☐ High  ☐ Emergency

CHANGE DESCRIPTION:
  Title: _________________________________________________________________
  
  Description:
  ┌─────────────────────────────────────────────────────────────────────┐
  │ What is changing? Why? What is the business driver?                │
  │                                                                     │
  │                                                                     │
  └─────────────────────────────────��───────────────────────────────────┘

CHANGE TYPE:
  ☐ Database Schema (add/modify field)
  ☐ Validation Rule (new/update VR-XXX-XXX)
  ☐ SOP Update (modify procedure)
  ☐ Reference Data (TDI_Reason_Mapping, etc.)
  ☐ System Configuration (PolicyCenter, Informatica, etc.)
  ☐ Other: _________________________

IMPACT ASSESSMENT:
  Affected Systems: ___________________________________
  
  Data Quality Dimensions Impacted:
  ☐ Accuracy  ☐ Completeness  ☐ Consistency  ☐ Timeliness  ☐ Validity  ☐ Integrity
  
  Estimated Impact: ☐ None  ☐ Minor  ☐ Moderate  ☐ Major  ☐ Critical
  
  HB 2067 Compliance Affected? ☐ YES (explain): ___________________
  
  Downtime Required? ☐ No  ☐ Yes: _______ minutes
  
  Rollback Complexity? ☐ Simple  ☐ Moderate  ☐ Complex  ☐ Not Reversible

TESTING PLAN:
  ☐ Unit test (development environment)
  ☐ Integration test (staging environment, full dataset)
  ☐ User acceptance test (UAT)
  ☐ Performance test (check execution time, resource usage)
  ☐ Regression test (verify existing functionality unaffected)

IMPLEMENTATION PLAN:
  Proposed Implementation Date: __________________
  Implementation Window: _________________ to _________________
  
  Rollback Plan (if change fails):
  ┌─────────────────────────────────────────────────────────────────────┐
  │ How will we revert if something goes wrong?                        │
  │                                                                     │
  └─────────────────────────────────────────────────────────────────────┘

APPROVAL WORKFLOW:
  ☐ Technical Review (Data Quality Lead): _______ / _______
  ☐ Business Review (Underwriting Manager): _______ / _______
  ☐ Compliance Review (if HB 2067 related): _______ / _______
  ☐ Executive Approval (if Critical impact): _______ / _______

SIGN-OFF:
  Submitted By: ________________________  Date: _____________
  Approved By: _________________________  Date: _____________
  Implemented By: ______________________  Date: _____________

CHANGE NOTES:
  ┌─────────────────────────────────────────────────────────────────────┐
  │ Any issues discovered during implementation? Lessons learned?      │
  │                                                                     │
  └─────────────────────────────────────────────────────────────────────┘
```

---

## Version Control (GitHub)

### Commit Message Standard

```
Format: <type>(<scope>): <subject>

Types:
├─ feat: New feature (e.g., new validation rule)
├─ fix: Bug fix (e.g., query optimization)
├─ docs: Documentation only (e.g., SOP update)
├─ refactor: Code reorganization (no functional change)
├─ perf: Performance improvement
├─ test: Test case addition/update
└─ chore: Maintenance (e.g., dependencies)

Scope:
├─ validation-rules
├─ profiling-queries
├─ cleansed-views
├─ documentation
├─ infrastructure
└─ compliance

Example Commits:

✓ GOOD:
  feat(validation-rules): Add VR-002-003 for TDI reason code mapping
  
  - Validates CancellationReasonCode exists in TDI_Reason_Mapping
  - Executes nightly as part of DQ_Validation_Batch_Daily
  - Threshold: 0% violations (CRITICAL rule)
  - HB 2067 compliance requirement
  
  Closes #42

✗ BAD:
  updated stuff
  fixed bug
  random fixes
```

---

### Release Process

```
VERSION NUMBERING: MAJOR.MINOR.PATCH

v1.0.0 - Initial Release (April 18, 2026)
├─ 8 SOPs documented
├─ 19 validation rules deployed
├─ 6-dimension framework established
├─ HB 2067 compliance matrix published
└─ TDI Q2 report generation ready

v1.1.0 - Olos Migration Gap Fix (May 5, 2026)
├─ Guidewire reason code trigger re-implemented
├─ 82 missing reason codes remediated
├─ Validation endpoint configured for mandatory field
└─ Q2 report submission successful

v1.2.0 - Commercial Lines Expansion (Q3 2026)
├─ Extended validation rules for commercial property
├─ New HB 2067 Phase 2 compliance (proposed)
├─ Enhanced profiling for commercial segments
└─ Updated documentation for broader applicability

RELEASE CHECKLIST:

Pre-Release:
  ☐ Code review (2 approvals minimum)
  ☐ All tests passing (unit + integration + regression)
  ☐ Documentation updated (SOPs, README, etc.)
  ☐ Release notes drafted
  ☐ Rollback plan documented
  ☐ Stakeholders notified

Release:
  ☐ Create release branch (e.g., release/v1.1.0)
  ☐ Tag commit with version (git tag v1.1.0)
  ☐ Generate release notes on GitHub
  ☐ Update README with "Latest Version"
  ☐ Notify team of release availability

Post-Release:
  ☐ Monitor for issues (first 24 hours)
  ☐ Rollback if critical issues discovered
  ☐ Publish post-release retrospective
  ☐ Document any lessons learned
```

---

---

# 8. Risk Register & Mitigation Strategies

## Risk Matrix

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           RISK IMPACT vs. LIKELIHOOD                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  IMPACT                                                                      │
│    │                                                                         │
│  5 │                        ★ TDI Audit Failure   ★ System Outage          │
│    │                              (H)                   (H)                 │
│    │                                                                        │
│  4 │                  ★ Compliance Gap       ★ Data Corruption             │
│    │                       (H)                      (M)                     │
│    │                                                                        │
│  3 │      ★ Reporting Delay   ★ False Positives   ★ Performance            │
│    │           (M)                 (M)               Degradation (M)         │
│    │                                                                        │
│  2 │         ★ Training Gap                ★ Documentation                 │
│    │              (L)                           Lag (L)                     │
│    │                                                                        │
│  1 │  ★ Minor Config Issue                                                 │
│    │         (L)                                                            │
│    │                                                                        │
│    └────┬───────┬──────┬──────────┬────────────────────────────┬─────      │
│        1       2       3          4                            5          │
│      LOW    MEDIUM   HIGH    VERY HIGH              ALMOST CERTAIN        │
│                    LIKELIHOOD                                             │
│                                                                             │
│   Color Legend:                                                            │
│   ★ GREEN (Risk Score 1–3):  Manageable with standard controls            │
│   ★ YELLOW (Risk Score 4–8): Monitor closely; mitigation required         │
│   ★ RED (Risk Score 9–15):   Critical; immediate action required          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Top 10 Risks

| Risk | Likelihood | Impact | Score | Mitigation Strategy |
|---|---|---|---|---|
| **1. TDI Audit Failure (HB 2067 Non-Compliance)** | High (4) | Critical (5) | **20** 🔴 | Deploy validation rules by May 15; retroactive capture by May 31; dry-run TDI report by June 1; executive sign-off by June 10 |
| **2. System Outage (Informatica/BigQuery Down)** | Medium (3) | Critical (5) | **15** 🔴 | Maintain on-premises backup tables; daily data exports to CSV; RTO: 4 hours; test disaster recovery quarterly |
| **3. Compliance Gap (Missing Reason Codes Post-Deadline)** | Medium (3) | Critical (5) | **15** 🔴 | Guidewire trigger fix by May 5 (BLOCKING); escalate to executive if delayed; interim golden layer approach ready |
| **4. Data Corruption (Accidental Updates to Raw Tables)** | Low (2) | Critical (5) | **10** 🟡 | Restrict write access to raw tables (read-only for analysts); require DBA approval for UPDATEs; version control all scripts |
| **5. Reporting Delay (TDI Report Not Ready by June 15)** | Medium (3) | High (4) | **12** 🟡 | Weekly status tracking; identify blockers early; allocate backup resources; test report generation by June 1 |
| **6. False Positive Alerts (Alert Fatigue)** | Medium (3) | Medium (3) | **9** 🟡 | Tune thresholds post-deployment; establish escalation criteria; track false positive rate (target: < 5%); adjust rules as needed |
| **7. Validation Rule Performance Degradation** | Low (2) | High (4) | **8** 🟡 | Monitor daily execution times; add indexes for slow queries; plan query optimization by May 1; budget 8 hours/month for tuning |
| **8. Training Gap (Team Doesn't Understand SOPs)** | Low (2) | Medium (3) | **6** 🟡 | Conduct formal SOP training for all stakeholders; create runbooks; record video tutorials; require certification |
| **9. Documentation Lag (Docs Out-of-Sync with Code)** | Medium (3) | Medium (3) | **9** 🟡 | Link documentation to code (cross-references); require doc updates in PRs; quarterly doc audits; version control everything |
| **10. HazardHub API Timeout (Geocoding Vendor Failure)** | Low (2) | Medium (3) | **6** 🟡 | Contact vendor for patch (ETA: Apr 20); interim: flag locations as "geocoding_required" (cleansed view); re-try nightly |

---

---

# 9. Compliance & Audit Evidence

## Evidence Checklist

```markdown
## COMPLIANCE EVIDENCE REPOSITORY

Location: \\TFB-Compliance\HB2067_Documentation\

├─ REGULATORY FRAMEWORK
│  ├─ House_Bill_2067_Full_Text.pdf
│  ├─ 28_TAC_5.9503_Statutory_Plan_Residential.pdf
│  ├─ 28_TAC_5.9504_Statutory_Plan_Auto.pdf
│  ├─ TDI_Reason_Codeset_A-X.pdf
│  └─ TDI_Statistical_Report_Instructions.pdf
│
├─ SYSTEM CONFIGURATION
│  ├─ PolicyCenter_Mandatory_Field_Config_Screenshot.png
│  ├─ Olos_Validation_Endpoint_Deployment_Log.txt
│  ├─ TDI_Reason_Mapping_Reference_Table.csv (v1.2)
│  ├─ Cleansed_View_SQL_Definitions.sql
│  └─ Informatica_CDI_Configuration_Export.xml
│
├─ VALIDATION & MONITORING
│  ├─ VR_001_001_HB2067_Daily_Results.csv (April 1–May 31)
│  ├─ VR_002_003_Mapping_Daily_Results.csv (April 1–May 31)
│  ├─ SQL_09_DQ_Scorecard_Daily_April_18_2026.xlsx
│  ├─ Power_BI_Dashboard_Screenshots.pdf
│  └─ Automated_Issues_Log_Export_April_2026.xlsx
│
├─ ROOT CAUSE ANALYSIS
│  ├─ RCA_HB2067_Missing_Codes_PostMortem.pdf
│  ├─ RCA_Geocoding_Coastal_PostMortem.pdf
│  ├─ RCA_VIN_Format_PostMortem.pdf
│  ├─ Corrective_Action_Plan_Olos_Migration_Gap.pdf
│  └─ Remediation_Progress_Tracking.xlsx
│
├─ TDI REPORTING
│  ├─ Q2_2026_Report_April_Data_Submission.txt
│  ├─ Q2_2026_Report_May_Data_Submission.txt
│  ├─ Q2_2026_Final_Submission_June_15_2026.txt
│  ├─ TDI_EDGAR_Receipt_Confirmation_June_15_2026.pdf
│  ├─ MCAS_Reconciliation_Workpaper.xlsx
│  └─ TDI_Submission_Audit_Trail.xlsx
│
├─ CUSTOMER COMMUNICATIONS
│  ├─ Customer_Notice_Sample_Declined.pdf
│  ├─ Customer_Notice_Sample_Canceled.pdf
│  ├─ Customer_Notice_Sample_NonRenewed.pdf
│  ├─ Notice_Delivery_Proof_Sample_USPS.pdf
│  └─ Notice_Generation_Log_April_2026.csv
│
├─ GOVERNANCE & MANAGEMENT
│  ├─ Data_Governance_Committee_Charter.pdf
│  ├─ Data_Governance_Meeting_Minutes_April_18_2026.pdf
│  ├─ Data_Governance_Meeting_Minutes_April_25_2026.pdf
│  ├─ Data_Governance_Meeting_Minutes_May_2_2026.pdf
│  ├─ Management_Compliance_Certification_April_18_2026.pdf
│  └─ Executive_Signoff_HB2067_Commitment.pdf
│
├─ AUDIT TRAIL
│  ├─ GitHub_Commit_History_Export.txt (all changes)
│  ├─ SQL_Change_Log_2026.xlsx (queries modified)
│  ├─ Reference_Data_Change_Log.xlsx (mapping updates)
│  ├─ SOPs_Version_History.xlsx (SOP updates)
│  └─ Access_Control_Log_April_May_2026.csv (who accessed what)
│
└─ SUPPORTING DOCUMENTATION
   ├─ DOC_01_through_DOC_09 (all 9 documents)
   ├─ README_Quick_Start_Guide.md
   ├─ Data_Dictionary_Complete.xlsx
   ├─ Architecture_Diagrams.pdf
   ├─ Implementation_Checklist.xlsx
   └─ Lessons_Learned_Report.pdf
```

---

---

# 10. Contact Directory & Escalation Procedures

## Stakeholder Directory

| Role | Name | Title | Email | Phone | Slack | Primary Responsibilities |
|---|---|---|---|---|---|---|
| **Primary DQ Lead** | Daniel Rodriguez III | Data Quality Analyst II | d.rodriguez@tfbcas.com | Ext 5555 | @drodriguez | Daily operations, SOP execution, RCA lead |
| **Manager** | [Name] | Data Manager | [email] | Ext [X] | @manager | Escalation, resource allocation, governance |
| **Underwriting** | [Name] | Underwriting Manager | [email] | Ext [X] | @underwriting_mgr | Business requirements, HB 2067 mandate input |
| **Compliance** | [Name] | Compliance Officer | [email] | Ext [X] | @compliance | HB 2067 compliance, TDI coordination |
| **Finance** | [Name] | Financial Manager | [email] | Ext [X] | @finance_mgr | Premium reconciliation (VR-004-002), MCAS |
| **IT/Infrastructure** | [Name] | DBA | [email] | Ext [X] | @dba | Database support, performance tuning, backups |
| **Informatica** | [Name] | Integration Lead | [email] | Ext [X] | @informatica_lead | ETL pipeline, IDMC configuration, CDC setup |
| **Guidewire** | [Name] | Guidewire Lead | [email] | Ext [X] | @guidewire_lead | PolicyCenter config, Olos integration, validation endpoints |
| **Executive** | [Name] | CFO / VP Operations | [email] | Ext [X] | @executive | Strategic oversight, risk sign-off, TDI audit response |

---

## Escalation Procedures

### CRITICAL Issue Escalation (1–4 Hour Response)

```
LEVEL 1 (0–30 min): Detection & Initial Triage
├─ Automated alert triggered (Slack #data-emergency)
├─ Data Quality Analyst acknowledges within 5 min
├─ Analyst determines: Is this truly CRITICAL?
├─ If YES: Proceed to Level 2
└─ If NO: Reclassify to HIGH; proceed with 24-hour response

LEVEL 2 (30 min–1 hour): Escalation to Leadership
├─ Data Quality Analyst sends email to:
│  ├─ Data Manager
│  ├─ Compliance Officer
│  ├─ Underwriting Manager
│  ├─ Executive (if financial impact)
│  └─ Email template: "🔴 CRITICAL Data Quality Issue"
├─ Subject: Describe issue in 2 sentences
├─ Impact: Explain regulatory/financial/operational impact
├─ Action: Recommend immediate response
└─ Send: Within 30 min of detection

LEVEL 3 (1–2 hours): Leadership Decision
├─ Emergency meeting with stakeholders (conference call/in-person)
├─ Decision: Stop processing? Continue with mitigations?
├─ Resource allocation: Assign RCA owner + budget additional staff
├─ Timeline: Set resolution target (usually 24 hours)
└─ Communication: Notify all staff of issue + status

LEVEL 4 (2–4 hours): Root Cause Analysis
├─ RCA owner (usually Data Quality Analyst II) investigates
├─ Execute RCA queries (SQL_05–08) to identify root cause
├─ Present preliminary findings to leadership
├─ Decision: Temporary workaround vs. permanent fix?
├─ Implement immediate mitigation if needed
└─ Document everything for post-mortem

ESCALATION CONTACTS (by severity):

CRITICAL: 
├─ Slack: #data-emergency + @manager + @executive
├─ Email: data-critical-alert@tfbcas.com (group)
├─ Phone: (if after hours) Emergency hotline [NUMBER]
└─ Response: Within 30 minutes

HIGH:
├─ Slack: #data-quality + @manager
├─ Email: data-quality-team@tfbcas.com (group)
├─ Response: Within 24 hours
└─ Escalate to CRITICAL if not resolved by end-of-day
```

---

### Escalation Email Template

```
TO: Data Manager, Compliance Officer, Executive Leadership
CC: Underwriting Manager, Finance Manager
SUBJECT: 🔴 CRITICAL DATA QUALITY ISSUE – Immediate Action Required

ISSUE SUMMARY:
  Identifier: VR-001-001-20260418
  Title: HB 2067 Compliance Failure – Missing Reason Codes
  Severity: CRITICAL
  Detected: April 18, 2026 12:30 AM
  Status: UNRESOLVED (requires immediate action)

BUSINESS IMPACT:
  ✗ 140 canceled policies lack statutory reason codes (HB 2067 violation)
  ✗ Cannot submit compliant TDI report (deadline: June 15, 2026 – 58 days away)
  ✗ Regulatory exposure: TDI audit finding + potential penalties
  ✗ 140 customers lack required written denial explanation (legal exposure)

ROOT CAUSE (PRELIMINARY):
  Olos release (deployed April 1) missing policy cancellation trigger
  Result: New canceled policies (post-Apr 1) have no reason code capture
  Evidence: Temporal clustering of violations (all post-April 1)

IMMEDIATE ACTION REQUIRED:
  1. Declare CRITICAL issue (all hands on deck)
  2. Contact Guidewire support (escalate as P1 – Production Down)
  3. Allocate RCA resources (Data Analyst II + Guidewire lead)
  4. Establish 24-hour investigation deadline
  5. Prepare customer communication (if refunds requested)

INTERIM MITIGATION:
  - Golden layer (cleansed view) applies default reason code 'K' for HB 2067 reporting
  - Cleansed view can be used for Q2 TDI report (if permanent fix delayed)
  - Preserves audit trail: Original NULL + remediation flag + timestamp

NEXT STEPS:
  ├─ 1:00 PM: RCA kickoff call
  ├─ 4:00 PM: Preliminary findings presented to leadership
  ├─ 6:00 PM: Decision on permanent fix vs. interim solution
  ├─ 8:00 PM: Implementation begins
  └─ 12:30 AM (next day): Verification & closure

CONTACT:
  Lead Investigator: Daniel Rodriguez III (Data Quality Analyst II)
  Email: d.rodriguez@tfbcas.com | Phone: Ext 5555
  Emergency: Call [NUMBER] if outside business hours

THIS REQUIRES IMMEDIATE ESCALATION. 
Please confirm receipt within 15 minutes.
```

---

## Contact Escalation Flowchart

```
        DATA QUALITY ALERT DETECTED
                   ↓
        ┌─────────────────────────┐
        │  Is it CRITICAL?        │
        │  (HB 2067, System Down, │
        │   Regulatory, Financial)│
        └──┬──────────────┬────────┘
           │ YES          │ NO
           ↓              ↓
        CRITICAL        HIGH/MEDIUM
        RESPONSE        RESPONSE
           ↓              ↓
        ┌──────┐      ┌──────────┐
        │ L1:  │      │ L1:      │
        │ Triage│     │ Escalate │
        │ 5min  │      │ to DQ    │
        └──┬───┘      │Lead (no  │
           │          │ alarm)   │
           ↓          └──┬───────┘
        ┌──────┐         │
        │ L2:  │         │ L2: DQ
        │ Email│         │ Lead  
        │ to:  │         │ triages
        │ *Mgr │         │ within
        │ *CO  │         │ 24h
        │ *UM  │         │
        │ *Exec│         │
        └──┬───┘         │
           │             │
           ↓             ↓
        ┌──────┐     ┌─────┐
        │ L3:  │     │ If  │
        │ Emrg │     │still│
        │ Mtg  │     │not  │
        │ within│    │fixed│
        │ 1h   │    │→    │
        └──┬───┘    │CRISIS│
           │        └─────┘
           ↓
        ┌──────┐
        │ L4:  │
        │ RCA  │
        │ 2-4h │
        └──┬───┘
           │
           ↓
        ┌─────────────┐
        │ Resolution  │
        │ or Rollback │
        └─────────────┘
```

---

---

## Document Approval

| Role | Name | Signature | Date | Acknowledgment |
|---|---|---|---|---|
| **Author** | Daniel Rodriguez III | __________________ | 2026-04-18 | Complete documentation package prepared |
| **Data Quality Lead** | [Name] | __________________ | ____________ | Operational guidance approved |
| **Manager** | [Name] | __________________ | ____________ | Resource allocation authorized |
| **Compliance Officer** | [Name] | __________________ | ____________ | HB 2067 framework validated |
| **Executive Sponsor** | [Name] | __________________ | ____________ | Strategic commitment confirmed |

---

## Distribution List

- **Internal Distribution:**
  - Data Governance Committee (all members)
  - Underwriting Operations Team
  - Finance/Billing Team
  - IT/Infrastructure Team
  - Informatica Support Team
  - Guidewire Implementation Team

- **External Distribution:**
  - Guidewire Professional Services (if consulting)
  - Informatica Support (for reference)
  - External Auditors (for compliance reviews)

- **Regulatory:**
  - Texas Department of Insurance (on request via market conduct exam)

---

**END OF SUPPORTING DOCUMENTATION PACKAGE**

For updates, corrections, or additional documentation needs, contact Daniel Rodriguez III, Data Quality Analyst II.

Last Updated: April 18, 2026  
Next Review: October 18, 2026 (Six-month review cycle)