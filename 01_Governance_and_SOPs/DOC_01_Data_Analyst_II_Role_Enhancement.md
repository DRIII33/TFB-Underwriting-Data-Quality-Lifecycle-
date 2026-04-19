Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
 
Strategic Analysis and Operational Framework: Data Quality Analyst II within the Texas Farm Bureau Underwriting 
Data Office 
Historical Foundation and Strategic Context of the Waco Command Center 
The 2026 Regulatory Paradigm: House Bill 2067 and TDI Compliance 
Standardized Reason Codes for Residential Risk 
Technological Infrastructure: Guidewire Olos and Informatica IDMC 
Guidewire Olos Release Capabilities 
Informatica Intelligent Data Management Cloud (IDMC) 
End-to-End Data Quality Lifecycle: Operational Flow 
Ingestion and Profiling 
Validation Rule Execution 
Issue Detection and Root Cause Analysis (RCA) 
Correction and Remediation 
Enhanced Standard Operating Procedures (SOPs) for the Underwriting Data Office 
SOP 1: End-to-End Data Quality Lifecycle Management 
SOP 2: Data Profiling and Statistical Assessment 
SOP 3: Validation Rule Execution 
SOP 4: Root Cause Analysis and Remediation 
SOP 5: Data Issue Management and Severity Escalation 
SOP 6: Data Quality KPI Monitoring and Reporting 
SOP 7: Data Governance Execution and Data Dictionary Maintenance 
SOP 8: SDLC Support and Release Readiness 
Advanced SQL Methodology for Data Quality Analysis 
The Application of Set Theory 
Aggregate Profiling for Data Health 
Exhaustive SQL Library for Underwriting Data Quality 
1. Statutory Compliance Audit: HB 2067 Reason Code Reconciliation 
2. Data Integrity: Detecting "Orphan" Risks 
3. Data Cleansing: Normalizing Vehicle Identification Numbers (VIN) 
4. Geocoding Accuracy Audit for Coastal Risk 
5. Aggregate Profiling: Monitoring Daily Ingest Volume Spikes 
6. Cross-System Reconciliation: PolicyCenter vs. BillingCenter 
Operational Rhythm and Failure Response Playbooks 
Daily/Weekly Cadence 
Failure Playbooks 
Data Quality Dimensions and Performance Metrics 
Advanced Technical Applications: Agentic Data Management 
Autonomous Remediation and Risk Mitigation 
Human-in-the-Loop Governance 
Works cited 
 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
Strategic Analysis and Operational 
Framework: Data Quality Analyst II within 
the Texas Farm Bureau Underwriting Data 
Office 
Historical Foundation and Strategic Context of the Waco 
Command Center 
The operational landscape of the Texas Farm Bureau Casualty Insurance Company as of April 17, 2026, 
represents a sophisticated convergence of historical agrarian advocacy and the modern, rigorous 
requirements of property and casualty insurance data management.1 Based in the Waco home office at 
7420 Fish Pond Road, the Underwriting Data Office (UDO) functions as the vital nexus between 
technical infrastructure and regulatory compliance, particularly in light of the transformative House Bill 
2067 mandates.1 The role of the Data Quality Analyst II is central to this architecture, serving not merely 
as a technical specialist but as a guardian of the high-fidelity data required to maintain the organization’s 
"Excellent" financial rating and its commitment to over 500,000 member-families.1 
To evaluate the current data imperatives at Texas Farm Bureau Casualty, it is necessary to examine the 
provenance of its data assets. Established in 1933 during the economic volatility of the Great Depression, 
the Texas Farm Bureau emerged as a unified advocate for the state’s agricultural producers.1 The 1938 
relocation of headquarters from Dallas to Waco was a strategic maneuver to align the organization with 
the geographic hub of Central Texas agriculture, ensuring the organization remained physically and 
culturally proximate to the farmers it served.1 The subsequent formalization of the Casualty Insurance 
Company in 1952 established a member-governed structure that prioritizes long-term stability and 
personal service over external shareholder interests.1 
As of April 2026, the organization manages a complex ecosystem involving 214 counties and over 850 
multi-line agents.1 The transition from legacy paper-based record-keeping to a centralized digital 
infrastructure fueled by Guidewire Cloud environments defines the current technical epoch.1 The 
accuracy of these records is a prerequisite for justifying rate changes within the Texas "file-and-use" 
system, where actuarial models must respond to extreme weather loss events that have exceeded $1 
billion with increasing frequency over recent decades.1 Consequently, data quality is viewed as a risk 
mitigation engine intended to prevent adverse selection and ensure the solvency of the member-focused 
model.1 
 
