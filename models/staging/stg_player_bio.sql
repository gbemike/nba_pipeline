{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_bio') }}
),

renamed as (
    select
        -- identifiers
        player_name,

        -- player info
        height,
        cast(age as numeric) as age,
        cast(weight_lb as numeric) as weight_lb,
        positional_size,
        wingspan,
        origin

    from source
)

select * from renamed