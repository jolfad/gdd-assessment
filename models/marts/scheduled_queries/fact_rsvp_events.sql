WITH unnest_events AS (

    SELECT
        event_name
        , time_event_created
        , time_event_start
        , event_status
        , event_duration_hour
        , rsvp_limit
        , rsvps.user_id
        , timestamp_millis(`when`) AS time_user_rsvp_response
        , rsvps.guests
        , rsvps.response
        , venue_id
        , group_id
    FROM {{ ref('dwr_events') }}
    CROSS JOIN unnest(rsvps) AS rsvps
)

, groups_base
AS (
    SELECT
        group_id
        , group_key
    FROM {{ ref('dim_groups') }}
)

, venues_base
AS (
    SELECT
        venue_id
        , venue_key
    FROM {{ ref('dim_venues') }}
)

, users_base
AS (
    SELECT
        user_id
        , user_key
    FROM {{ ref('dim_users') }}
)

, events_base
AS (
    SELECT
        event_name
        , event_key
        , time_event_created
    FROM {{ ref('dim_events') }}
)

, final AS (

    SELECT
        unnest_events.event_name
        , unnest_events.time_event_created
        , unnest_events.time_event_start
        , unnest_events.event_status
        , unnest_events.event_duration_hour
        , unnest_events.rsvp_limit
        , TIMESTAMP_DIFF(unnest_events.time_user_rsvp_response, unnest_events.time_event_created, DAY) AS day_rsvp_time_from_event_creation
        , TIMESTAMP_DIFF(unnest_events.time_event_start, unnest_events.time_user_rsvp_response, DAY) AS day_rsvp_time_to_event_start
        , CASE WHEN response='yes' then 1 else 0 end as responded_yes
        , CASE WHEN response='no' then 1 else 0 end as responded_no
        , time_user_rsvp_response
        , unnest_events.guests AS rsvp_guests
        , users_base.user_key
        , venues_base.venue_key
        , groups_base.group_key
        , events_base.event_key
    FROM unnest_events
    LEFT JOIN groups_base ON unnest_events.group_id = groups_base.group_id
    LEFT JOIN venues_base ON unnest_events.venue_id = venues_base.venue_id
    LEFT JOIN users_base ON unnest_events.user_id = users_base.user_id
    LEFT JOIN events_base ON unnest_events.event_name = events_base.event_name
    AND unnest_events.time_event_created = events_base.time_event_created
)

SELECT * FROM final