Organizational Attribute 
Metric / Detail (As of April 
Source 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
2026) 
Year Founded 
1933 (Parent); 1952 
(Insurance) 
1 
Total Member-Families 
538,064 
1 
A.M. Best Rating 
A (Excellent); Negative 
Outlook (as of Sept 2025) 
1 
Agent Force 
850+ Multi-line Agents 
1 
County Presence 
214 Physical; 205 
Self-Governed 
1 
Total Assets (2024) 
Approximately $982.5 Million 
1 
Total Revenue (2024) 
Approximately $34.2 Million 
8 
Net Assets (2024) 
Approximately $968.7 Million 
8 
The strategic context in 2026 is further complicated by severe financial strain within the agricultural 
sector. A nationwide survey conducted in April 2026 revealed that 70 percent of farmers cannot afford 
sufficient fertilizer for the 2026 season due to a 30% rise in nitrogen fertilizer prices and a 20-40% 
increase in combined fuel and fertilizer costs.9 For an organization like Texas Farm Bureau, which is 
intrinsically linked to the financial health of producers, these macroeconomic pressures underscore the 
necessity for precise underwriting and data integrity. The Data Quality Analyst II must ensure that the 
data reflecting the "Voice of Texas Agriculture" is accurate enough to support the resilient but stressed 
membership.4 
The 2026 Regulatory Paradigm: House Bill 2067 and TDI 
Compliance 
The primary challenge facing the Underwriting Data Office in April 2026 is the implementation of House 
Bill (HB) 2067, passed during the 89th Texas Legislature in 2025.1 This legislation significantly altered 
the reporting obligations for property and casualty insurers by replacing the requirement for policyholders 
to request a written explanation for adverse coverage decisions with an automatic disclosure obligation.1 
Insurers are now legally mandated to proactively provide written reasons for declinations, cancellations, 
or non-renewals.1 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
The Texas Department of Insurance (TDI) has adopted a phased approach for HB 2067, with Phase 
1—effective April 1, 2026—focusing on residential property and private passenger automobile 
insurance.1 This regulatory shift transforms the capture of reason codes from a customer service function 
into a high-rigor data reporting mandate.1 Under Sections E, F, and G of the revised Texas Statistical 
Plans, insurers must submit monthly (residential) or quarterly (auto) reports by ZIP code to monitor 
geographic market trends and underwriting decisions.1 
 
Implementation 
Phase 
Coverage Scope 
Status / Key 
Deadlines 
Source 
Phase 1 
Residential Property, 
Private Auto, 
Workers' Comp 
Effective 4/1/2026; 
First Report Due 
6/15/2026 
1 
Phase 2 
Commercial Lines 
Rules proposed in 
2026 
1 
Phase 3 
Other P&C lines 
(Ocean Marine, 
Umbrella, etc.) 
Under investigation as 
of 4/2026 
1 
The technical specifications for these reports require a monthly summary of notices sent, including a 
60-day indicator (Column 18) and a concatenated alphabetical list of standardized reason codes.1 Section 
G requires a count of "actualized actions" that must reconcile with the NAIC Market Conduct Annual 
Statement (MCAS).1 A critical operational challenge involves the retroactive data capture requirement: 
the first report due June 15, 2026, must include non-renewal notices sent before April 1, 2026, if the 
action effective date falls on or after April 1, 2026.1 
Standardized Reason Codes for Residential Risk 
The Data Quality Analyst II must ensure that reason codes generated by automated underwriting systems 
are mapped precisely to the TDI’s shorthand codes.1 When multiple reasons apply, the codes must be 
concatenated in alphabetical order.1 Discrepancies between the notice sent to the policyholder and the 
statistical file submitted to TDI are detectable and may lead to regulatory penalties.1 
 
Code 
Reason Description 
Applies To 
Source 
A 
Aggressive or 
threatening behavior 
C, NR, D 
1 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
B 
Fraud or material 
misrepresentation 
C, NR, D 
1 
C 
Failure to pay 
premium 
C 
1 
D 
Underwriting - 
Physical condition of 
property 
C, NR, D 
1 
E 
Underwriting - 
Geographic/territory 
restrictions 
C, NR, D 
1 
F 
Underwriting - Prior 
claims history 
C, NR, D 
1 
G 
Underwriting - 
Occupancy or use of 
property 
C, NR, D 
1 
H 
Underwriting - 
Inability to inspect 
property 
C, NR, D 
11 
I 
Underwriting - Risk 
exceeds capacity 
C, NR, D 
11 
J 
Underwriting - 
Insured value or 
replacement cost 
C, NR, D 
11 
K 
Underwriting - Roof 
condition 
C, NR, D 
1 
L 
Underwriting - All 
other underwriting 
reasons 
C, NR, D 
1 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
M 
Policy no longer 
available in market 
NR 
1 
N 
Change in insurer's 
appetite/market 
withdrawal 
NR, D 
1 
O 
Insured's request 
C 
11 
P 
Company/agency 
relationship change 
C, NR 
11 
Q 
Insured obtained 
coverage elsewhere 
C 
11 
R 
Other 
C, NR, D 
11 
X 
Assumption 
Reinsurance (TWIA 
only) 
C 
1 
(
 Cancellation, 
 Non-renewal, 
 Declination) 
The implications of this reporting structure are profound for data integrity. The plan explicitly states that 
certain claims, such as those caused by natural causes or those prohibited under Texas Insurance Code 
§544.353, may never be counted as chargeable claims.11 Furthermore, the amendments to 28 TAC 
§5.7015, effective September 1, 2026, prohibit insurers from using "short rate" provisions, requiring all 
unearned premiums to be calculated pro rata.18 The Analyst serves as the primary auditor of this pipeline, 
utilizing SQL to reconcile notice tables with statutory submission tables and ensure that consumer 
disclosures reflect the actual reported codes.1 
Technological Infrastructure: Guidewire Olos and 
Informatica IDMC 
The Underwriting Data Office operates within a sophisticated technical stack designed to eliminate data 
silos and manual processes.1 As of April 17, 2026, the core system is the Olos release of Guidewire 
PolicyCenter, which reached availability in December 2025.1 This platform is integrated with Informatica 
Intelligent Data Management Cloud (IDMC) for data quality orchestration and Microsoft Dynamics 365 
for agency relationship management.1 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
Guidewire Olos Release Capabilities 
The Olos release introduces critical validation and performance features that represent a significant 
advancement over previous versions. One primary feature is the "Validation endpoint support for 
PolicyCenter," allowing for the creation of request-and-response validation flows triggered by application 
events.1 This allows the Data Quality Analyst II to implement automated checks that execute before a 
policy is bound, ensuring that third-party risk scores, such as those from HazardHub, are correctly 
mapped into the rating algorithm.1 
Olos also features "Spotter," a conversational search interface (formerly branded as Sage) that utilizes AI 
to allow underwriters and analysts to query the data model using natural language.1 This integration of 
"AI Highlights" provides a strategic advantage by automatically summarizing key drivers behind KPI 
changes on Liveboards.1 For instance, the system can identify that a specific ZIP code is seeing an 
unexpected spike in "Roof Condition" cancellations by analyzing the first five time-series KPIs in a 
dashboard tab.1 This automation reduces the turnaround time for data-driven decisions from days to 
minutes.1 
 
