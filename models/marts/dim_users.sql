SELECT
    user_id
    , {{ dbt_utils.surrogate_key('user_id') }} as user_key
    , hometown
    , city
    , country
FROM {{ ref('dwr_users') }}
