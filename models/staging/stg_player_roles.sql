{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_roles') }}
),

renamed as (
    select
        -- identifiers
        player_name,
        headshots,

        -- player roles
        offensive_role,
        defensive_role
        
    from source
)

select * from renamed