Guidewire Olos 
Feature 
Function in 
Underwriting Data 
Technical Impact 
Source 
Spotter (AI Search) 
Natural language 
queries for data 
models 
Conversational 
follow-up and 
accuracy coaching 
22 
AI Highlights 
Automated summary 
of KPI drivers 
Identifies outliers in 
Liveboard time-series 
20 
Validation Endpoints 
Trigger checks via 
App Events 
Validates connections 
without payload 
restructuring 
22 
Post-Process 
Endpoints 
Solution execution 
post-results 
Parallel processing for 
third-party 
integrations 
22 
APD Conversion 
Product definition 
shifting to cloud 
Reduces technical 
debt and maintenance 
overhead 
6 
Informatica Intelligent Data Management Cloud (IDMC) 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
Informatica IDMC serves as the industrial-strength engine for data cleansing and metadata observability.1 
With the CLAIRE AI engine, IDMC provides automated metadata management and lineage tracking, 
essential for maintaining the audit compliance required by HB 2067.1 The transition to IDMC’s 
consumption-based IPU (Informatica Pricing Units) model represents an operational shift for the 
department, requiring the Analyst to monitor burn rates across different services.1 This is particularly 
urgent as standard support for the legacy on-premise PowerCenter ended on March 31, 2026, forcing a 
mandatory migration to the cloud platform.26 
 
Informatica Service 
Function in 
Underwriting Data 
Metering Context 
(IPU) 
Source 
CDI (Integration) 
Real-time data 
movement to 
DataHub 
Scaled by Secure 
Agent and CDC usage 
1 
CDQ (Quality) 
Profiling and Rule 
Execution 
Volume-based 
scaling; higher rate 
than CDI 
1 
CLAIRE Engine 
AI-powered mapping 
and recommendations 
Consumption-based 
AI optimization 
1 
CLAIRE GPT 
Generative AI for 
data tasks 
Trial at no cost 
through Jan 31, 2027 
24 
MDM SaaS 
Master Data 
Management 
(Customer 360) 
Hybrid model (IPU + 
per-domain records) 
1 
The Analyst utilizes IDMC to profile data in real-time as it moves from legacy systems to the Guidewire 
DataHub, ensuring that Customer 360 initiatives are based on a "golden record" that has been 
de-duplicated and standardized.1 This is critical for cross-selling and upselling initiatives, as it allows for 
a comprehensive view of relationships between customers, policies, and claims.1 
End-to-End Data Quality Lifecycle: Operational Flow 
The Texas Farm Bureau Casualty Data Quality Analyst II framework defines a comprehensive lifecycle 
for underwriting data, beginning with ingestion and proceeding through profiling, validation, correction, 
and monitoring.1 Each step is supported by specific tools and methodologies designed to ensure that data 
is "fit for purpose" in a highly regulated environment.1 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
Ingestion and Profiling 
Data ingestion involves loading raw underwriting data—policy records, exposures, financials—into a 
staging area or data lake.1 External reference data, including agent lists, rating manuals, and TDI 
statistical tables, are also imported.1 The first operational step is column-level profiling to establish 
baseline metrics.1 This involves computing counts of null values, distinct value counts, and outlier 
detection.1 
Profiling is not a one-time event but a continuous diagnostic tool.1 The Analyst compares current metrics 
against historical baselines to identify "data drift," which may indicate an upstream change in system 
logic or agent entry behavior.1 For example, a sudden jump in null rates for "Roof Age" following a 
system update would be caught during this phase.1 Effective profiling involves examining the structure, 
content, and relationships within the data to identify areas needing improvement.30 
Validation Rule Execution 
Based on profiling and business requirements, the Analyst codifies rules that data must satisfy.1 Validation 
acts as a preventive quality control framework, establishing systematic gates that only permit appropriate 
data to enter the system.32 Common rules in the Underwriting Data Office include: 
●​ Mandatory Fields: Ensuring fields like AgentID or CoverageCode are not null.1 
●​ Value Constraints: Enforcing that premiums are greater than zero and that TDI codes exist within 
the approved list.1 
●​ Format Standards: Validating ZIP code patterns and policy number formats using regular 
expressions.1 
●​ Referential Integrity: Ensuring that every Policy.AgentID has a corresponding match in the agent 
master table.1 
●​ Logical Checks: Verifying relationships, such as policy start dates preceding end dates.33 
These rules are executed via SQL scripts, Informatica CDQ rules, or Gosu scripts embedded in 
Guidewire.1 Any record failing these checks is flagged in an automated issues log for investigation.1 
Issue Detection and Root Cause Analysis (RCA) 
Detection is automated through SQL Server Agent jobs or BI subscriptions that trigger alerts when error 
rates exceed defined thresholds.1 Once an issue is flagged, the Analyst performs Root Cause Analysis 
using techniques like the "5 Whys" or Fishbone (Ishikawa) diagrams.1 This investigation traces the error 
back through the pipeline to determine whether the source was a system bug, an ETL transformation 
error, or a data entry mistake.1 
Tracing erroneous records requires deep data lineage reviews.1 The Analyst may use ETL lineage tools or 
query historical audit logs in Guidewire to identify if the issue arose during a recent policy migration or a 
specific batch load.1 The output of this phase is an RCA report identifying the underlying source and a 
proposed corrective action.1 Effective RCA focuses on systems rather than individual performance, 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
ensuring that breakdowns in processes are prevented from recurring.37 
Correction and Remediation 
Corrective actions involve either data cleansing or process fixes.1 Data cleansing may include updating 
records via SQL or Python to standardize formats or fill missing values using reference lookups.1 Process 
fixes involve updating the underlying integration logic or ETL scripts to prevent the issue from recurring.1 
 
