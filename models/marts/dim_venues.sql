SELECT
    venue_id
    , {{ dbt_utils.surrogate_key('venue_id') }} AS venue_key
    , venue_name
    , city
    , country
    , latitude
    , longitude
    , SAFE.ST_GEOGPOINT(latitude, longitude) AS venue_coordinates
FROM {{ ref('dwr_venues') }}
