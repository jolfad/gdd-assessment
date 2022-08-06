with events_base as
(
select 
event_name,
description,
time_event_created,
time_event_start,
event_status,
event_duration_hour,
rsvp_limit,
rsvps.user_id,
rsvps.response,
group_id,
venue_id
from
{{ ref('dwr_events') }}
cross join
unnest(rsvps) as rsvps
)
, venues_base as
(
select venue_id, venue_key from {{ ref('dim_venues') }}
)
, groups_base as
(
select group_id, group_key from {{ ref('dim_groups') }}
)

, final as
(
select 
events_base.event_name,
events_base.description,
events_base.time_event_created,
events_base.time_event_start,
events_base.event_status,
events_base.event_duration_hour,
events_base.rsvp_limit,
groups_base.group_key,
venues_base.venue_key,
count(events_base.user_id) user_rsvps,
sum(case when events_base.response='yes' then 1 else 0 end) as responded_yes,
sum(case when events_base.response='no' then 1 else 0 end) as responded_no
from events_base
left join groups_base on events_base.group_id = groups_base.group_id
left join venues_base on events_base.venue_id = venues_base.venue_id
{{ dbt_utils.group_by(9) }}
)

select * from final