Remediation Task 
Implementation 
Methodology 
Purpose 
Source 
Standardize Casing 
SQL INITCAP(), 
UPPER() 
Consistency in 
naming/addresses 
1 
Standardize Address 
SQL TRIM(), 
REPLACE() 
Improves geocoding 
and mailing accuracy 
1 
Impute Missing 
Values 
SQL LEFT JOIN on 
Ref Tables 
Enhances 
completeness for 
mandatory fields 
1 
Deduplicate Records 
SQL GROUP BY, 
Python 
drop_duplicates 
Ensures data 
uniqueness (Customer 
360) 
1 
Standardize Phone 
SQL REPLACE(col, 
'-', '') 
Normalizes 
communication 
metadata 
1 
Enhanced Standard Operating Procedures (SOPs) for the 
Underwriting Data Office 
The following detailed SOPs define the operational rhythm and governance standards of the department 
as of April 17, 2026.1 
SOP 1: End-to-End Data Quality Lifecycle Management 
The primary objective is to ensure all data ingested from source systems is fit for purpose and compliant 
with TXFB and TDI standards.1 
1.​ Ingestion & Profiling: Establish an inventory of fields and compute baseline metrics immediately 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
upon data arrival.1 
2.​ Validation Rule Application: Use the rules engine to enforce constraints. Rules should be updated 
dynamically to adapt to new regulations like HB 2067.1 
3.​ Issue Detection & Alerting: Monitor failures against the 1% Data Quality Acceptance Standard. 
Rejection of a submission occurs if invalid formats or illogical entries exceed this threshold.1 
4.​ Root Cause Analysis (RCA): Implement the structured investigation process described in SOP 4.1 
5.​ Cleansing & Remediation: Execute fixes and document them in the remediation plan, tracking the 
"First Fix Rate" and "Average Time to Resolution".1 
SOP 2: Data Profiling and Statistical Assessment 
This procedure ensures that the statistical integrity of the underwriting book is maintained through regular 
diagnostics.1 
1.​ Continuous Profiling: Establish a schedule (e.g., weekly) for profiling core datasets to identify 
anomalies or shifts in data patterns.1 
2.​ Metric Comparison: Compare current metrics (e.g., policy counts by ZIP code) against historical 
data to identify potential geographic market trends that may interest TDI.1 
3.​ Stakeholder Communication: Provide data health scorecards to underwriting managers to support 
data-driven decision-making.1 
SOP 3: Validation Rule Execution 
The objective is to establish proactive gates that prevent "dirty data" from reaching production 
environments.1 
1.​ Rule Definition: Collaborate with business analysts to define logical and technical constraints for 
all new fields (e.g., the "60D" indicator for HB 2067).16 
2.​ Constraint Selection: Apply "system constrained" rules for mandatory fields (e.g., drop-down lists 
for reason codes) to minimize manual entry errors.29 
3.​ Threshold Setting: Define the maximum percentage of records that can fail a specific rule before a 
job is aborted (e.g., a 5% threshold for non-critical fields).34 
4.​ Logging and Audit: Maintain detailed logs of every validation execution, including the MIS date 
(data filter date) and specific iteration ID.33 
SOP 4: Root Cause Analysis and Remediation 
This procedure ensures that systemic issues are identified and eliminated to prevent recurrence.1 
1.​ Problem Statement: Define the problem using the SMART principle (Specific, Measurable, 
Action-oriented, Realistic, Time-constrained).37 
2.​ Data Collection: Gather comprehensive data, including incident reports, system logs, and 
stakeholder interviews, to establish a timeline of events.37 
3.​ Analysis Phase: Use the "5 Whys" method or Ishikawa diagrams to hypothesize and identify the 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
fundamental breakdown in the process.1 
4.​ Corrective Action Implementation: Develop an action plan that outlines steps, assigns 
responsibilities, and sets deadlines.35 
5.​ Documentation: Create a comprehensive "post-mortem" report detailing the RCA process, root 
causes identified, and effectiveness of the solution.37 
SOP 5: Data Issue Management and Severity Escalation 
This procedure defines the response protocol based on the severity of the data quality event.1 
1.​ Severity Classification: 
○​ Critical: Issues halting underwriting or breaching TDI SLAs (e.g., HB 2067 reporting failure). 
Requires 1-4 hour investigation.1 
○​ High: Errors affecting pricing models or risk assessment (e.g., HazardHub failure). Requires 
24-hour resolution.1 
○​ Medium/Low: Reporting inaccuracies or cosmetic hygiene.1 
2.​ Stakeholder Notification: Alert the Underwriting Manager and PMO for all Critical and High 
incidents.1 
3.​ Resolution Tracking: Document root cause, fix steps, and preventive measures before closing the 
ticket.1 
SOP 6: Data Quality KPI Monitoring and Reporting 
This procedure focuses on the systematic evaluation of performance metrics to maintain long-term data 
health.1 
1.​ KPI Establishment: Define targets and thresholds for accuracy, completeness, consistency, 
timeliness, validity, and integrity.1 
2.​ Automated Monitoring: Utilize BI platforms (like D2D) to host KPIs and set event-driven 
notifications for threshold breaches.36 
3.​ Performance Auditing: Conduct regular reviews of agency-specific KPIs to ensure data meets 
"fitness for purpose" requirements.1 
4.​ Reporting Cadence: Generate monthly reports summarizing data quality trends and the 
effectiveness of remediation plans.35 
SOP 7: Data Governance Execution and Data Dictionary Maintenance 
Embedding DAMA-DMBOK principles into daily operations preserves metadata integrity.1 
1.​ Dictionary Updates: When new fields are added to Guidewire or Dynamics 365, update the 
central Data Dictionary with the field name, definition, format, and ownership.1 
2.​ Naming Standards: Enforce consistent naming conventions (e.g., YYYYMMDD for dates) across 
all datasets.1 
3.​ Data Inventory: Maintain an accurate Record of Processing Activities (RoPA) to track data 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
categories, retention periods, and technical safeguards, as required for GDPR/DORA compliance.39 
SOP 8: SDLC Support and Release Readiness 
The objective is to ensure data integrity is maintained through system updates and cloud releases.1 
1.​ Release Assessment: Review release notes for platforms like Guidewire Olos to identify new data 
model changes or API endpoints.20 
2.​ Test Case Development: Design validation tests to verify that new features (e.g., Spotter 
conversational search) are accurately reflecting the underlying data.1 
3.​ Regression Testing: Ensure existing validation rules are not compromised by new system code or 
configuration overrides.1 
Advanced SQL Methodology for Data Quality Analysis 
The mastery of SQL is the foundational skill for a Data Quality Analyst II, extending beyond retrieval to 
the application of set theory and complex transformations.1 
The Application of Set Theory 
In the context of property and casualty insurance, policies, periods, and locations maintain complex 
one-to-many relationships.1 Set theory is functionally applied during data reconciliation tasks, particularly 
after nightly batch loads. The Analyst must ensure that the set of policies in the staging environment (
) 
is identical to the set of policies processed in the production environment (
), identifying symmetric 
differences that indicate pipeline failures or record drops.1 
 
