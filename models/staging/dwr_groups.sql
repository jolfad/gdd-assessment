select
group_id
, name as group_name
, description
, INITCAP(city) as city
, lat as latitude
, lon as longitude
, timestamp_millis(created) as time_group_created
, link as group_url
, topics
 from {{ source('raw','groups') }}