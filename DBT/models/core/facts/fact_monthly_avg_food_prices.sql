-- models/marts/core/fact_prices.sql

{{ config(
    materialized='incremental',
    unique_key = 'fact_price_id'
) }}


with base as (
    select
        reference_date,
        product,
        region,
        average_price
    from {{ ref('stg_stats_canada_raw') }} 
),

with_keys as (
    select
        b.reference_date,
        p.product_id,
        r.region_id,
        b.average_price
    from base b
    left join {{ ref('dim_products') }} p
        on b.product = p.product
    left join {{ ref('dim_regions') }} r
        on b.region = r.region
),



filtered as (
    select *
    from with_keys

    {% if is_incremental() %}
      where {{ dbt_utils.generate_surrogate_key(['reference_date', 'product_id', 'region_id']) }} not in (
          select fact_price_id from {{ this }}
      )
    {% endif %}
),



final_table as (
    select
        {{ dbt_utils.generate_surrogate_key(['reference_date', 'product_id', 'region_id']) }} as fact_price_id,
        reference_date,
        product_id,
        region_id,
        average_price,
        current_timestamp() as load_timestamp
    from filtered
)

select * from final_table
