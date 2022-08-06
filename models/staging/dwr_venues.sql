SELECT
    venue_id
    , name AS venue_name
    , INITCAP(city) AS city
    , UPPER(country) AS country
    , lon AS longitude
    , lat AS latitude
FROM {{ source('raw','venues') }}
