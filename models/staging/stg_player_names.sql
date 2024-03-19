{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_names') }}
),

renamed as (
    select
        player_name
    from source
)

select * from renamed