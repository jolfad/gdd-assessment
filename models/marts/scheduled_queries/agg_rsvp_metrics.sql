WITH rsvp_events AS (
    SELECT *
    FROM {{ ref('fact_rsvp_events') }}
)


, venues_base AS (
    SELECT
        venue_id
        , venue_key
        , city
        , country_name
    FROM {{ ref('dim_venues') }}
)

, groups_base AS (
    SELECT
        group_id
        , group_key
        , group_name
        , group_age_year
    FROM {{ ref('dim_groups') }}
)

, group_memberships AS (
    SELECT
        group_key
        , num_members
    FROM {{ ref('agg_group_memberships') }}
)

, events_enriched AS (
    SELECT
        extract(MONTH FROM rsvp_events.time_event_created) AS month
        , venues_base.country_name AS venue_country
        , venues_base.city AS venue_city
        , rsvp_events.event_key
        , groups_base.group_name
        , groups_base.group_age_year
        , CASE
            WHEN rsvp_events.event_duration_hour BETWEEN 0 AND 6 THEN '0 - 6'
            WHEN rsvp_events.event_duration_hour BETWEEN 7 AND 12 THEN '7 - 12'
            WHEN rsvp_events.event_duration_hour BETWEEN 13 AND 18 THEN '13 - 18'
            WHEN rsvp_events.event_duration_hour BETWEEN 19 AND 24 THEN '18 - 24'
            WHEN rsvp_events.event_duration_hour > 24 THEN '> 24'
        END AS event_duration
        , CASE
            WHEN group_memberships.num_members BETWEEN 0 AND 100 THEN '0 - 100'
            WHEN group_memberships.num_members BETWEEN 101 AND 200 THEN '100 - 200'
            WHEN group_memberships.num_members BETWEEN 201 AND 400 THEN '200 - 400'
            WHEN group_memberships.num_members BETWEEN 401 AND 600 THEN '400 - 600'
            WHEN group_memberships.num_members BETWEEN 601 AND 800 THEN '600 - 800'
            WHEN group_memberships.num_members BETWEEN 801 AND 1000 THEN '800 - 1000'
            WHEN group_memberships.num_members > 1000 THEN '> 1000' END AS num_group_members
        , group_memberships.num_members
        , avg(rsvp_events.day_rsvp_time_from_event_creation) AS day_rsvp_time_from_event_creation
        , avg(rsvp_events.day_rsvp_time_to_event_start) AS day_rsvp_time_to_event_start
        , sum(rsvp_events.responded_yes) AS responded_yes
        , sum(rsvp_events.responded_no) AS responded_no
    FROM rsvp_events
    LEFT JOIN venues_base ON rsvp_events.venue_key = venues_base.venue_key
    LEFT JOIN groups_base ON rsvp_events.group_key = groups_base.group_key
    LEFT JOIN group_memberships ON rsvp_events.group_key = group_memberships.group_key
    WHERE rsvp_events.event_status != 'proposed'
    {{ dbt_utils.group_by(9) }}

)

, events_enriched_2

AS (
    SELECT
        venue_country
        , venue_city
        , event_key
        , group_name
        , group_age_year
        , month
        , event_duration
        , num_group_members
        , day_rsvp_time_from_event_creation
        , day_rsvp_time_to_event_start
        , responded_yes
        , responded_no
        , responded_yes / (responded_yes + responded_no) AS perc_yes_response
        , responded_yes / num_members AS perc_attendance_rate
    FROM events_enriched
    -- We want to restrict analysis to these 3 countries based on the content of the sample dataset
    WHERE venue_country IN ('Belgium', 'Germany', 'Netherlands')

)

, final AS (
    SELECT
        venue_country
        , venue_city
        , month
        , event_duration
        , group_age_year
        , num_group_members
        , sum(responded_yes) AS responded_yes
        , sum(responded_no) AS responded_no
        , avg(perc_yes_response) AS perc_yes_response
        , avg(day_rsvp_time_from_event_creation) AS day_rsvp_time_from_event_creation
        , avg(day_rsvp_time_to_event_start) AS day_rsvp_time_to_event_start
        , avg(perc_attendance_rate) AS perc_attendance_rate
    FROM events_enriched_2
    {{ dbt_utils.group_by(6) }}
)

SELECT * FROM final
