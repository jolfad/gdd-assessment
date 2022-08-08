WITH unnest_user_memberships
AS (
    SELECT
        user_id
        , memberships.group_id
        , memberships.joined
    FROM {{ ref('dwr_users') }}
    CROSS JOIN
        unnest(memberships) AS memberships
)

, users_base AS (
    SELECT
        user_id
        , user_key
    FROM {{ ref('dim_users') }}
)

, groups_base AS (
    SELECT
        group_id
        , group_key
    FROM {{ ref('dim_groups') }}
)

, final AS (

    SELECT
        users_base.user_key
        , groups_base.group_key
        , timestamp_millis(unnest_user_memberships.joined) AS time_user_joined
    FROM unnest_user_memberships
    LEFT JOIN users_base ON unnest_user_memberships.user_id = users_base.user_id
    LEFT JOIN groups_base ON unnest_user_memberships.group_id = groups_base.group_id

)

SELECT * FROM final
