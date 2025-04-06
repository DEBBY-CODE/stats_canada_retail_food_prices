{{ config(
    materialized='incremental',
    unique_key = 'stats_canada_id'
) }}

with 

source as (

    select * from {{ source('staging', 'stats_canada_raw') }}
    where ref_date is not null

    {% if is_incremental() %}
        and ref_date > (select max(reference_date) from {{ this }})
    {% endif %}

),

renamed as (

    select
    {{ dbt_utils.generate_surrogate_key(['ref_date', 'geo', 'products']) }} as stats_canada_id,
        {{date_cast('ref_date')}} as reference_date,
        {{ clean_string('geo') }} as region,
        case 
            when geo = 'Canada' then 'National'
            else 'Province'
        end as region_type,
        dguid,
        {{ clean_string('products') }} as product,
        uom as product_unit_of_measure,
        uom_id as unit_of_measure_id,
        -- scalar_factor,
        -- scalar_id,
        -- vector,
        -- coordinate,
       cast( value as float64) as average_price,
        -- status,
        -- symbol,
        -- terminated,
        -- decimals
        current_timestamp() as load_timestamp
    from source

    

)

select * from renamed

-- dbt build --select stg_stats_canada_raw --vars '{'is_test_run': 'false'}'
{#{% if var ('is_test_run', default = true)%}

limit 100

{% endif %}
#}