Aggregate Profiling for Data Health 
Aggregate profiling serves as the primary diagnostic tool for monitoring ongoing data integrity.1 By 
utilizing complex CASE logic within aggregate functions, the Analyst can quantify the health of millions 
of records in a single execution.1 This is critical for computing completeness metrics for mandated fields 
like "Roof Coverage Type" or "VIN." 
SQL Logic for Completeness Indexing: 
 
SQL 
 
 
CompletenessIndex = ​
(SUM(CASE WHEN VIN IS NOT NULL AND LEN(TRIM(VIN)) = 17 THEN 1 ELSE 0 END) * 100.0) / 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
COUNT(*)​
 
This logic allows the Underwriting Data Office to report to stakeholders exactly what percentage of the 
book of business meets the necessary underwriting standards.1 
Exhaustive SQL Library for Underwriting Data Quality 
The following SQL queries represent the technical standard for the role at Texas Farm Bureau as of April 
17, 2026.1 
1. Statutory Compliance Audit: HB 2067 Reason Code Reconciliation 
This query identifies policies where the cancellation reason stored in PolicyCenter does not align with the 
mandatory TDI codeset.1 
 
SQL 
 
 
SELECT​
    p.PolicyNumber,​
    p.CancellationReasonCode AS Internal_Reason,​
    t.TDICode AS Statutory_Reason,​
    CASE​
        WHEN t.TDICode IS NULL THEN 'Missing Mapping'​
        WHEN p.CancellationReasonCode!= t.TDICode THEN 'Mapping Discrepancy'​
        ELSE 'Valid'​
    END AS Compliance_Status​
FROM pc_policyperiod p​
LEFT JOIN TDI_Reason_Mapping t ON p.CancellationReasonCode = t.InternalCode​
WHERE p.Status = 'Canceled'​
  AND p.CancellationDate >= '2026-04-01'​
  AND p.IsMostRecentModel = 1;​
 
2. Data Integrity: Detecting "Orphan" Risks 
This query detects risk locations or coverages that lack a parent PolicyPeriod, a common issue following 
complex endorsements or system migrations.1 
 
SQL 
 
 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
SELECT​
    l.PublicID AS Location_ID,​
    l.LocationNumber,​
    p.PolicyNumber​
FROM pc_policylocation l​
LEFT JOIN pc_policyperiod p ON l.BranchID = p.ID​
WHERE p.ID IS NULL​
  OR p.Status IN ('Draft', 'Withdrawn');​
 
3. Data Cleansing: Normalizing Vehicle Identification Numbers (VIN) 
Standardizing unstructured text is a core responsibility. This script identifies invalid VIN lengths and 
removes non-alphanumeric characters.1 
 
SQL 
 
 
SELECT​
    PolicyNumber,​
    VIN,​
    LEN(VIN) AS VIN_Length​
FROM pc_vehicle​
WHERE LEN(VIN)!= 17​
   OR VIN LIKE '%[^a-zA-Z0-9]%';​
 
4. Geocoding Accuracy Audit for Coastal Risk 
Ensures that risks in high-exposure coastal counties have valid geographic coordinates for catastrophe 
modeling.1 
 
SQL 
 
 
SELECT​
    p.PolicyNumber,​
    l.AddressLine1,​
    l.Latitude,​
    l.Longitude​
FROM pc_policylocation l​
JOIN pc_policyperiod p ON l.BranchID = p.ID​

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
WHERE p.IsMostRecentModel = 1​
  AND l.State = 'TX'​
  AND (l.Latitude IS NULL OR l.Longitude IS NULL)​
  AND l.County IN ('Harris', 'Galveston', 'Nueces', 'Cameron');​
 
5. Aggregate Profiling: Monitoring Daily Ingest Volume Spikes 
Identifies anomalies in ingestion volume that may indicate duplicate batch runs or feed failures.1 
 
