select 
name as country_name,
alpha_2 as country_code
 from {{ ref('countries_info') }}