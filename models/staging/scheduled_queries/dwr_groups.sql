SELECT
    group_id
    , name AS group_name
    , description
    , INITCAP(city) AS city
    , lat AS latitude
    , lon AS longitude
    , TIMESTAMP_MILLIS(created) AS time_group_created
    , link AS group_url
    , topics
FROM {{ source('raw','groups') }}
