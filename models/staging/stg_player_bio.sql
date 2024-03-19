{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_bio') }}
),

renamed as (
    select
        player_bio
    from source
)

select * from renamed