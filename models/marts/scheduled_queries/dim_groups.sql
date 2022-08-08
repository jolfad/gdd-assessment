SELECT
    group_id
    , {{ dbt_utils.surrogate_key('group_id') }} as group_key
    , group_name
    , description
    , city
    , latitude
    , longitude
    , ST_GEOGPOINT(latitude, longitude) AS group_coordinates
    , time_group_created
    , CAST(TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), time_group_created, DAY)/365 AS INT64) AS group_age_year
    , group_url
FROM {{ ref('dwr_groups') }}
