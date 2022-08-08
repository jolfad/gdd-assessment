SELECT
    group_key
, count(user_key) AS num_members
FROM {{ ref('fact_group_memberships') }}
{{ dbt_utils.group_by(1) }}
