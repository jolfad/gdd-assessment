SELECT
    name AS event_name
    , timestamp_millis(created) AS time_event_created
    , timestamp_millis(time) AS time_event_start
    , status AS event_status
    , duration / 1000 / 3600 AS event_duration_hour
    , rsvp_limit
    , rsvps
    , venue_id
    , group_id
    , description
FROM {{ source('raw','events') }}
