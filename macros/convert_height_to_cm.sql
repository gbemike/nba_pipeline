{#
    This macro converts values in feet and inches to centimeters
#}

{% macro convert_height_to_cm(height) -%}

-- Convert height from feet-inches to centimeters

    ROUND((cast(SPLIT({{ height }}, "'")[OFFSET(0)] as decimal) * 30.48) +
    (cast(SPLIT(SPLIT({{ height }}, "'")[OFFSET(1)], '"')[OFFSET(0)] as decimal) * 2.54))

{%- endmacro %}