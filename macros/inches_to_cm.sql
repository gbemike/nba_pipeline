{#
    This macro converts values in feet and inches to centimeters
#}

{% macro convert_height_to_cm(height) %}

    -- Convert height from feet-inches to centimeters
    with converted_height as (
        select
            -- parse feet
            cast(dbt.split_part({{ height }}, '''', 1) as float) as feet, 
            -- parse inches
            cast(split_part(split_part({{ height }}, '''', 2), '"', 1) as float) as inches
    )

    select
        (feet * 30.48) + (inches * 2.54) as height_cm
    from
        converted_height

{% endmacro %}
