SELECT
    users.user_id
    , {{ dbt_utils.surrogate_key('users.user_id') }} AS user_key
    , users.hometown
    , users.city
    , users.country AS country_code
    , countries.country_name
FROM {{ ref('dwr_users') }} AS users
LEFT JOIN {{ ref('dim_countries') }} AS countries
    ON users.country = countries.country_code
