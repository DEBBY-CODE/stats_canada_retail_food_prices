{{
    config(
        materialized='table'
    )
}}


with source as (
    select distinct
         region,
         region_type
    from {{ ref('stg_stats_canada_raw') }}
),

final_table as (
     select 
         {{ dbt_utils.generate_surrogate_key(['region', 'region_type']) }} as region_id,
         region,
         region_type
     from source
)

select * from final_table
