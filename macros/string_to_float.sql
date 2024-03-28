{#
    This macro converts string values with a percentage sign to decimals
#}

{% macro string_to_float(numbers) -%}

-- Convert height from feet-inches to centimeters

    ROUND(SAFE_CAST(SPLIT({{ numbers }}, "%")[OFFSET(0)] as decimal))

{%- endmacro %}