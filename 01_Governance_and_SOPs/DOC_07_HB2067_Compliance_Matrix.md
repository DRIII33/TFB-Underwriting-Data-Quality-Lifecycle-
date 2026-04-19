# House Bill 2067 Compliance Matrix
## Statutory Requirement Mapping & Regulatory Evidence Framework

**Document Owner:** Compliance Officer  
**Author:** Daniel Rodriguez III, Data Quality Analyst II  
**Date:** April 18, 2026  
**Version:** 1.0  
**Classification:** Internal – Confidential & Regulatory  
**Regulatory Authority:** Texas Department of Insurance (TDI)  
**Applicable Legislation:** House Bill 2067, 89th Texas Legislature (2025)

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [HB 2067 Legislative Overview](#hb-2067-legislative-overview)
3. [Statutory Requirement Matrix](#statutory-requirement-matrix)
4. [Implementation Status & Compliance Evidence](#implementation-status--compliance-evidence)
5. [Data Quality Controls Mapped to Statutory Mandates](#data-quality-controls-mapped-to-statutory-mandates)
6. [Reason Code Framework & TDI Codeset Mapping](#reason-code-framework--tdi-codeset-mapping)
7. [Reporting Deadlines & Phase Implementation](#reporting-deadlines--phase-implementation)
8. [Audit Trail & Evidence Collection Procedures](#audit-trail--evidence-collection-procedures)
9. [Financial & Regulatory Risk Assessment](#financial--regulatory-risk-assessment)
10. [Compliance Certification & Sign-Off](#compliance-certification--sign-off)

---

## Executive Summary

### Legislative Mandate

**House Bill 2067** (89th Texas Legislature, 2025) fundamentally transforms property and casualty insurance disclosure requirements in Texas by replacing a reactive model (policyholder must request explanation) with a **proactive model (insurer must automatically provide written explanation)** for all coverage denials.

### Applicability

**Effective Date:** April 1, 2026  
**Phase 1 Coverage (Current):** Residential Property, Private Passenger Auto, Workers' Compensation  
**First TDI Report Due:** June 15, 2026 (for Q2 2026)  
**Applicable Insurers:** All P&C insurers licensed in Texas  
**Enforcement Authority:** Texas Department of Insurance (TDI) Market Conduct Examination

### Texas Farm Bureau's Current Status

| Metric | Value | Status |
|--------|-------|--------|
| **Compliance Readiness** | Partial | ⚠️ AT RISK |
| **Systems Updated** | 60% | ⚠️ IN PROGRESS |
| **Data Quality Validation** | Deployed | ✓ ACTIVE |
| **Violations Detected** | 140 policies | 🔴 CRITICAL |
| **Violations Remediated** | 0 policies | 🔴 PENDING |
| **TDI Report Readiness** | NOT READY | 🔴 CRITICAL |
| **Time to Deadline** | 58 days | ⚠️ LIMITED BUFFER |

---

## HB 2067 Legislative Overview

### Legislative History

- **Bill Number:** HB 2067 (89th Texas Legislature)
- **Session:** 2025 Regular Session (January–June 2025)
- **Sponsor:** Representative [Name]
- **Committee:** House Committee on Insurance
- **Effective Date:** April 1, 2026 (Phase 1)
- **Regulatory Authority:** Texas Department of Insurance

### Policy Objective

The bill codifies a "consumer protection and market transparency" mandate requiring insurers to proactively disclose reasons for coverage denials, non-renewals, and cancellations. This addresses historical consumer complaints that insurers withheld information about underwriting decisions.

### Regulatory Framework

**Statutory References:**

```
Primary Statute:
  └─ House Bill 2067 (89th Leg., 2025) – Full text and history

Implementing Rules:
  ├─ 28 TAC §5.9503 (Statistical Plans – Residential Risks)
  ├─ 28 TAC §5.9504 (Statistical Plans – Private Passenger Auto)
  ├─ 28 TAC §5.9505 (Statistical Plans – Workers' Compensation)
  ├─ 28 TAC §5.7015 (Record Retention & Audit Trail)
  └─ 28 TAC §1.705 (Market Conduct Annual Statement – MCAS)

Texas Insurance Code References:
  ├─ § 2753 (Cancellation of Insurance)
  ├─ § 2702 (Notice of Declination, Cancellation, or Non-Renewal)
  ├─ § 544.353 (Prohibited Bases for Cancellation – Disaster Areas)
  └─ § 2704 (Short Rate Prohibition – Pro-Rata Premium)
```

---

## Statutory Requirement Matrix

### Comprehensive Requirement Mapping

This matrix maps each statutory requirement to:
- **Specific regulatory citation** (statute/TAC section)
- **Plain English requirement** (what must be done?)
- **Texas Farm Bureau implementation** (what are we doing?)
- **Supporting evidence** (how do we prove compliance?)
- **Data quality control** (what validation ensures compliance?)
- **Current status** (are we compliant?)

---

### REQUIREMENT 1: Automatic Written Explanation Mandate

**Regulatory Citation:**  
House Bill 2067, § 1 (New § 2702, Texas Insurance Code)  
28 TAC §5.9503(E) (Statutory Plans – Residential)  
28 TAC §5.9504(E) (Statutory Plans – Auto)

**Statutory Text:**
> "An insurer shall provide written notice of the reason for the insurer's action of declining a policy, canceling a policy, or failing to renew a policy within 30 days of the date of the action."

**Requirement in Plain English:**

For every policy that is:
- **Declined** (application rejected before binding)
- **Canceled** (policy terminated before expiration)
- **Not Renewed** (renewal declined; coverage ends at expiration)

The insurer MUST:
- Provide written communication to the policyholder
- Explain the reason for the action using standardized TDI reason codes
- Send notice within 30 days of the action date
- Retain copy of notice in compliance file for 7 years

**Texas Farm Bureau Implementation:**

```
PROCESS FLOW:

1. POLICY STATUS CHANGE
   └─ Underwriter marks policy as "Canceled", "Declined", or "NonRenewed" in PolicyCenter
   
2. AUTOMATED WORKFLOW (NEW in Olos)
   ├─ PolicyCenter validation endpoint triggers
   ├─ Reason code field becomes mandatory
   ├─ Underwriter selects reason code from TDI codeset (A–X)
   ├─ Selected reason concatenated (alphabetically if multiple)
   └─ System logs: Timestamp, Reason Code(s), UserID
   
3. NOTICE GENERATION (Automated)
   ├─ Policy status change triggers document generation
   ├─ Template letter populated with:
   │  ├─ Policyholder name and address
   │  ├─ Policy number and effective/expiration dates
   │  ├─ Action taken (Declined/Canceled/NonRenewed)
   │  ├─ Reason code(s) with human-readable description
   │  └─ Agent contact information
   ├─ Notice printed/emailed within 1 business day
   └─ Copy retained in compliance file
   
4. DATA CAPTURE (New)
   ├─ Reason code stored in pc_policyperiod.CancellationReasonCode
   ├─ Mapped to TDI code via TDI_Reason_Mapping table
   ├─ Timestamped: When reason was captured
   ├─ Audit trail: Who entered reason code; when; what was changed
   └─ Golden layer view (vw_pc_policyperiod_cleansed) provides TDI-compliant data
   
5. STATISTICAL REPORTING (Monthly/Quarterly)
   ├─ Reason codes extracted from cleansed layer
   ├─ Concatenated alphabetically (e.g., 'DEK' for codes D, E, K combined)
   ├─ Submitted to TDI per 28 TAC §5.9503(G)
   └─ Included in Market Conduct Annual Statement (MCAS)
```

**Supporting Evidence:**

| Evidence Type | Location | Details |
|---|---|---|
| **System Configuration** | Guidewire Olos | Validation endpoint deployed; mandatory reason code field |
| **Notice Template** | Document Management | Letter template with reason code explanation |
| **Sample Notice** | Compliance File | Example notice showing code mapping to description |
| **Policy Audit Trail** | PolicyCenter Logs | Evidence of reason code entry + timestamp |
| **Cleansed View** | BigQuery | vw_pc_policyperiod_cleansed with Cleansed_TDICode + Remediation_Status |
| **TDI Reference Table** | BigQuery | TDI_Reason_Mapping.csv with all 17 authorized codes (A–X) |

**Data Quality Controls:**

```
Control 1: Mandatory Field Validation (VR-001-001)
├─ Rule: IF Status IN ('Canceled', 'NonRenewed', 'Declined') THEN CancellationReasonCode IS NOT NULL
├─ Threshold: 0% violations (zero tolerance)
├─ Current Status: FAILING (140 violations = 2.8%)
└─ Remediation: [In SOP 4 – RCA & Corrective Action]

Control 2: TDI Code Existence Validation (VR-002-003)
├─ Rule: CancellationReasonCode must exist in TDI_Reason_Mapping.InternalCode
├─ Threshold: 0% violations
├─ Current Status: FAILING (58 violations = 1.16%)
└─ Remediation: [In SOP 4 – Add unmapped codes to reference table]

Control 3: Concatenation & Alphabetization Logic
├─ Implemented: SQL function to sort and concatenate codes
├─ Validation: Spot-check sample of concatenated codes
├─ Example: ['K', 'D', 'E'] → 'DEK' (alphabetically sorted)
└─ Status: NOT YET IMPLEMENTED (design phase)
```

**Compliance Status:** 🔴 **FAILING – CRITICAL RISK**

- **Reason:** 140 canceled policies lack compliant reason codes (82 missing; 58 unmapped)
- **Regulatory Exposure:** TDI may issue audit finding; penalty potential
- **Remediation Timeline:** Must be resolved by June 15, 2026 (TDI report deadline)

---

### REQUIREMENT 2: 30-Day Notice Period

**Regulatory Citation:**  
Texas Insurance Code § 2702 (as amended by HB 2067)  
28 TAC §5.9503(E)

**Statutory Text:**
> "Notice shall be provided within 30 days of the date of the action."

**Requirement in Plain English:**

Written notice must be sent to policyholder within 30 calendar days of:
- Policy status change to "Declined"
- Policy status change to "Canceled"
- Renewal denial (effective date passes; policy not renewed)

**Texas Farm Bureau Implementation:**

```
NOTICE DELIVERY WORKFLOW:

1. ACTION DATE (T+0)
   └─ Policy status changes in PolicyCenter
   └─ Timestamp recorded: CancellationDate or StatusChangeTimestamp
   
2. NOTICE GENERATION (T+1 to T+5 business days)
   ├─ Automated job (nightly) detects new status changes
   ├─ Generates notice letter (via document management system)
   ├─ Outputs to print queue or email system
   ├─ Multiple delivery methods available:
   │  ├─ U.S. Mail (USPS) – Primary method (7–10 day delivery)
   │  ├─ Email – If email on file and policyholder opted in
   │  ├─ Agent Delivery – Through insurance agent (if available)
   │  └─ Electronic Delivery – Via online account (if available)
   └─ Copy retained in compliance file with delivery proof
   
3. DELIVERY CONFIRMATION (T+5 to T+15 business days)
   ├─ USPS: Delivery tracking via Informed Delivery or return receipt
   ├─ Email: Bounced email flagged for alternative delivery
   ├─ Agent: Agent confirms receipt and sign-off
   └─ Timestamp recorded: When notice actually delivered
   
4. COMPLIANCE DOCUMENTATION (Retained 7 years)
   ├─ Notice copy: Retained in compliance file
   ├─ Delivery proof: Confirmation of delivery method + date
   ├─ Audit trail: When notice was generated, sent, and received
   └─ Policy metadata: Reason code(s) included in notice
```

**Supporting Evidence:**

| Evidence | Source | Proves |
|---|---|---|
| **Notice Sample** | Document Mgmt | Notice generated within 5 days of action |
| **Delivery Proof** | USPS Tracking | Notice delivered within 30-day window |
| **Compliance File** | Case Management | Archived notice with metadata |
| **Audit Log** | PolicyCenter | Status change timestamp |

**Data Quality Controls:**

```
Control 1: Action Date Validation (VR-002-002)
├─ Rule: CancellationDate ≤ CURRENT_DATE + 30 (reasonable future limit)
├─ Ensures: Action dates are realistic (not 100 years in future)
└─ Status: ✓ PASSING

Control 2: Notice Generation & Delivery Tracking
├─ Rule: IF Status = 'Canceled' THEN Notice must be generated within 5 days
├─ Monitoring: Daily check of notice queue; escalate if > 5 day delay
└─ Status: ✓ IMPLEMENTED (design phase)
```

**Compliance Status:** ✓ **COMPLIANT (with caveats)**

- **Status:** Workflow and notice template in place
- **Risk:** 30-day countdown begins when notice is SENT, not when received
  - If postal delay occurs, may appear non-compliant
  - Mitigation: Document delivery proof in compliance file
- **Evidence:** Sample notice + delivery proof on file

---

### REQUIREMENT 3: Standardized Reason Codes (A–X)

**Regulatory Citation:**  
28 TAC §5.9503 (Section E, F, G – Statutory Plans)  
TDI Statistical Plan Reference

**Statutory Text:**
> "Insurers shall report reason codes from the following standardized list: [A through X], with specific applicability to Cancellation (C), Non-Renewal (NR), or Declination (D) actions."

**Standardized Reason Codes:**

| Code | Reason Description | Applicable To | TDI Approval |
|------|-------------------|---|---|
| **A** | Aggressive or threatening behavior | C, NR, D | ✓ Approved |
| **B** | Fraud or material misrepresentation | C, NR, D | ✓ Approved |
| **C** | Failure to pay premium | C only | ✓ Approved |
| **D** | Underwriting – Physical condition of property | C, NR, D | ✓ Approved |
| **E** | Underwriting – Geographic/territory restrictions | C, NR, D | ✓ Approved |
| **F** | Underwriting – Prior claims history | C, NR, D | ✓ Approved |
| **G** | Underwriting – Occupancy or use of property | C, NR, D | ✓ Approved |
| **H** | Underwriting – Inability to inspect property | C, NR, D | ✓ Approved |
| **I** | Underwriting – Risk exceeds capacity | C, NR, D | ✓ Approved |
| **J** | Underwriting – Insured value or replacement cost | C, NR, D | ✓ Approved |
| **K** | Underwriting – Roof condition | C, NR, D | ✓ Approved |
| **L** | Underwriting – All other underwriting reasons | C, NR, D | ✓ Approved |
| **M** | Policy no longer available in market | NR only | ✓ Approved |
| **N** | Change in insurer's appetite/market withdrawal | NR, D | ✓ Approved |
| **O** | Insured's request | C only | ✓ Approved |
| **P** | Company/agency relationship change | C, NR | ✓ Approved |
| **Q** | Insured obtained coverage elsewhere | C only | ✓ Approved |
| **R** | Other | C, NR, D | ✓ Approved |
| **X** | Assumption – Reinsurance (TWIA only) | C only | ✓ Approved (TWIA) |

**Requirement in Plain English:**

- Use ONLY the 17 TDI-authorized codes (A–X)
- Do NOT use internal codes, abbreviations, or proprietary descriptions
- When multiple reasons apply, concatenate codes alphabetically
- Example: Codes 'K', 'D', 'E' → Report as 'DEK'

**Texas Farm Bureau Implementation:**

```
MAPPING ARCHITECTURE:

Layer 1: Internal System
├─ PolicyCenter stores internal reason code (e.g., 'UnderwritingDeny', 'Fraud', 'INT_99')
└─ Internal codes based on policy workflow and business logic

Layer 2: Reference Table (TDI_Reason_Mapping)
├─ Maps internal codes to TDI codes
├─ Example mappings:
│  ├─ 'UnderwritingDeny' �� 'D' (Physical condition)
│  ├─ 'Fraud' → 'B' (Fraud/misrepresentation)
│  ├─ 'RoofCondition' → 'K' (Roof condition)
│  └─ 'INT_99' → 'L' (All other underwriting)
└─ Single source of truth for statutory compliance

Layer 3: Cleansed View (vw_pc_policyperiod_cleansed)
├─ Applies TDI_Reason_Mapping lookup
├─ Outputs: Cleansed_TDICode (one of A–X)
├─ Preserves original code for audit trail
└─ Flags remediation status (ORIGINAL vs. REMEDIATED)

Layer 4: Reporting (TDI Statistical Submission)
├─ Column 17: Reason Codes (concatenated alphabetically)
├─ All policies use compliant A–X codes
├─ No internal codes visible to TDI
└─ Audit trail available for verification
```

**Supporting Evidence:**

| Evidence | Location | Proves |
|---|---|---|
| **TDI_Reason_Mapping Table** | GitHub / BigQuery | Complete mapping of all codes |
| **Mapping Documentation** | DOC_04 Data Dictionary | Definition of each code + business logic |
| **Sample Mapping** | Compliance File | Example: Internal 'Fraud' → TDI 'B' |
| **Cleansed View Output** | BigQuery | SQL query showing TDI codes in output |
| **Concatenation Logic** | SQL Script | Function showing alphabetical concatenation |

**Data Quality Controls:**

```
Control 1: Reason Code Existence (VR-002-003)
├─ Rule: IF Status IN ('Canceled', 'NonRenewed', 'Declined') 
│        THEN CancellationReasonCode ∈ {'A','B','C',...'X'}
├─ Validation: LEFT JOIN to TDI_Reason_Mapping; flag if no match
├─ Threshold: 0% violations
└─ Current Status: FAILING (58 unmapped codes = 'INT_99')

Control 2: Multiple Code Concatenation Logic
├─ Rule: If multiple codes apply, sort alphabetically before concatenation
├─ Validation: Spot-check sample of multi-code records
├─ Test Case: ['K', 'D', 'E'] must output as 'DEK' (not 'KDE' or 'EDK')
└─ Status: NOT YET TESTED (design phase)

Control 3: Applicability Constraint
├─ Rule: Code must be applicable to action type
│        Code 'C' (Failure to Pay) only applicable to Cancellation (C)
│        Code 'M' (Policy No Longer Available) only applicable to Non-Renewal (NR)
├─ Validation: Cross-check code applicability against policy status
└─ Status: DESIGN PHASE (SOP 3 rule not yet implemented)
```

**Compliance Status:** 🔴 **FAILING – CRITICAL RISK**

- **Reason:** 58 internal codes (INT_99) not mapped to TDI codeset
- **Evidence Gap:** TDI_Reason_Mapping incomplete; reference table missing mappings
- **Regulatory Exposure:** Submitting unmapped codes to TDI violates statutory requirement
- **Remediation:** Must add missing mappings by May 31, 2026

---

### REQUIREMENT 4: Reason Code Concatenation & Alphabetization

**Regulatory Citation:**  
28 TAC §5.9503(E) – "When multiple reasons apply, list codes in alphabetical order"

**Requirement in Plain English:**

When a policy is canceled/declined/nonrenewed for multiple reasons:
- Identify all applicable reason codes
- Arrange codes in alphabetical order (A-Z)
- Concatenate without separators
- Example: If codes are D, E, K → Report as "DEK"

**Regulatory Rationale:**

Alphabetical concatenation ensures:
- Standardized format (no ambiguity: 'DEK' vs. 'EDK' vs. 'KDE')
- Consistent TDI data collection
- Auditable statistical analysis

**Texas Farm Bureau Implementation:**

```
MULTI-CODE CONCATENATION LOGIC:

Scenario: Roof condition AND location risk AND occupancy change

Step 1: Identify Applicable Codes
├─ Reason 1: "Roof condition deteriorated" → Code 'K'
├─ Reason 2: "Location in high-risk territory" → Code 'E'
├─ Reason 3: "Occupancy changed" → Code 'G'
└─ All 3 reasons apply; multiple codes justified

Step 2: Validate Applicability
├─ Policy Status: 'Canceled'
├─ Code 'K': Applicable to C (Cancellation)? YES ✓
├─ Code 'E': Applicable to C (Cancellation)? YES ✓
└─ Code 'G': Applicable to C (Cancellation)? YES ✓

Step 3: Sort Alphabetically
├─ Input codes: ['K', 'E', 'G']
├─ Sort: ['E', 'G', 'K']
└─ Result: 'EGK'

Step 4: Store & Report
├─ Field: CancellationReasonCode (concatenated) = 'EGK'
├─ TDI Report: Column 17 = 'EGK'
└─ Notice to Customer: "Reasons: E (Geographic/Territory), G (Occupancy), K (Roof Condition)"

Step 5: Audit Trail
├─ Original codes retained: ['K', 'E', 'G'] (for audit verification)
├─ Timestamp: When code was entered
├─ User: Who selected the codes
└─ Remediation_Status: 'ORIGINAL' (not system-generated)
```

**Supporting Evidence:**

| Evidence | Location | Proves |
|---|---|---|
| **SQL Concatenation Function** | Code Repository | Alphabetical sort + concatenation logic |
| **Sample Multi-Code Records** | Compliance File | Example: 'DEK' showing proper concatenation |
| **Test Case Results** | QA Documentation | Verify function produces alphabetically sorted output |
| **Cleansed View Output** | BigQuery Query | Sample data showing concatenated codes in proper order |

**Data Quality Controls:**

```
Control 1: Sort Order Validation
├─ Test Input: ['K', 'E', 'G']
├─ Expected Output: 'EGK'
├─ Actual Output: [Will verify post-implementation]
└─ Status: DESIGN PHASE

Control 2: Spot-Check Audit
├─ Random sample: 100 policies with multiple codes
├─ Manual verification: Are codes in alphabetical order?
├─ Frequency: Monthly (during Q2 TDI report preparation)
└─ Status: PROCEDURE DESIGNED (not yet executed)
```

**Compliance Status:** 🟡 **DESIGN PHASE – NOT YET IMPLEMENTED**

- **Status:** Logic designed; not yet deployed to production
- **Timeline:** Must be implemented by May 31, 2026
- **Risk:** If concatenation logic fails, TDI report will be non-compliant

---

### REQUIREMENT 5: Retroactive Data Capture (Pre-April 1 Actions with Post-April 1 Effective Date)

**Regulatory Citation:**  
28 TAC §5.9503(G) – "If the action effective date falls on or after April 1, 2026, include in Q2 report even if notice sent before April 1, 2026"

**Requirement in Plain English:**

A unique requirement of HB 2067 Phase 1: Include policies where:
- Notice was sent BEFORE April 1, 2026 (pre-implementation)
- Action effective date was ON or AFTER April 1, 2026 (post-implementation)

**Example Scenario:**

```
Policy ABC-123: Auto Insurance Non-Renewal

Timeline:
├─ March 15, 2026: Insurer issues non-renewal notice
│  └─ Pre-HB 2067 era; reason code not captured (legacy process)
├─ April 1, 2026: HB 2067 effective; retroactive capture begins
├─ April 30, 2026: Policy expiration (non-renewal effective date)
│  └─ Action effective date ≥ April 1, 2026
└─ June 15, 2026: TDI Report due

RESULT:
  Policy ABC-123 MUST be included in June 15 TDI report
  EVEN THOUGH notice was sent pre-April 1, 2026
  BECAUSE action effective date (April 30) was post-April 1
```

**Business Logic:**

```
TDI Report Inclusion Rule:

IF (NoticeDate < '2026-04-01') AND (ActionEffectiveDate >= '2026-04-01')
THEN Include in Q2 TDI Report (with reason code, even if retroactive)

Example SQL:
SELECT PolicyNumber, NoticeDate, ActionEffectiveDate, CancellationReasonCode
FROM pc_policyperiod
WHERE Status IN ('Canceled', 'NonRenewed', 'Declined')
  AND CancellationDate < '2026-04-01'  -- Notice sent before HB 2067
  AND ActionEffectiveDate >= '2026-04-01'  -- But effective date post-HB 2067
  AND IsMostRecentModel = 1
ORDER BY ActionEffectiveDate;

Expected Result: Policies from March 15 – March 31 with April+ effective dates
```

**Texas Farm Bureau Implementation:**

```
RETROACTIVE DATA CAPTURE PROCESS:

Step 1: Historical Data Review (April 1–15, 2026)
├─ Query PolicyCenter for all policies with:
│  ├─ Status IN ('Canceled', 'NonRenewed', 'Declined')
│  ├─ CancellationDate between March 1 – March 31, 2026
│  ├─ ActionEffectiveDate on or after April 1, 2026
│  └─ No CancellationReasonCode (legacy pre-HB 2067)
├─ Expected volume: 200–500 policies
└─ Document: Historical data audit report

Step 2: Reason Code Assignment (Retroactive)
├─ For each legacy policy identified:
│  ├─ Review case notes, underwriting file, declination letter
│  ├─ Determine reason code based on available documentation
│  ├─ If reason unclear: Assign 'R' (Other) or 'L' (All other underwriting)
│  └─ Timestamp: When reason code assigned retroactively
├─ Update PolicyCenter: CancellationReasonCode field
└─ Flag: Remediation_Status = 'REMEDIATED' (in cleansed view)

Step 3: Validation & Mapping
├─ Apply TDI_Reason_Mapping lookup to all retroactive codes
├─ Verify all codes map to TDI codeset (A–X)
├─ For any unmapped codes: Add mapping to reference table
└─ Generate report: [# retroactively captured] + [# unmapped]

Step 4: Cleansed View Population
├─ vw_pc_policyperiod_cleansed reflects retroactively assigned codes
├─ Filter: WHERE ActionEffectiveDate >= '2026-04-01'
├─ All retroactive policies included in Q2 TDI report
└─ Audit trail: Original null + remediation timestamp preserved

Step 5: TDI Report Reconciliation
├─ Q2 Report (June 15) includes:
│  ├─ New policies post-April 1 (prospective)
│  ├─ Legacy policies with retroactive codes (pre-April 1 notices)
│  └─ All with compliant reason codes (A–X)
└─ Notation: "X policies included with retroactively assigned reason codes"
```

**Supporting Evidence:**

| Evidence | Proves |
|---|---|
| **Historical Data Audit Report** | Identified retroactive policies |
| **Case Notes Documentation** | Reason code assigned based on underwriting file |
| **Retroactive Reason Code Assignment Log** | When reason assigned; who assigned; timestamp |
| **Before/After Cleansed View Export** | Shows retroactive codes populated |
| **TDI Report Sample** | Includes retroactive policies with reason codes |
| **Audit Trail Preservation** | Original NULL + remediation timestamp |

**Data Quality Controls:**

```
Control 1: Retroactive Scope Validation
├─ Rule: IF CancellationDate < '2026-04-01' AND ActionEffectiveDate >= '2026-04-01'
│        THEN include in retroactive capture
├─ Expected Scope: ~200–500 policies
└─ Spot-Check: Manual review of sample retroactive records

Control 2: Reason Code Validity
├─ Rule: All retroactively assigned codes must exist in TDI_Reason_Mapping
├─ Threshold: 0% unmapped codes
└─ Status: TESTING PHASE

Control 3: Audit Trail Integrity
├─ Rule: Original NULL value preserved; remediation timestamp recorded
├─ Verification: Query shows both original state and remediation action
└─ Duration: Audit trail retained for 7 years
```

**Compliance Status:** ⚠️ **DESIGN PHASE – MEDIUM RISK**

- **Status:** Process designed; not yet executed (retroactive data review starts April 1)
- **Timeline:** Must be completed by May 31, 2026 (2 weeks before TDI deadline)
- **Risk:** If retroactive policies not captured, TDI report will be incomplete
  - TDI may issue audit finding for underreported actions
  - Potential penalty if systematic omission detected

---

### REQUIREMENT 6: Monthly/Quarterly Reporting to TDI

**Regulatory Citation:**  
28 TAC §5.9503(G) (Residential – Monthly by ZIP code)  
28 TAC §5.9504(G) (Auto – Quarterly by ZIP code)  
Market Conduct Annual Statement (MCAS) integration

**Requirement in Plain English:**

Phase 1 requires insurers to submit statistical reports to TDI showing:

**Residential Properties (Monthly):**
- Count of notices sent by ZIP code
- Reason codes for each action type (C, NR, D)
- 60-day indicator (was notice sent within 60 days of action?)
- Reconciliation with MCAS (count of "actualized actions")

**Private Passenger Auto (Quarterly):**
- Same metrics as residential but by quarter instead of month
- Aggregated by ZIP code

**Report Structure (Column 17 – Reason Codes):**

```
TDI STATISTICAL REPORT – COLUMN 17 FORMAT

Example Row (Residential – April 2026):
┌────────┬──────────┬─────────────┬──────────┬─────────┬─────────┐
│ZIP Code│Notices   │Reason Codes │Action    │60-Day   │Valid    │
│        │Sent      │(concatenated)           │Indicator│Rate    │
├────────┼──────────┼─────────────┼──────────┼─────────┼─────────┤
│75201   │3         │DEK,B,L      │C,C,NR    │Y,Y,Y    │3/3      │
│75202   │5         │K,E,G        │C,D,NR    │Y,Y,Y    │5/5      │
│75203   │0         │─            │─         │─        │0/0      │
└────────┴──────────┴─────────────┴──────────┴─────────┴─────────┘

Reason Codes (Column): Alphabetically concatenated (e.g., DEK = D + E + K)
Action Type: C=Cancellation, NR=Non-Renewal, D=Declination
60-Day Indicator: Y=Notice sent within 60 days; N=Late
Valid Rate: Count of valid records / Total records
```

**Report Format Details:**

```
MONTHLY RESIDENTIAL REPORT (Due: 15th of following month)

File Format:
├─ Filename: TFB_HB2067_Residential_YYYYMM.txt
├─ Submission Method: TDI EDGAR system (electronic filing)
├─ Record Layout: Fixed-width or delimited CSV
└─ Encoding: UTF-8, no special characters

Report Columns:

1. Report Month: YYYY-MM (e.g., 2026-04)
2. Company: NAIC Code (Texas Farm Bureau ID)
3. ZIP Code: 5-digit ZIP (e.g., 75201)
4. Notices Sent: Integer count
5. Reason Codes: Concatenated list (e.g., A,B,DEK,L)
6. Action Types: Corresponding actions (C, NR, D)
7. 60-Day Indicator: Y/N/N/Y...
8. Renewal Class: Residential/Commercial
9. Records Valid: Count / Total (e.g., 3/3)
10. Notes: Any data quality issues or exceptions

QUARTERLY AUTO REPORT (Due: 15th after quarter end)

File Format:
├─ Filename: TFB_HB2067_Auto_YYYYQ.txt
├─ Submission Method: TDI EDGAR system
├─ Record Layout: Same as residential
└─ Encoding: UTF-8

Aggregation: Same columns as residential, but aggregated by quarter (not month)
```

**Texas Farm Bureau Implementation:**

```
REPORTING WORKFLOW:

Step 1: Data Extraction (Monthly on 3rd of month)
├─ Query vw_pc_policyperiod_cleansed for prior month
├─ Filter: CancellationDate or StatusChangeDate in [YYYY-MM-01 to YYYY-MM-30]
├─ Extract:
│  ├─ PolicyNumber
│  ├─ ZIP Code (from pc_policylocation)
│  ├─ Cleansed_TDICode (A–X)
│  ├─ Status (C, NR, D)
│  ├─ CancellationDate (for 60-day calculation)
│  └─ Remediation_Status (to track retroactive/system-generated)
└─ Expected Volume: ~2,000 residential policies/month

Step 2: Reason Code Aggregation (3rd of month)
├─ GROUP BY: ZIP Code
├─ AGGREGATE: Concatenate all Cleansed_TDICodes for each ZIP
├─ SORT: Alphabetically (E, K, L → EKL)
└─ Result: CSV with ZIP + codes + counts

Example:
  ZIP 75201: D, E, K (3 codes for 1 policy)
  ZIP 75202: B, L (2 codes for separate policies)

Step 3: 60-Day Indicator Calculation
├─ Rule: IF (TODAY - CancellationDate) <= 60 THEN 60DayIndicator = 'Y'
├─ Purpose: Verify notices sent within regulatory timeframe
├─ Expected: 100% should be 'Y' (all notices within 60 days)
└─ Alert: If any 'N' detected, investigate delay

Step 4: MCAS Reconciliation
├─ Compare: Count of reported actions vs. MCAS "actualized actions"
├─ Expected: Counts should match (no discrepancies)
├─ Validation: Cross-check with financial records
└─ Resolution: If mismatch, investigate root cause

Step 5: File Generation & Validation
├─ Generate: Fixed-width or CSV file per TDI specifications
├─ Validate:
│  ├─ All fields populated (no missing data)
│  ├─ ZIP codes valid (5-digit format)
│  ├─ Reason codes valid (A–X only)
│  ├─ Counts reconcile to source data
│  └─ No special characters or encoding issues
└─ Output: TFB_HB2067_Residential_YYYYMM.txt

Step 6: TDI Submission (by 15th of following month)
├─ Login: TDI EDGAR electronic filing system
├─ Upload: Formatted report file
├─ Verify: TDI confirms receipt (generates confirmation number)
├─ Archive: Retain submission receipt + TDI confirmation
└─ Timeline: April 2026 data submitted by May 15, 2026
              May 2026 data submitted by June 15, 2026

Step 7: Audit Trail & Preservation
├─ Retain:
│  ├─ Extract query (SQL used to generate report)
│  ├─ Source data snapshot (cleansed view export)
│  ├─ Aggregation logic (grouping/concatenation)
│  ├─ Generated report file
│  ├─ TDI submission receipt
│  └─ Any exceptions or data quality issues
└─ Duration: 7 years (per Texas Insurance Code)
```

**Supporting Evidence:**

| Evidence | Location | Proves |
|---|---|---|
| **Report Template** | Compliance File | Format matches TDI specifications |
| **Sample Report** | Test Data | Example report showing proper aggregation |
| **Extract Query** | Code Repository | SQL used to generate report |
| **TDI Submission Receipt** | Email Archive | Confirmation of timely filing |
| **Audit Trail** | Compliance File | Source data, logic, results preserved |

**Data Quality Controls:**

```
Control 1: Data Completeness
├─ Rule: All policies with CancellationDate in report month must be included
├─ Validation: COUNT(extracted) = COUNT(from source)
└─ Threshold: 100% (no missing records)

Control 2: Reason Code Validity
├─ Rule: All codes in report must be A–X (no internal codes)
├─ Validation: Spot-check report for invalid codes
└─ Threshold: 0% invalid codes

Control 3: Concatenation Accuracy
├─ Rule: Multiple codes must be alphabetically ordered
├─ Validation: Sample verification of concatenation logic
└─ Threshold: 100% correct ordering

Control 4: MCAS Reconciliation
├─ Rule: Count of reported actions must match MCAS
├─ Validation: Manual reconciliation
└─ Threshold: 0% discrepancies
```

**Compliance Status:** 🟡 **DESIGN PHASE – MEDIUM RISK**

- **Status:** Report template designed; submission process ready
- **Timing:** First report due June 15, 2026 (April + May data aggregated)
- **Risk:** If data extraction logic has errors, report will be non-compliant
  - TDI may issue audit finding for misreporting
  - Potential correction required + penalty

---

---

## Data Quality Controls Mapped to Statutory Mandates

This section shows how each TFB data quality validation rule (VR-001-001 through VR-005-001) directly enables HB 2067 compliance.

### Compliance Control Mapping

```
STATUTORY REQUIREMENT → DATA QUALITY RULE → CONTROL MECHANISM

Requirement 1: Automatic Written Explanation
├─ Mapped to Rule: VR-001-001 (HB 2067 Mandatory Reason Code)
├─ Validation Logic: IF Status IN ('Canceled', 'NonRenewed', 'Declined')
│                     THEN CancellationReasonCode IS NOT NULL
├─ Proof of Control: Nightly validation query returns 0 violations
├─ Remediation: SOP 4 RCA + manual reason code assignment
���─ Compliance Evidence: Cleansed view with 100% populated reason codes

Requirement 2: 30-Day Notice Period
├─ Mapped to Rule: VR-002-002 (Policy Term Date Logic)
├─ Validation Logic: IF CancellationDate > CURRENT_DATE + 30
│                     THEN flag as unrealistic (system error)
├─ Proof of Control: Nightly validation returns 0 violations
├─ Preventive Mechanism: Guidewire validates date logic at binding
└─ Compliance Evidence: Notice generated within 5 days; delivery proof retained

Requirement 3: Standardized Reason Codes (A–X)
├─ Mapped to Rule: VR-002-003 (TDI Reason Code Mapping)
├─ Validation Logic: IF CancellationReasonCode NOT IN (SELECT InternalCode FROM TDI_Reason_Mapping)
│                     THEN flag as unmapped
├─ Proof of Control: Nightly validation returns 0 violations (target)
├─ Remediation: Update TDI_Reason_Mapping + bulk SQL UPDATE
└─ Compliance Evidence: vw_pc_policyperiod_cleansed.Cleansed_TDICode outputs only A–X

Requirement 4: Reason Code Concatenation & Alphabetization
├─ Mapped to Rule: VR-003-002 (Multi-Code Concatenation)
├─ Validation Logic: IF multiple codes apply
│                     THEN sort alphabetically before concatenation
├─ Proof of Control: Spot-check audit of 100 multi-code records
├─ Test Case: ['K','E','D'] → 'DEK' (alphabetically sorted)
└─ Compliance Evidence: Sample report showing correct concatenation

Requirement 5: Retroactive Data Capture (Pre–April 1 Notices)
├─ Mapped to Rule: VR-004-001 (Historical Data Audit)
├─ Validation Logic: IF CancellationDate < '2026-04-01' 
│                     AND ActionEffectiveDate >= '2026-04-01'
│                     THEN retroactively capture reason code
├─ Proof of Control: Historical audit report + retroactive assignment log
├─ Scope: ~200–500 policies identified; reason codes assigned
└─ Compliance Evidence: Before/after cleansed view showing populated codes

Requirement 6: Monthly/Quarterly TDI Reporting
├─ Mapped to Rule: SQL_09 (Final DQ Scorecard) + Reporting Queries
├─ Validation Logic: Extract + validate → Aggregate by ZIP + reason
│                    → Generate report → Submit to TDI
├─ Proof of Control: Report file validation (schema, field counts, values)
├─ Data Quality Gate: All records pass VR-001-001 & VR-002-003 before reporting
└─ Compliance Evidence: TDI submission receipt + audit trail (7-year retention)
```

---

## Reason Code Framework & TDI Codeset Mapping

### TDI Reason Code Reference Table

**Complete Mapping (TDI_Reason_Mapping Table):**

```
┌──────┬─────────────────────────────────┬──────────┬────────────────────────┐
│ Code │ Reason Description              │ Applies  │ Example Scenario       │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ A    │ Aggressive or threatening       │ C,NR,D   │ Insured threatened     │
│      │ behavior                        │          │ agent during renewal   │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ B    │ Fraud or material               │ C,NR,D   │ Insured misrepresented│
│      │ misrepresentation               │          │ property condition     │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ C    │ Failure to pay premium          │ C only   │ Policy canceled for    │
│      │                                 │          │ nonpayment of premium  │
├──────┼──────���──────────────────────────┼──────────┼────────────────────────┤
│ D    │ Underwriting – Physical         │ C,NR,D   │ Roof condition poor;   │
│      │ condition of property           │          │ foundation issues      │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ E    │ Underwriting – Geographic/      │ C,NR,D   │ High-loss coastal area;│
│      │ territory restrictions          │          │ increased catastrophe │
│      │                                 │          │ exposure               │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ F    │ Underwriting – Prior claims     │ C,NR,D   │ Multiple filed claims  │
│      │ history                         │          │ in past 3 years        │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ G    │ Underwriting – Occupancy or     │ C,NR,D   │ Occupancy changed from │
│      │ use of property                 │          │ residential to rental; │
│      │                                 │          │ seasonal dwelling      │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ H    │ Underwriting – Inability to     │ C,NR,D   │ Insurer unable to      │
│      │ inspect property                │          │ inspect or obtain      │
│      │                                 │          │ third-party valuation  │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ I    │ Underwriting – Risk exceeds     │ C,NR,D   │ Policy limit or        │
│      │ capacity                        │          │ exposure exceeds       │
│      │                                 │          │ company appetite       │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ J    │ Underwriting – Insured value    │ C,NR,D   │ Replacement cost not   │
│      │ or replacement cost             │          │ supported by evidence; │
│      │                                 │          │ underinsurance         │
├─��────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ K    │ Underwriting – Roof condition   │ C,NR,D   │ Roof age > 20 years;   │
│      │                                 │          │ deteriorated shingles  │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ L    │ Underwriting – All other        │ C,NR,D   │ Catch-all for reasons  │
│      │ underwriting reasons            │          │ not listed above       │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ M    │ Policy no longer available in   │ NR only  │ Insurer discontinuing  │
│      │ market                          │          │ line of business or    │
│      │                                 │          │ product class          │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ N    │ Change in insurer's appetite/   │ NR,D     │ Market withdrawal from │
│      │ market withdrawal               │          │ geography or segment   │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ O    │ Insured's request               │ C only   │ Policyholder requested │
│      │                                 │          │ cancellation           │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ P    │ Company/agency relationship     │ C,NR     │ Agent terminated;      │
│      │ change                          │          │ agency realignment     │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ Q    │ Insured obtained coverage       │ C only   │ Insured purchased      │
│      │ elsewhere                       │          │ duplicate coverage;    │
│      │                                 │          │ switched competitors   │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ R    │ Other                           �� C,NR,D   │ Any reason not listed  │
│      │                                 │          │ above                  │
├──────┼─────────────────────────────────┼──────────┼────────────────────────┤
│ X    │ Assumption – Reinsurance        │ C only   │ TWIA assumption        │
│      │ (TWIA only)                     │          │ (Texas Windstorm)      │
└──────┴─────────────────────────────────┴──────────┴────────────────────────┘
```

### Internal Code → TDI Code Mapping Examples

**Texas Farm Bureau's Internal Codes (PolicyCenter):**

```
PolicyCenter Internal Code → TDI Code | Business Reason
───────────────────────────────────────────────────────────

'UnderwritingDeny'        → 'L' | General underwriting decline
'RoofCondition'           → 'K' | Roof age or deterioration
'CoastalLocation'         → 'E' | Geographic/territory risk
'OccupancyChange'         → 'G' | Occupancy or use change
'Fraud'                   → 'B' | Material misrepresentation
'PriorClaims'             → 'F' | Claims history exceeds appetite
'NonPayment'              → 'C' | Failure to pay premium
'CustomerRequest'         → 'O' | Insured requested cancellation
'AgencyChange'            → 'P' | Company/agency relationship change
'MarketWithdraw'          → 'N' | Insurer exiting market
'CoverageUnavailable'     → 'M' | Product discontinued
'INT_99'                  → 'L' | [Legacy placeholder – maps to "Other Underwriting"]
'ThreateneningBehavior'   → 'A' | Aggressive or threatening
'InspectionUnable'        → 'H' | Cannot inspect property
'RiskCapacityExceeded'    → 'I' | Risk exceeds capacity
'UnderinsuredValue'       → 'J' | Insured value disputed
'OtherReason'             → 'R' | Miscellaneous (catch-all)
```

---

## Reporting Deadlines & Phase Implementation

### Phase Implementation Timeline

```
═══════════════════════════════════════════════════════════════════════════════
HOUSE BILL 2067 PHASE IMPLEMENTATION TIMELINE
═══════════════════════════════════════════════════════════════════════════════

PHASE 1: RESIDENTIAL PROPERTY, AUTO, WORKERS' COMP (CURRENT)
├─ Effective Date: April 1, 2026
├─ Coverage Lines: Homeowners, Auto, Workers' Comp
├─ Reporting: Monthly (Residential), Quarterly (Auto/WC)
├─ First Report Due: June 15, 2026 (April + May data)
├─ Status: ACTIVE – TFB IN IMPLEMENTATION
├─ Key Deadlines:
│  ├─ April 1, 2026: HB 2067 effective; reason code capture begins
│  ├─ April 15, 2026: Retroactive data capture completes (pre-April 1 notices)
│  ├─ May 1–31, 2026: First month of full prospective compliance
│  ├─ May 31, 2026: Data validation completes; report generation starts
│  ├─ June 1–14, 2026: Final TDI report file assembled & validated
│  ├─ June 15, 2026: 🔴 DEADLINE – Q2 Report due to TDI (CRITICAL)
│  └─ June 30, 2026: TDI confirms receipt; corrections if needed
│
└─ Risks & Mitigation:
   ├─ Risk: 140 policies lack reason codes (HB 2067 violations)
   │  └─ Mitigation: SOP 4 RCA + Olos fix by May 5, 2026
   ├─ Risk: TDI report not generated in time
   │  └─ Mitigation: Dry-run report scheduled for May 20, 2026
   └─ Risk: Data quality issues detected after submission
      └─ Mitigation: Corrected report resubmitted within 10 days

PHASE 2: COMMERCIAL LINES (PROPOSED)
├─ Proposed Effective Date: 2027 (TBD by TDI)
├─ Coverage Lines: Commercial Property, General Liability, other commercial
├─ Status: PROPOSED RULES (TDI comment period pending)
├─ TFB Action: Monitor TDI rulemaking; plan implementation
└─ Timeline: 12–18 months lead time for system changes

PHASE 3: OTHER P&C LINES (UNDER INVESTIGATION)
├─ Potential Coverage: Ocean Marine, Umbrella, Specialty
├─ Status: UNDER INVESTIGATION (no formal timeline)
├─ TFB Action: Preliminary risk assessment; contingency planning
└─ Timeline: 18–24 months estimated (if implemented)
```

### Critical Deadlines (Phase 1)

| Date | Deadline | Owner | Status | Risk |
|------|----------|-------|--------|------|
| **April 1, 2026** | HB 2067 Effective; Reason Code Capture Begins | Underwriting | ✓ On Track | LOW |
| **April 15, 2026** | Retroactive Data Capture Complete | DQ Analyst | ⚠️ In Design | MEDIUM |
| **May 5, 2026** | Olos Migration Gap Fixed; All Reason Codes Populated | Guidewire | 🔴 AT RISK | HIGH |
| **May 15, 2026** | April 2026 Data Submitted to TDI | Compliance | ⚠️ In Design | MEDIUM |
| **May 31, 2026** | Data Validation Complete; Report Generation Ready | DQ Analyst | ⚠️ In Design | MEDIUM |
| **June 15, 2026** | 🔴 Q2 2026 REPORT DUE TO TDI | Compliance | 🔴 CRITICAL | **CRITICAL** |
| **June 30, 2026** | TDI Confirmation of Receipt & Corrections | TDI | TBD | MEDIUM |

---

## Audit Trail & Evidence Collection Procedures

### Compliance Evidence Repository

**Location:** Shared compliance folder + GitHub repository  
**Retention Period:** 7 years (Texas Insurance Code requirement)  
**Access:** Compliance Officer + Data Governance Committee + Auditors

### Evidence Categories & Preservation

```
CATEGORY 1: SYSTEM CONFIGURATION & DESIGN
├─ Evidence:
│  ├─ Guidewire PolicyCenter validation endpoint deployment (screenshot)
│  ├─ Reason code field configuration (mandatory, dropdown list)
│  ├─ Cleansed view SQL (vw_pc_policyperiod_cleansed definition)
│  ├─ TDI_Reason_Mapping reference table (CSV export)
│  └─ Notice template (customer-facing letter)
├─ Retention: 7 years minimum
└─ Format: PDF screenshots + SQL code + template documents

CATEGORY 2: VALIDATION QUERY RESULTS
├─ Evidence:
│  ├─ VR-001-001: Reason Code Compliance Check (daily execution results)
│  ├─ VR-002-003: TDI Code Mapping Validation (daily execution results)
│  ├─ RCA Results: SQL_05–08 (root cause analysis queries)
│  └─ Scorecard Metrics: SQL_09 (6-dimension DQ scores)
├─ Retention: Daily results for 90 days; monthly summaries for 7 years
└─ Format: CSV exports + SQL query results + execution timestamps

CATEGORY 3: REMEDIATION ACTIVITIES
├─ Evidence:
│  ├─ RCA Post-Mortem Reports (SOP 4 documentation)
│  ├─ Corrective Action Plans (timeline, owner, status)
│  ├─ Data Correction Logs (which policies updated; when; by whom)
│  ├─ Bulk SQL UPDATE Statements (DDL scripts with timestamps)
│  └─ Before/After Validation Results (proof of fix)
├─ Retention: 7 years
└─ Format: RCA PDFs + SQL scripts + update logs + screenshots

CATEGORY 4: TDI REPORTING & SUBMISSIONS
├─ Evidence:
│  ├─ Generated TDI Report Files (monthly/quarterly submissions)
│  ├─ TDI Submission Receipts (confirmation emails)
│  ├─ Report Extract Queries (SQL used to generate each report)
│  ├─ MCAS Reconciliation (count of actualized actions)
│  └─ Audit Trail (data lineage from source to report)
├─ Retention: 7 years (all reports + receipts)
└─ Format: Text files + email receipts + SQL queries + reconciliation documents

CATEGORY 5: CUSTOMER NOTICE DELIVERY
├─ Evidence:
│  ├─ Sample Notice Letters (for each action type: Cancel, Decline, NR)
│  ├─ Delivery Proof Documentation (USPS tracking, email confirmations)
│  ├─ Notice Generation Log (timestamp + policy ID + delivery method)
│  ├─ Compliance Audit Trail (who reviewed; when; status)
│  └─ Customer Service Records (escalations; disputes; resolutions)
├─ Retention: 7 years per Texas Insurance Code § 2753
└─ Format: PDFs + email confirmations + system logs + case notes

CATEGORY 6: AUDIT & INSPECTION RECORDS
├─ Evidence:
│  ├─ TDI Market Conduct Exam: Examination requests & responses
│  ├─ Internal Audits: Compliance audit results; findings; remediation
│  ├─ Third-Party Audits: SOC 2 Type II; state regulatory audits
│  └─ Management Certifications: Executive sign-off on compliance
├─ Retention: 7 years minimum
└─ Format: Exam notices + audit reports + certifications + correspondence
```

### Documentation Management

**Version Control (GitHub):**

```
Repository: TFB-Underwriting-Data-Quality-Lifecycle-
├─ Branch: main
├─ Folder: 01_Governance_and_SOPs/
├─ Files:
│  ├─ DOC_07_HB2067_Compliance_Matrix.md (this document)
│  ├─ DOC_05_Validation_Rules_Registry.md (validation rules)
│  ├─ DOC_06_Complete_SOP_Documentation.md (operating procedures)
│  ├─ DOC_04_Comprehensive_Data_Dictionary.md (metadata)
│  ├─ TDI_Reason_Mapping.csv (reference table)
│  └─ SQL queries (SQL_01–09)
├─ Commit History:
│  └─ All changes tracked; who changed; when; why; commit message
└─ Tags:
   ├─ v1.0 (April 18, 2026 – Initial compliance matrix)
   ├─ v1.1 (May 15, 2026 – Post-April 1 retroactive capture updates)
   └─ v1.2 (May 31, 2026 – Pre-TDI report validation updates)
```

**Compliance File (Shared Drive):**

```
Folder: \\TFB-Compliance\HB2067_Documentation\
├─ 2026_Regulatory_Framework\
│  ├─ House_Bill_2067_Full_Text.pdf
│  ├─ 28_TAC_5.9503_Statutory_Plan_Residential.pdf
│  ├─ 28_TAC_5.9504_Statutory_Plan_Auto.pdf
│  ├─ TDI_Statistical_Report_Instructions.pdf
│  └─ Effective_Dates_Timeline.xlsx
├─ 2026_System_Configuration\
│  ├─ PolicyCenter_Validation_Endpoint_Config.pdf
│  ├─ Reason_Code_Mapping_Reference.xlsx
│  ├─ TDI_Reason_Mapping.csv (v1.2, updated May 31)
│  ├─ Notice_Template_Approved.docx
│  └─ Cleansed_View_SQL_Definition.sql
├─ 2026_Validation_Results\
│  ├─ VR_001_001_HB2067_Compliance_Daily.csv (daily results)
│  ├─ VR_002_003_TDI_Mapping_Daily.csv (daily results)
│  ├─ RCA_Findings_April_2026.pdf
│  ├─ Remediation_Plan_Olos_Migration_Gap.pdf
│  └─ Data_Quality_Scorecard_April_2026.xlsx
├─ 2026_TDI_Reporting\
│  ├─ Q2_2026_Report_April_Data.txt (generated May 10)
│  ├─ Q2_2026_Report_May_Data.txt (generated June 1)
│  ├─ Q2_2026_Final_Submission.txt (submitted June 15)
│  ├─ TDI_Submission_Receipt_June15_2026.pdf
│  └─ MCAS_Reconciliation_Workpaper.xlsx
├─ 2026_Audit_Trail\
│  ├─ Customer_Notice_Sample_Decline.pdf
│  ├─ Customer_Notice_Sample_Cancel.pdf
│  ├─ Customer_Notice_Sample_NonRenewal.pdf
│  ├─ Notice_Delivery_Proof_Sample.pdf (USPS tracking)
│  └─ Notice_Generation_Log_April_2026.csv
└─ 2026_Audit_Records\
   ├─ Management_Compliance_Certification_April_2026.pdf
   ├─ Internal_Audit_Findings_April_2026.pdf
   ├─ Data_Governance_Committee_Minutes_April_18_2026.pdf
   └─ Guidewire_Readiness_Assessment.pdf
```

### Audit Trail Integrity Controls

**Immutability & Change Tracking:**

```
GitHub Version Control:
├─ All document changes tracked by commit hash + date + author
├─ Commit messages describe what changed and why
├─ Change history available for 7+ years
├─ Cannot be modified after commit (immutable)
└─ Complies with audit trail requirements

File Integrity:
├─ Hash values (SHA-256) calculated for all evidence files
├─ Periodic integrity checks verify files unchanged
├─ Any modification detected alerts compliance team
└─ Rotation to write-once media (CD-ROM) for long-term retention

Compliance Certifications:
├─ Data Governance Committee certifies accuracy of compiled evidence
├─ Compliance Officer signs off on completeness
├─ Executive management acknowledges responsibility
└─ Certifications retained with evidence
```

---

## Financial & Regulatory Risk Assessment

### Risk Matrix

**Regulatory Penalties (If Non-Compliant):**

```
VIOLATION TYPE              │ PENALTY RANGE  │ LIKELIHOOD │ TFB RISK
────────────────────────────┼────────────────┼────────────┼──────────
Missing Reason Codes        │ $1,000–$5,000  │ MEDIUM     │ Medium
(per violation)             │ (×140 = $140K) │            │

Incomplete TDI Report       │ $5,000–$10,000 │ HIGH       │ High
(if submitted incomplete)   │                │            │

Market Conduct Finding      │ Public finding │ HIGH       │ HIGH
(documented in TDI records) │ + remediation  │            │

Customer Refund Liability   │ $50–$500 each  │ MEDIUM     │ Medium
(if 140 customers request)  │ (×140 = $70K)  │            │

Reputational Damage         │ Incalculable   │ HIGH       │ MEDIUM
(market perception impact)  │                │            │
```

### Current Risk Assessment

**As of April 18, 2026:**

| Risk Factor | Status | Score | Mitigation |
|---|---|---|---|
| **HB 2067 Compliance Readiness** | 🔴 FAILING | 6/10 | SOP 4 RCA + Olos fix (Due May 5) |
| **Data Quality Validation** | ✓ IMPLEMENTED | 9/10 | Daily monitoring; alerting active |
| **Reason Code Population** | 🔴 CRITICAL | 3/10 | 140 violations; retroactive capture (May) |
| **TDI Report Generation** | ⚠️ DESIGN PHASE | 5/10 | Report template ready; testing required |
| **Customer Notice Process** | ✓ ACTIVE | 8/10 | Automated; delivery proof captured |
| **Audit Trail & Evidence** | ⚠️ PARTIAL | 6/10 | System in place; documentation ongoing |

**Overall Compliance Risk Level:** 🔴 **HIGH**

- **Primary Risk:** 140 policies lack compliant reason codes (2.8% of dataset)
- **Regulatory Exposure:** TDI audit finding with penalty potential
- **Financial Impact:** $140K–$210K (if full penalty range applied)
- **Timeline Risk:** 58 days to TDI deadline (June 15); limited remediation window
- **Mitigation Status:** In progress; high probability of resolution by deadline

---

## Compliance Certification & Sign-Off

### Management Certifications

**TFB Executive Management Acknowledgment:**

```
═══════════════════════════════════════════════════════════════════════════════
HOUSE BILL 2067 COMPLIANCE CERTIFICATION
April 18, 2026
═══════════════════════════════════════════════════════════════════════════════

We, the undersigned, certify that:

1. STATUTORY MANDATE UNDERSTANDING
   ✓ Texas Farm Bureau Casualty Insurance Company has reviewed House Bill 2067
     and understands the statutory requirement to provide automatic written
     explanations for policy declinations, cancellations, and non-renewals
     effective April 1, 2026.

2. SYSTEM IMPLEMENTATION STATUS
   ✓ We have implemented systems and processes to capture, validate, and report
     standardized TDI reason codes (A–X) for all covered actions.
   ✓ Validation rules (19 total) are deployed to detect compliance violations.
   ✓ Cleansed data views provide audit-compliant data for TDI reporting.

3. DATA QUALITY CONTROLS
   ✓ Daily automated validation executes to ensure 100% reason code compliance.
   ✓ Root cause analysis procedures document and resolve any violations.
   ✓ SOP documentation establishes operational procedures for ongoing compliance.

4. CUSTOMER NOTICE COMPLIANCE
   ✓ Automated workflow generates written notices for all covered actions.
   ✓ Notices include TDI-compliant reason codes mapped to statutory definitions.
   ✓ Delivery proof is retained per 7-year retention requirement.

5. TDI REPORTING READINESS
   ✓ Monthly/quarterly statistical reports are designed per 28 TAC §5.9503/5.9504.
   ✓ First report (Q2 2026 – April/May data) will be submitted by June 15, 2026.
   ✓ Audit trail documentation is preserved for regulatory inspection.

6. KNOWN ISSUES & REMEDIATION
   ✓ We acknowledge 140 policies currently lack compliant reason codes
     (pre-implementation or unmapped internal codes).
   ✓ RCA is underway per SOP 4 procedures.
   ✓ Remediation plan targets complete resolution by May 31, 2026.
   ✓ All issues will be resolved before Q2 TDI reporting deadline (June 15, 2026).

7. RISK ACKNOWLEDGMENT
   ✓ We acknowledge regulatory risk if HB 2067 requirements are not met.
   ✓ We commit to full compliance by June 15, 2026 TDI deadline.
   ✓ We will proactively disclose any issues to TDI if compliance cannot be achieved.

8. ONGOING COMMITMENT
   ✓ We commit to maintaining HB 2067 compliance on an ongoing basis.
   ✓ Data quality controls will remain active indefinitely.
   ✓ Annual compliance audits will verify continued adherence to statutory requirements.


SIGNED AND ACKNOWLEDGED:

CEO / Executive Officer:     _____________________________  Date: __________
(Print Name & Title)

Chief Compliance Officer:    _____________________________  Date: __________
(Print Name & Title)

Data Governance Committee:   _____________________________  Date: __________
Chair (Print Name & Title)

CFO / Financial Officer:     _____________________________  Date: __________
(Print Name & Title – for risk/financial impact acknowledgment)
```

---

## Appendix: Reference Materials

### Regulatory References

**Texas Statutes:**
- House Bill 2067 (89th Leg., 2025) – [Full text](https://www.capitol.texas.gov/)
- Texas Insurance Code § 2702 (Notice of Declination, Cancellation, Non-Renewal)
- Texas Insurance Code § 2753 (Cancellation Provisions)
- Texas Insurance Code § 544.353 (Prohibited Bases for Cancellation)

**Texas Administrative Code:**
- 28 TAC §5.9503 (Statistical Plans – Residential Risks)
- 28 TAC §5.9504 (Statistical Plans – Private Passenger Auto)
- 28 TAC §5.7015 (Record Retention & Audit Trail)
- 28 TAC §1.705 (Market Conduct Annual Statement – MCAS Integration)

**TDI Resources:**
- TDI Statistical Plan Instructions: https://www.tdi.texas.gov/rules/
- Market Conduct Annual Statement (MCAS) Guide: https://www.tdi.texas.gov/
- TDI EDGAR Filing System: https://www.tdi.texas.gov/edgar/

---

## Document Control & Version History

| Element | Value |
|---------|-------|
| **Document ID** | DOC_07_HB2067_Compliance_Matrix |
| **Version** | 1.0 |
| **Date Created** | April 18, 2026 |
| **Last Reviewed** | April 18, 2026 |
| **Owner** | Compliance Officer |
| **Custodian** | Daniel Rodriguez III, Data Quality Analyst II |
| **Classification** | Internal – Confidential & Regulatory |
| **Distribution** | Data Governance Committee, Compliance, Executive Management, Auditors |
| **Review Cycle** | Quarterly (ongoing compliance verification) |
| **Next Review** | July 18, 2026 (post-Q2 TDI deadline) |
| **Retention** | 7 years (Texas Insurance Code requirement) |

---

**For questions regarding HB 2067 compliance or this matrix, contact the Compliance Officer or Data Governance Committee.**