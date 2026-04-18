# Validation Rules Registry
## Core Business Logic for Data Quality Enforcement

**Document Owner:** Data Governance Committee  
**Author:** Daniel Rodriguez III, Data Quality Analyst II  
**Date:** April 18, 2026  
**Version:** 1.0  
**Classification:** Internal – Confidential  
**Related SOP:** SOP 3 (Validation Rule Execution)

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Registry Overview & Structure](#registry-overview--structure)
3. [Rule Categories & Classification](#rule-categories--classification)
4. [Master Rule Registry](#master-rule-registry)
5. [Rule Implementation Details](#rule-implementation-details)
6. [Threshold & Acceptance Criteria](#threshold--acceptance-criteria)
7. [Rule Execution Scheduling](#rule-execution-scheduling)
8. [Exception & Override Procedures](#exception--override-procedures)
9. [Rule Performance Metrics](#rule-performance-metrics)
10. [Maintenance & Version Control](#maintenance--version-control)

---

## Executive Summary

### Purpose

The **Validation Rules Registry** is the authoritative repository of all data quality rules deployed across the TFB Underwriting Data Quality Lifecycle. It codifies business requirements into executable logic, transforming regulatory mandates (HB 2067, TDI) and operational standards into systematic validation gates.

### Scope

This registry covers:

- **5 Primary Rule Categories** (Mandatory Fields, Value Constraints, Format Standards, Referential Integrity, Logical Checks)
- **19 Individual Validation Rules** deployed via SQL, Informatica CDQ, or Guidewire validation endpoints
- **Execution schedules** (real-time, nightly, weekly)
- **Acceptance thresholds** (0% for critical; 5% for non-critical)
- **Escalation protocols** based on failure rates
- **Performance tracking** (rule effectiveness, false positive rates)

### Key Metrics

| Metric | Value |
|--------|-------|
| **Total Rules Deployed** | 19 |
| **CRITICAL Rules** | 7 |
| **HIGH Priority Rules** | 8 |
| **MEDIUM Priority Rules** | 4 |
| **Current Rule Failure Rate** | 6.57% (above 1% acceptance standard) |
| **Target Rule Failure Rate** | < 1% |
| **Rules Detecting Remediable Issues** | 14 / 19 |
| **Rules Requiring Manual Review** | 5 / 19 |

---

## Registry Overview & Structure

### Rule Documentation Template

Each rule is documented with standardized metadata:
