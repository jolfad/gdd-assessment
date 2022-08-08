SELECT
    venues.venue_id
    , {{ dbt_utils.surrogate_key('venues.venue_id') }} AS venue_key
    , venues.venue_name
    , venues.city
    , venues.country AS country_code
    , countries.country_name
    , venues.latitude
    , venues.longitude
    , SAFE.ST_GEOGPOINT(venues.latitude, venues.longitude) AS venue_coordinates
FROM {{ ref('dwr_venues') }} AS venues
LEFT JOIN {{ ref('dim_countries') }} AS countries
ON venues.country = countries.country_code