SQL 
 
 
SELECT​
    CAST(CreateTime AS DATE) AS Ingest_Date,​
    COUNT(*) AS Row_Count,​
    AVG(COUNT(*)) OVER (ORDER BY CAST(CreateTime AS DATE) ROWS BETWEEN 7 PRECEDING 
AND 1 PRECEDING) AS Seven_Day_Avg​
FROM pc_policyperiod​
GROUP BY CAST(CreateTime AS DATE)​
HAVING COUNT(*) > 1.25 * (AVG(COUNT(*)) OVER (ORDER BY CAST(CreateTime AS DATE) ROWS 
BETWEEN 7 PRECEDING AND 1 PRECEDING));​
 
6. Cross-System Reconciliation: PolicyCenter vs. BillingCenter 
Ensures consistent data flow between the policy and billing systems, essential for financial accuracy.1 
 
SQL 
 
 
SELECT​
    p.PolicyNumber,​
    p.TotalPremium AS PC_Premium,​
    b.TotalPremium AS BC_Premium​
FROM pc_policyperiod p​
JOIN bc_policy b ON p.PolicyNumber = b.PolicyNumber​
WHERE p.IsMostRecentModel = 1​
  AND p.TotalPremium!= b.TotalPremium;​
 
Operational Rhythm and Failure Response Playbooks 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
To maintain a consistent standard of data health, the Underwriting Data Office follows a defined 
operational cadence as of April 2026.1 
Daily/Weekly Cadence 
The Analyst starts every morning by reviewing the Data Quality Dashboards in Power BI and addressing 
alerts triggered by SQL Server Agent jobs.1 Daily tasks include investigating critical exceptions and 
updating the team on resolution status during the morning stand-up.1 Weekly, the Analyst conducts 
in-depth reviews with Underwriting and IT to discuss trending issues, update KPIs, and share summary 
reports with business owners.1 Performance self-reviews are typically conducted on a weekly basis, 
identifying training needs and entry trends.43 
Failure Playbooks 
Predefined protocols are established for common failure scenarios to minimize operational impact.1 
●​ ETL Job Failures: If an overnight load fails, the Analyst notifies data engineers and attempts an 
automated restart.1 Downstream reporting is temporarily halted to prevent the use of stale or 
incomplete data.1 
●​ Sudden Error Spikes: A jump in error rate (e.g., exceeding the 1% acceptance standard) triggers 
an immediate SOP 4 investigation to isolate contributing factors and contain the problem.1 
●​ Regulatory Non-Compliance: If reason codes are found to be missing or misaligned for HB 2067 
notices, the issue is escalated to the "Critical" severity level, and a mandatory remediation plan is 
initiated with TDI notification if required.1 
Data Quality Dimensions and Performance Metrics 
The success of the Data Quality Analyst II is measured through a set of operationalized KPIs based on the 
six dimensions of data quality: Accuracy, Completeness, Consistency, Timeliness, Validity, and Integrity.1 
 
