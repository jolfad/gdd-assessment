select
venue_id
, name as venue_name
, INITCAP(city) AS city
, UPPER(country) AS country
, lon as longitude
, lat as latitude
 from {{ source('raw','venues') }}