{{ config(materialized='table') }}

with player_names as (
    select * from {{ ref('stg_player_names') }}
),

player_bio as (
    select * from {{ ref('stg_player_bio') }}
),

player_roles as (
    select * from {{ ref('stg_player_roles') }}
),

player_stats as (
    select * from {{ ref('stg_player_stats') }}
),

-- Join all

scouting_report as (
    select
        -- player names
        player_names.player_name,

        -- player_bio
        player_bio.height_cm,
        player_bio.age,
        player_bio.weight,
        player_bio.wingspan_cm,
        player_bio.origin,

        -- player_roles
        player_roles.offensive_role,
        player_roles.defensive_role,
        player_stats.ts_value,
        player_stats.ts_percentile,
        player_stats.sq_value,
        player_stats.sq_percentile,
        player_stats.ftr_value,
        player_stats.ftr_percentile,
        player_stats.3par_value,
        player_stats.3par_percentile,
        player_stats.orb_value,
        player_stats.orb_percentile,
        player_stats.ctov_value,
        player_stats.ctov_percentile,
        player_stats.load_value,
        player_stats.load_percentile,
        player_stats.creation_value,
        player_stats.creation_percentile,
        player_stats.portability_value,
        player_stats.portability_percentile,
        player_stats.passer_rating,
        player_stats.craftedopm_value,
        player_stats.craftedopm_percentile,
        player_stats.deflections_value,
        player_stats.deflections_percentile,
        player_stats.radtov_value,
        player_stats.radtov_percentile,
        player_stats.drb_value,
        player_stats.drb_percentile,
        player_stats.rim_defense_value,
        player_stats.rim_defense_percentile,
        player_stats.blkpct_value,
        player_stats.blkpct_percentile,
        player_stats.versatility_value,
        player_stats.versatility_percentile,
        player_stats.rpf_value,
        player_stats.rpf_percentile,
        player_stats.crafteddpm_value,
        player_stats.crafteddpm_percentile

    from player_names
    inner join scouting_report
    on player_names.player_name = scouting_report.player_name
)