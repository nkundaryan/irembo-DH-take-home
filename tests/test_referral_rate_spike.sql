select *
from {{ ref('mart_referral_rate_monthly') }}
where doctor_referral_rate > 0.2 
-- 20% threshold is well above the usual ~10% baseline; can be adjusted as needed