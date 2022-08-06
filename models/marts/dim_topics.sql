with unnest_topics as
(
select group_id, topics as topic
from {{ ref('dwr_groups') }}
cross join
unnest(topics) as topics
)

, get_group_key as
(
select group_id, group_key
from {{ ref('dim_groups') }}
)

, final as
(
select 
{{ dbt_utils.surrogate_key('unnest_topics.topic') }} as topic_key
, unnest_topics.topic as topic_name
, get_group_key.group_key
from unnest_topics
left join
get_group_key
on unnest_topics.group_id=get_group_key.group_id
)

select * from final