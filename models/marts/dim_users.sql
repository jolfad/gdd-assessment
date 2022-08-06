select
user_id
, {{ dbt_utils.surrogate_key('user_id') }} as user_key
, hometown
, city
, country
 from {{ ref('dwr_users') }}