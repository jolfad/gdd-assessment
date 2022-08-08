SELECT
    user_id
    , {{ dbt_utils.surrogate_key('user_id') }} as user_key
    , hometown
    , city
    , country AS country_code
    , dim_countries.country_name
FROM {{ ref('dwr_users') }}
LEFT JOIN {{ ref('dim_countries') }}
ON dwr_users.country = dim_countries.country_code
