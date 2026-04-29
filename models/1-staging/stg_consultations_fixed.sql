with consultations as (

    select
        consultation_id,
        patient_id,

        parseDateTimeBestEffort(consultation_created_at) as created_at, -- parse time date because created at is in string format exampele UTC
        parseDateTimeBestEffort(consultation_started_at) as started_at,

        consultation_started_at like '%+02%' as has_tz_offset -- Sets up boolean for if the timezone is not UTC+2

    from {{ source('raw', 'consultations') }}

    where patient_id not like 'TEST_%'

)

select
    consultation_id,
    patient_id,

    toTimeZone(created_at, 'UTC') as created_at_utc,
    toTimeZone(started_at, 'UTC') as started_at_utc,

    case
        when dateDiff('minute',
            toTimeZone(created_at, 'UTC'), -- Handles the case so that the bad column wont be negative and pull averegaes
            toTimeZone(started_at, 'UTC')
        ) < 0 then null

        when dateDiff('minute',
            toTimeZone(created_at, 'UTC'), -- Nice to have to also not let unreasonally big numbers pull that away
            toTimeZone(started_at, 'UTC')
        ) > 480 then null

        else dateDiff('minute',
            toTimeZone(created_at, 'UTC'),
            toTimeZone(started_at, 'UTC')
        )
    end as wait_time_minutes,

    has_tz_offset

from consultations

