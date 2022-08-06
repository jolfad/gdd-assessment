WITH unnest_topics AS (
    SELECT
        group_id
, topics AS topic
    FROM {{ ref('dwr_groups') }}
    CROSS JOIN
        unnest(topics) AS topics
)

, get_group_key AS (
    SELECT
        group_id
, group_key
    FROM {{ ref('dim_groups') }}
)

, final AS (
    SELECT
        {{ dbt_utils.surrogate_key('unnest_topics.topic') }} AS topic_key
        , unnest_topics.topic AS topic_name
        , get_group_key.group_key
    FROM unnest_topics
    LEFT JOIN
        get_group_key
        ON unnest_topics.group_id = get_group_key.group_id
)

SELECT * FROM final
