# Overview  
This project investigates two issues in the April dashboard: a spike in referral rate and a drop in wait time.

## What went wrong  
The referral spike was caused by counting both doctor referrals and patient-requested referrals from a new intake form in the same metric.  
The wait time issue was caused by mixing UTC and UTC+2 timestamps, which created negative wait times.

## What I changed  
I normalized all timestamps to UTC and cleaned wait time values. I also separated doctor referrals and patient requests into different flags and ensured one row per consultation.

## Metric definition  
Doctor referral rate is defined as consultations where a doctor issued a referral divided by total consultations. Patient requests are tracked separately.

## Tests  
I added tests for uniqueness, valid categories, referral spikes, and negative wait times.

## Assumptions  
Consultation ID is the primary key, and UTC+2 timestamps are valid but need conversion.

## AI usage  
AI tools were used to help structure responses, review logic, and support learning the ClickHouse dialect. All decisions were understood and validated before submission.