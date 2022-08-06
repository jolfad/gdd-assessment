select
user_id
, INITCAP(hometown) AS hometown
, INITCAP(city) AS city
, UPPER(country) AS country
, memberships
 from {{ source('raw','users') }}