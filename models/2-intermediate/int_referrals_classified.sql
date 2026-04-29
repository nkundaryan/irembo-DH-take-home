with base as (

    select
        c.consultation_id,

        coalesce(o.referral_issued, 0) as doctor_referral_flag,
        coalesce(r.referral_requested, 0) as patient_request_flag

    from {{ ref('stg_consultations_fixed') }} c

    left join {{ ref('stg_clinical_outcomes') }} o
        on c.consultation_id = o.consultation_id

    left join {{ ref('stg_consultation_requests') }} r
        on c.consultation_id = r.consultation_id

)

select
    consultation_id,
    doctor_referral_flag,
    patient_request_flag,

    case
        when doctor_referral_flag = 1 and patient_request_flag = 0 then 'doctor_referral'
        when doctor_referral_flag = 0 and patient_request_flag = 1 then 'patient_requested_only'
        when doctor_referral_flag = 1 and patient_request_flag = 1 then 'both'
        else 'no_referral'
    end as referral_category

from base