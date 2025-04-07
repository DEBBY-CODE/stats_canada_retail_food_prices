{{
    config(
        materialized='table'
    )
}}


with source as (
    select distinct 
    product,
    product_unit_of_measure
    from {{ ref('stg_stats_canada_raw') }}
),

with_product_category as (

    select
         s.product,
         s.product_unit_of_measure,
         c.category as product_category_name
    from source as s
    left join {{ref('product_categories')}} as c
        on s.product = {{clean_string('c.product')}}
),

final_table as (
    select
           {{ dbt_utils.generate_surrogate_key(['product']) }} as product_id,
           product,
           product_unit_of_measure,
           {{clean_string('product_category_name')}} as  product_category_name
    from with_product_category
)

select * from final_table
