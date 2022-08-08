SELECT
    venue_id
    , {{ dbt_utils.surrogate_key('venue_id') }} AS venue_key
    , venue_name
    , city
    , country AS country_code
    , dim_countries.country_name
    , latitude
    , longitude
    , SAFE.ST_GEOGPOINT(latitude, longitude) AS venue_coordinates
FROM {{ ref('dwr_venues') }}
LEFT JOIN {{ ref('dim_countries') }}
ON dwr_venues.country = dim_countries.country_code