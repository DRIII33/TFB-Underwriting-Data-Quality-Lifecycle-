# Comprehensive Data Dictionary
## TFB Underwriting Data Quality Lifecycle & HB 2067 Compliance

**Document Owner:** Data Governance Committee  
**Author:** Daniel Rodriguez III, Data Quality Analyst II  
**Date:** April 18, 2026  
**Version:** 1.0  
**Classification:** Internal – Confidential

---

## Table of Contents

1. [Introduction](#introduction)
2. [Dictionary Conventions & Metadata Framework](#dictionary-conventions--metadata-framework)
3. [Source System Tables (Raw Layer)](#source-system-tables-raw-layer)
4. [Reference Tables & Master Data](#reference-tables--master-data)
5. [Cleansed Views (Golden Layer)](#cleansed-views-golden-layer)
6. [Automated Issues Log & Monitoring](#automated-issues-log--monitoring)
7. [Data Quality Scorecard Schema](#data-quality-scorecard-schema)
8. [Data Lineage & Transformation Mappings](#data-lineage--transformation-mappings)
9. [Retention Policies & Compliance](#retention-policies--compliance)
10. [Glossary of Terms](#glossary-of-terms)

---

## Introduction

### Purpose

This Data Dictionary provides comprehensive metadata documentation for all tables, views, and fields within the TFB Underwriting Data Quality Lifecycle project. It serves as the **authoritative single source of truth** for:

- Data definitions and business meaning
- Field-level data types and constraints
- Validation rules and acceptability criteria
- Data ownership and stewardship
- Lineage from source to reporting
- Quality rules applied to each attribute
- Compliance implications (HB 2067, TDI, GDPR/DORA)

### Scope

This dictionary covers:

**Source Systems (Raw Layer):**
- Guidewire PolicyCenter tables (pc_policyperiod, pc_policylocation, pc_vehicle)
- Guidewire BillingCenter tables (bc_policy)
- Reference tables (TDI_Reason_Mapping)

**Cleansed Views (Golden Layer):**
- vw_pc_policyperiod_cleansed
- vw_pc_policylocation_cleansed
- vw_pc_vehicle_cleansed
- vw_financial_reconciliation

**Monitoring & Quality Artifacts:**
- vw_automated_issues_log
- Data Quality Scorecard metrics

### Intended Audience

- **Data Quality Analysts** – Query development, rule implementation
- **Database Administrators** – Schema management, performance tuning
- **Business Stakeholders** – Understanding data definitions and quality metrics
- **Compliance Officers** – Regulatory mapping and audit trail verification
- **Data Governance Committee** – Policy development and change approval

---

## Dictionary Conventions & Metadata Framework

### Field Documentation Structure

Each field is documented with the following standardized metadata:
