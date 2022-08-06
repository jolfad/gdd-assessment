select 
name as event_name
, timestamp_millis(created) as time_event_created
, timestamp_millis(time) as time_event_start
, status as event_status
, duration/1000/3600 as event_duration_hour
, rsvp_limit
, rsvps
, venue_id
, group_id
, description
 from {{ source('raw','events') }}