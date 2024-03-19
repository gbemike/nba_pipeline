{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_roles') }}
),

renamed as (
    select
        player_roles
    from source
)

select * from renamed