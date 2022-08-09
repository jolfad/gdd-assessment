SELECT
    name AS country_name
    , alpha_2 AS country_code
FROM {{ ref('countries_info') }}
