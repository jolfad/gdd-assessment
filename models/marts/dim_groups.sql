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
    , group_url
FROM {{ ref('dwr_groups') }}
