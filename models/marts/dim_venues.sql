select
venue_id
, {{ dbt_utils.surrogate_key('venue_id') }} as venue_key
, venue_name
, city
, country
, latitude
, longitude
, SAFE.ST_GEOGPOINT(latitude, longitude) AS venue_coordinates
from {{ ref('dwr_venues') }}