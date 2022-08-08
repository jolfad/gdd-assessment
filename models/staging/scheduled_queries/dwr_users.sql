SELECT
    user_id
    , INITCAP(hometown) AS hometown
    , INITCAP(city) AS city
    , UPPER(country) AS country
    , memberships
FROM {{ source('raw','users') }}
