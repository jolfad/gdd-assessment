select
group_id
, {{ dbt_utils.surrogate_key('group_id') }} as group_key
, group_name
, description
, city
, latitude
, longitude
, ST_GEOGPOINT(latitude, longitude) AS group_coordinates
, time_group_created
, link as group_url
from ref('dwr_groups')
