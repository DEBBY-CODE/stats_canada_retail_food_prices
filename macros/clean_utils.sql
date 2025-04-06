{#
This macro converts the cases of a string field/column to lowercase and trims off any unwanted spaces
#}

{% macro clean_string(column_name) -%}
   initcap(trim({{column_name}}))
{%- endmacro %}

{#
This macro safely converts a datetime column into our desired date format
#}

{% macro date_cast(column_name) -%}
    cast({{column_name}} as date)
{%- endmacro %}
