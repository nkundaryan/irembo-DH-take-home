select
    toStartOfMonth(c.created_at_utc) as month,

    count(*) as total_consults,

    sum(r.doctor_referral_flag) * 1.0 / count(*) as doctor_referral_rate,

    sum(r.patient_request_flag) * 1.0 / count(*) as patient_request_rate

from {{ ref('int_referrals_classified') }} r

left join {{ ref('stg_consultations_fixed') }} c
    on r.consultation_id = c.consultation_id

group by month
order by month