Dimension 
Metric 
Departmental Target 
Source 
Accuracy 
% of records failing a 
quality rule 
< 1.0% Error Rate 
1 
Completeness 
Fill rate for 
mandatory TDI fields 
100% (No Nulls) 
1 
Consistency 
Mismatch count 
between PC and 
Billing 
0 Discrepancies 
1 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
Timeliness 
Average lag in nightly 
data loads 
< 4 Hours 
1 
Validity 
% of values 
conforming to TDI 
code lists 
100% 
1 
Integrity 
Count of "Orphan" 
records in staging 
0 Orphans 
1 
These KPIs are tied to performance management.1 Each data domain has an assigned Data Owner who is 
responsible for the health of their relevant metrics.1 Dashboards provide real-time feedback, encouraging 
teams to remediate issues proactively rather than waiting for statutory audits.1 High-quality data reduces 
the number of errors encountered, improves customer relations, and keeps the company prepared for the 
increased oversight of TDI and AM Best.3 
Advanced Technical Applications: Agentic Data 
Management 
The strategic direction for the Texas Farm Bureau Underwriting Data Office as of April 2026 involves the 
adoption of "Agentic" data management, leveraging the Guidewire Agentic Framework and Informatica’s 
AI-powered services.1 
Autonomous Remediation and Risk Mitigation 
Agentic systems, such as those integrated into Informatica IDMC and Guidewire Olos, can autonomously 
prioritize the most impactful data fixes based on real context.1 For example, if an AI agent detects a 
high-impact error in "Roof Coverage Type" for coastal risks, it can suggest a remediation path, verify the 
fix across related systems, and update the audit trail—all with minimal human intervention.1 The 
Guidewire Rules Service enables centralized rules administration through a visual Rules Designer, 
allowing the UDO to respond to new requirement changes without code deployment delays.21 This shift 
fundamentally optimizes cost structures and recaptures time previously lost to manual remediation.1 
Human-in-the-Loop Governance 
The role of the Data Quality Analyst II evolves from manual monitoring to presiding over these 
autonomous systems.1 Governance frameworks must include clear escalation protocols: defining which 
decisions can be fully automated (e.g., standardizing address casing) and which require human approval 
(e.g., modifying reason code concatenation logic for HB 2067).1 "Garbage In, Garbage Out" (GIGO) 
remains a critical principle; the Analyst must ensure that the foundational data architecture is robust 
enough for these agents to operate accurately.1 This requires personnel to be highly trained in root cause 
investigation techniques and advanced validation methodologies to oversee the "Agentic" lifecycle.6 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
The convergence of high-rigor regulatory mandates, economic pressures on the membership, and 
advanced AI-driven technology necessitates a Data Quality Analyst II who is not just a technician but a 
data architect of integrity.1 By maintaining these exhaustive standards and procedures, the Underwriting 
Data Office ensures that Texas Farm Bureau Casualty Insurance Company remains the "Voice of Texas 
Agriculture" in an increasingly data-dependent world.1 
Works cited 
1.​ TFBCI-Strategic Analysis and Operational Framework.pdf 
2.​ Texas Farm Bureau Insurance Companies | Company Profile - Revenue, Headcount, Tech 
Stack, Contacts - Bitscale, accessed April 17, 2026, 
https://bitscale.ai/directory/texas-farm-bureau-insurance-companies 
3.​ Farm Bureau Property & Casualty Insurance Company, accessed April 17, 2026, 
https://ratings.ambest.com/CompanyProfile.aspx?amb=354&AltNum=303354 
4.​ About - Texas Farm Bureau, accessed April 17, 2026, 
https://texasfarmbureau.org/voice-of-texas-agriculture/ 
5.​ Texas Farm Bureau Insurance - 2026 Company Profile & Competitors - Tracxn, accessed 
April 17, 2026, 
https://tracxn.com/d/companies/texasfarmbureauinsurance/__JXXUQmNJhNkY4KuEsYP
roV5deWOC0W6sE2A6BXH4iWU 
6.​ What's new in Cloud Platform for Olos - Guidewire Documentation, accessed April 17, 
2026, 
https://docs.guidewire.com/cloud/olos/whatsnew/topics/gwcp-release_highlights.html 
7.​ Data quality in the insurance sector 2020 - The CRO Forum, accessed April 17, 2026, 
https://www.thecroforum.org/wp-content/uploads/2020/09/Data-quality-in-the-insurance-s
ector.pdf 
8.​ Texas Farm Bureau - Nonprofit Explorer - ProPublica, accessed April 17, 2026, 
https://projects.propublica.org/nonprofits/organizations/741145986 
9.​ Farm Bureau Survey: 70% of Farmers Can't Afford Enough Fertilizer for 2026 Season - 
RFD, accessed April 17, 2026, 
https://www.rfdtv.com/survey-70-percent-of-farmers-cant-afford-enough-fertilizer-for-202
6-season 
10.​texas farm bureau - a year in review, accessed April 17, 2026, 
https://texasfarmbureau.org/wp-content/uploads/2026/01/YearInReview_2025.pdf 
11.​ New TICO Reporting Rules: What Texas Insurers Need - WaterStreet Company, accessed 
April 17, 2026, 
https://www.waterstreetcompany.com/new-tico-reporting-rules-what-texas-insurers-need/ 
12.​HB 2067 - 89th Legislature - Texas Policy Research, accessed April 17, 2026, 
https://www.texaspolicyresearch.com/bills/89th-legislature-hb-2067/ 
13.​Texas law requires automatic explanations from insurance companies in 2026, accessed 
April 17, 2026, 
https://www.fox4news.com/news/texas-insurance-law-2026-automatic-explanations 
14.​Texas Requires Written Insurance Denial Reasons - Legal Reader, accessed April 17, 
2026, https://www.legalreader.com/texas-requires-written-insurance-denial-reasons/ 
15.​New Texas Law Requires Insurers Provide Reason for Declining or Canceling Policies, 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
accessed April 17, 2026, 
https://www.carriermanagement.com/news/2026/02/24/284929.htm 
16.​Subchapter O. Statistical Plans 28 TAC §5.9503 and §5.9504 INTRODUCTION. The 
commissioner of insurance adopts new 28 TAC §5.9 - Texas Department of Insurance, 
accessed April 17, 2026, https://www.tdi.texas.gov/rules/2025/documents/20269741.pdf 
17.​TEXAS STATISTICAL PLAN FOR RESIDENTIAL RISKS Effective ..., accessed April 
17, 2026, https://www.tdi.texas.gov/rules/2026resclean.pdf 
18.​Subchapter H. Cancellation, Denial, and Nonrenewal of Certain Property and Casualty 
Insurance Coverage Division 1. General Provi, accessed April 17, 2026, 
https://www.tdi.texas.gov/rules/2025/documents/20269730.pdf 
19.​Adopted Rules Title 28 - the Texas Secretary of State, accessed April 17, 2026, 
https://www.sos.state.tx.us/texreg/archive/January302026/Adopted%20Rules/28.INSURA
NCE.html 
20.​What's new in Olos - Guidewire Documentation, accessed April 17, 2026, 
https://docs.guidewire.com/cloud/olos/whatsnew 
21.​Guidewire introduces Olos to advance pricing, underwriting and workers' comp 
performance, accessed April 17, 2026, 
https://www.reinsurancene.ws/guidewire-introduces-olos-to-advance-pricing-underwriting
-and-workers-comp-performance/ 
22.​What's new in Analytics for Olos - Guidewire Documentation, accessed April 17, 2026, 
https://docs.guidewire.com/cloud/olos/whatsnew/topics/analytics-release_highlights.html 
23.​Informatica Intelligent Data Management Cloud - Microsoft Marketplace, accessed April 
17, 2026, 
https://marketplace.microsoft.com/en-au/product/informatica.annualiics?tab=overview 
24.​CLAIRE AI Engine – Intelligent Automation | Informatica, accessed April 17, 2026, 
https://www.informatica.com/platform/claire-ai.html 
25.​Informatica Pricing Guide 2026: Costs & Plans Broken Down - Mammoth Analytics, 
accessed April 17, 2026, https://mammoth.io/blog/informatica-pricing/ 
26.​Informatica Pricing: How Much Does Informatica Really Cost in 2026 | Integrate.io, 
accessed April 17, 2026, https://www.integrate.io/blog/informatica-cost/ 
27.​Informatica Software Pricing & Plans 2026: See Your Cost - Vendr, accessed April 17, 
2026, https://www.vendr.com/marketplace/informatica 
28.​Informatica Review 2026: Pros and Cons for Data Teams | Integrate.io, accessed April 17, 
2026, https://www.integrate.io/blog/informatica-review/ 
29.​Data Management SOPs: Standardizing Processes for Quality Assurance, accessed April 
17, 2026, 
https://medipharmsolutions.com/blog/data-management-sops-standardizing-processes-for-
quality-assurance-2/ 
30.​Data Quality Assurance: A Guide for Reliable and Actionable Data - Acceldata, accessed 
April 17, 2026, 
https://www.acceldata.io/blog/data-quality-assurance-101-elevate-your-data-strategy-with-
reliable-solutions 
31.​Data Quality in Insurance: Business Benefits & Core Capabilities - Atlan, accessed April 
17, 2026, https://atlan.com/know/data-quality/data-quality-in-insurance/ 
32.​Chapter 3.4: Data Validation and Quality Assurance – Introduction to Data Science, 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
accessed April 17, 2026, 
https://express.excelsior.edu/datascience/chapter/chapter-3-4-data-validation-and-quality-a
ssurance/ 
33.​How to Automate Insurance Data Validation | Datagrid, accessed April 17, 2026, 
https://datagrid.com/blog/automate-insurance-data-validation 
34.​37 Data Quality Rules Execution, accessed April 17, 2026, 
https://docs.oracle.com/cd/E92917_01/PDF/8.1.x.x/8.1.2.0.0/FSDF_HTML/UG/37_Data_
Quality_Rules_Execution.htm 
35.​DATA QUALITY ISSUE MITIGATION PROTOCOL - DoH, accessed April 17, 2026, 
https://www.doh.gov.ae/-/media/9886CF5D127147DFB950EED6FF7C75B0.ashx 
36.​Data Quality Monitoring Standard Operating Procedure (SOP) - Federal Acquisition 
Institute (FAI), accessed April 17, 2026, 
https://www.fai.gov/sites/fai/files/FAI%20Data%20Quality%20Monitoring%20SOP%20-
%20FINAL%20-%202025-04.pdf 
37.​What Is Root Cause Analysis? The Complete RCA Guide - Splunk, accessed April 17, 
2026, https://www.splunk.com/en_us/blog/learn/root-cause-analysis.html 
38.​How To Use Root Cause Analysis Effectively - Riskonnect, accessed April 17, 2026, 
https://riskonnect.com/reporting-analytics/how-to-use-root-cause-analysis-effectively/ 
39.​Data Quality (DQ): a key challenge for insurance companies | RSM France, accessed April 
17, 2026, 
https://www.rsm.global/france/en/insights/data-quality-key-challenge-insurance-companie
s 
40.​What's new in Palisades - Guidewire Documentation, accessed April 17, 2026, 
https://docs.guidewire.com/cloud/palisades/whatsnew 
41.​Guidance for Performing Root Cause Analysis (RCA) with PIPs - CMS, accessed April 
17, 2026, 
https://www.cms.gov/medicare/provider-enrollment-and-certification/qapi/downloads/guid
anceforrca.pdf 
42.​Texas Private Passenger Auto Statistical Plan Effective April 1, 2026, accessed April 17, 
2026, https://www.tdi.texas.gov/rules/2025/documents/2026pparedline.pdf 
43.​Data Quality Assurance SOP Template | PDF - Scribd, accessed April 17, 2026, 
https://www.scribd.com/document/436746911/Sample-Data-Quality-Assurance-Standard-
Operating-Procedures-1 
44.​Data Quality Monitoring Standard Operating Procedure (SOP) - FAI.GOV, accessed April 
17, 2026, 
https://www.fai.gov/sites/fai/files/FAI%20Data%20Quality%20Monitoring%20SOP%20-
%20final%20draft%20-%202024-08.pdf 
45.​How to Write SOPs: A Practical Standard Operating Procedure Guide - BOC Group, 
accessed April 17, 2026, 
https://www.boc-group.com/en/blog/bpm/how-to-write-an-effective-standard-operating-pr
ocedure/ 
46.​RCA SOP for Quality Assurance in Pharma | PDF | Cognition | Analysis - Scribd, accessed 
April 17, 2026, 
https://www.scribd.com/document/552213535/QA006-Root-Cause-Analysis 
47.​Standard Operating Procedure (SOP) for Root Cause Analysis in Quality Events - eLeaP, 

