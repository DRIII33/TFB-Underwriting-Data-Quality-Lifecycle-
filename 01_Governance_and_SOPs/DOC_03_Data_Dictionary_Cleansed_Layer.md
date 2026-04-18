Table/View Name	Column Name	Data Type	Definition & Business Logic
vw_pc_policyperiod_cleansed	Cleansed_TDICode	STRING	Remediated Field: Maps internal codes to TDI statutory codes. Defaults to 'K' (Underwriting) for null or unmapped values.
vw_pc_policyperiod_cleansed	Remediation_Status	STRING	Audit Flag: Identifies if the record was 'ORIGINAL' or 'REMEDIATED' by the DQ engine.
vw_pc_policylocation_cleansed	Geo_Health_Status	STRING	Quality Flag: Categorizes coastal risks as 'GEOCODE_VALID' or 'GEOCODE_REQUIRED' based on Lat/Long availability.
vw_pc_vehicle_cleansed	Sanitized_VIN	STRING	Standardized Field: Outputs the 17-char alphanumeric VIN or 'INVALID_FORMAT' for source-system correction.
vw_financial_reconciliation	Adjustment_Amount	FLOAT64	Calculation: The delta between BillingCenter and PolicyCenter premiums (BC_Premium - PC_Premium).
