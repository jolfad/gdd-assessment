WITH events_base AS (
    SELECT
        event_name
        , description
        , time_event_created
        , time_event_start
        , event_status
        , event_duration_hour
        , rsvp_limit
        , rsvps.user_id
        , rsvps.response
        , group_id
        , venue_id
    FROM
        {{ ref('dwr_events') }}
    CROSS JOIN
        unnest(rsvps) AS rsvps
)

, venues_base AS (
    SELECT
        venue_id
        , venue_key
    FROM {{ ref('dim_venues') }}
)

, groups_base AS (
    SELECT
        group_id
        , group_key
    FROM {{ ref('dim_groups') }}
)

, final AS (
    SELECT
        events_base.event_name
        , events_base.description
        , events_base.time_event_created
        , events_base.time_event_start
        , events_base.event_status
        , events_base.event_duration_hour
        , events_base.rsvp_limit
        , groups_base.group_key
        , venues_base.venue_key
        , count(events_base.user_id) AS user_rsvps
        , sum(CASE WHEN events_base.response = 'yes' THEN 1 ELSE 0 END) AS responded_yes
        , sum(CASE WHEN events_base.response = 'no' THEN 1 ELSE 0 END) AS responded_no
    FROM events_base
    LEFT JOIN groups_base ON events_base.group_id = groups_base.group_id
    LEFT JOIN venues_base ON events_base.venue_id = venues_base.venue_id
    {{ dbt_utils.group_by(9) }}
)

SELECT * FROM final