Daniel Rodriguez III 
Data Quality Analyst II 
17 April 2026 
Strategic Analysis and Operational 
Framework 
 
accessed April 17, 2026, 
https://quality.eleapsoftware.com/whitepaper/standard-operating-procedure-sop-for-root-ca
use-analysis-in-quality-events/ 
48.​A Complete Guide to Measuring Data Quality with the Right KPI, accessed April 17, 
2026, https://data-sleek.com/blog/measuring-data-quality-kpi/ 
49.​Modern Data Quality Management: A Proven 6 Step Guide - Monte Carlo Data, accessed 
April 17, 2026, https://www.montecarlodata.com/blog-data-quality-management/ 
50.​SOP For Reporting - Meegle, accessed April 17, 2026, 
https://www.meegle.com/en_us/topics/sop/sop-for-reporting 
51.​Data Protection SOPs: Standard Operating Procedures for Compliance - Secure Privacy, 
accessed April 17, 2026, https://secureprivacy.ai/blog/data-protection-sops 
52.​What's new in PolicyCenter for Olos - Guidewire Documentation, accessed April 17, 
2026, https://docs.guidewire.com/cloud/olos/whatsnew/topics/pc-release_highlights.html 
53.​Standard Operating Procedure (SOP): Full Implementation Guide - Tractian, accessed 
April 17, 2026, 
https://tractian.com/en/blog/standard-operating-procedure-sop-full-guide-to-apply-it 
