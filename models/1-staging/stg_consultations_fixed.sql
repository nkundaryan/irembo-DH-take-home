with consultations as (

    select
        consultation_id,
        patient_id,

        parseDateTimeBestEffort(consultation_created_at) as created_at, -- parse time date because timestamp is in string format
        parseDateTimeBestEffort(consultation_started_at) as started_at,

        consultation_started_at like '%+02%' as has_tz_offset -- flag rows where timestamp has UTC+2 offset

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
            toTimeZone(created_at, 'UTC'), -- Handles the case so negative wait times are not let through
            toTimeZone(started_at, 'UTC')
        ) < 0 then null

        when dateDiff('minute',
            toTimeZone(created_at, 'UTC'), -- set unusually large wait times to NULL to avoid skewing averages
            toTimeZone(started_at, 'UTC')
        ) > 480 then null -- anything over 480 mins is probably wrong, set to null

        else dateDiff('minute',
            toTimeZone(created_at, 'UTC'),
            toTimeZone(started_at, 'UTC')
        )
    end as wait_time_minutes,

    has_tz_offset

from consultations