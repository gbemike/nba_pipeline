{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_bio') }}
),

renamed as (
    select
        -- identifiers
        player_name

        -- player info
        {{ convert_height_to_cm('height') }} as height_cm,
        cast(age as numeric) as age,
        cast(weight as numeric) as weight,
        positional_size,
        {{ convert_height_to_cm('wingspan') }} as wingspan_cm,
        origin

    from source
)

select * from renamed