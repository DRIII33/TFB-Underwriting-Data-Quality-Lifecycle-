# TFB Underwriting Data Quality Lifecycle
## End-to-End Data Quality & Governance Framework for Guidewire Olos Integration & HB 2067 Statutory Compliance

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Project Overview](#project-overview)
3. [Strategic Context & Regulatory Landscape](#strategic-context--regulatory-landscape)
4. [Repository Structure & Navigation](#repository-structure--navigation)
5. [Data Quality Framework](#data-quality-framework)
6. [Core Components](#core-components)
7. [Technical Architecture](#technical-architecture)
8. [Prerequisites & Setup](#prerequisites--setup)
9. [Quick-Start Guide](#quick-start-guide)
10. [Execution Workflow](#execution-workflow)
11. [Key Findings & Results](#key-findings--results)
12. [Data Quality Scorecard](#data-quality-scorecard)
13. [Standard Operating Procedures (SOPs)](#standard-operating-procedures-sops)
14. [Troubleshooting & Support](#troubleshooting--support)
15. [Additional Resources](#additional-resources)

---

## Executive Summary

The **TFB Underwriting Data Quality Lifecycle** project represents a comprehensive, end-to-end framework designed to ensure the integrity, accuracy, and statutory compliance of underwriting data within Texas Farm Bureau Casualty Insurance Company's Guidewire Olos ecosystem. 

**Project Date:** April 17, 2026  
**Author:** Daniel Rodriguez III, Data Quality Analyst II  
**Organization:** Underwriting Data Office, Texas Farm Bureau Casualty Insurance Company  
**Location:** 7420 Fish Pond Road, Waco, TX 76710

### Key Achievement Highlights

- **1,302 Data Anomalies Detected** across six dimensions of data quality using automated profiling and validation
- **140 Critical HB 2067 Compliance Failures** intercepted before propagation to statutory reporting systems
- **594 Catastrophe Modeling Gaps** identified in coastal risk geocoding, linked to HazardHub API integration issues
- **Golden Layer Cleansed Views** established to provide audit-compliant data remediation without compromising raw audit trails
- **Baseline Data Quality Scorecard** established:
  - **Accuracy Score:** 93.43%
  - **Completeness Score:** 97.85%
  - **Validity Score:** 94.71%

---

## Project Overview

### Organizational Context

Established in 1933 and headquartered in Waco, Texas, Texas Farm Bureau Casualty Insurance Company manages insurance portfolios across 214 Texas counties with 850+ multi-line agents serving 538,064 member-families. With total assets exceeding $982.5 million (2024), the organization maintains an **A (Excellent)** financial rating from A.M. Best.

The Underwriting Data Office operates as the **vital nexus between technical infrastructure and regulatory compliance**, particularly in response to:

- **House Bill 2067** (89th Texas Legislature, 2025) - Mandate for automatic written disclosure of coverage denial reasons
- **Texas Department of Insurance (TDI)** statistical reporting requirements
- **Guidewire Olos Release** (December 2025) deployment within PolicyCenter
- **Informatica IDMC Cloud Migration** - Transition from legacy PowerCenter (end-of-life March 31, 2026)

### Project Vision

Transform the enterprise from **reactive data cleansing** to **proactive, autonomous compliance enforcement** through:

1. Systematic data quality assessment across all underwriting processes
2. Automated validation gates that prevent non-compliant data from entering production systems
3. Root cause analysis frameworks that eliminate systemic data quality failures
4. Golden layer cleansed views that provide audit-compliant remediation
5. Executive-grade KPI monitoring and real-time alerting

---

## Strategic Context & Regulatory Landscape

### House Bill 2067: Statutory Mandate

Effective **April 1, 2026**, HB 2067 requires property and casualty insurers to:

- Automatically provide written explanations for policy declinations, cancellations, and non-renewals
- Replace customer-requested disclosure model with **mandatory proactive notification**
- Submit monthly (residential) or quarterly (auto) reports by ZIP code to Texas Department of Insurance

#### Implementation Phases

| Phase | Coverage Scope | Effective Date | Status |
|-------|---|---|---|
| Phase 1 | Residential Property, Private Auto, Workers' Comp | April 1, 2026 | **ACTIVE** - First report due June 15, 2026 |
| Phase 2 | Commercial Lines | TBD 2026 | Proposed rules pending |
| Phase 3 | Other P&C Lines | Under investigation | Timeline TBD |

#### Reason Code Framework

All cancellation/declination/non-renewal decisions must map to standardized TDI reason codes (A–X). These 17 codes are categorized by applicability:

- **Cancellation (C):** A, B, C, D, E, F, G, H, I, J, K, L, O, P, Q, R, X
- **Non-renewal (NR):** A, B, D, E, F, G, H, I, J, K, L, M, N, P, R
- **Declination (D):** A, B, D, E, F, G, H, I, J, K, L, N, R

**Critical Validation Requirement:** When multiple reasons apply, codes must be concatenated in **alphabetical order** and reconciled against both policyholder notices and statutory submissions.

---

## Repository Structure & Navigation

