WITH
rsvp_events AS (
    SELECT * FROM {{ ref('fact_rsvp_events') }}
)

, dim_groups AS (
    SELECT * FROM {{ ref('dim_groups') }}
)

, dim_venues AS (
    SELECT * FROM {{ ref('dim_venues') }}
)

, dim_users AS (
    SELECT * FROM {{ ref('dim_users') }}
)

, final AS (
    SELECT
        rsvp_events.event_name
        , rsvp_events.time_event_created
        , rsvp_events.time_event_start
        , rsvp_events.event_status
        , rsvp_events.event_duration_hour
        , rsvp_events.rsvp_limit
        , rsvp_events.time_user_rsvp_response
        , rsvp_events.rsvp_guests
        , dim_users.hometown AS user_hometown
        , dim_users.city AS user_city
        , dim_users.country AS user_country
        , dim_groups.group_name
        , dim_groups.city AS group_city
        , dim_groups.latitude AS group_latitude
        , dim_groups.longitude AS group_longitude
        , dim_groups.time_group_created AS group_inception_date
        , dim_venues.venue_name
        , dim_venues.city AS venue_city
        , dim_venues.country AS venue_country
        , dim_venues.latitude AS venue_latitude
        , dim_venues.longitude AS venue_longitude
    FROM rsvp_events
    LEFT JOIN dim_users ON rsvp_events.user_key = dim_users.user_key
    LEFT JOIN dim_groups ON rsvp_events.group_key = dim_groups.group_key
    LEFT JOIN dim_venues ON rsvp_events.venue_key = dim_venues.venue_key
)

SELECT * FROM final
