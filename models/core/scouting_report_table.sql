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

ps as (
    select * from {{ ref('stg_player_stats') }}
),

-- Join all

scouting_report as (
    select
        -- player names
        pn.player_name,
        pn.headshots,

        -- player_bio
        pb.height,
        pb.age,
        pb.weight_lb,
        pb.wingspan,
        pb.origin,

        -- player_roles
        pr.offensive_role,
        pr.defensive_role,

        -- player stats
        ps.ts_value,
        ps.ts_percentile,
        ps.sq_value,
        ps.sq_percentile,
        ps.ftr_value,
        ps.ftr_percentile,
        ps.three_par_value,
        ps.three_par_percentile,
        ps.orb_value,
        ps.orb_percentile,
        ps.ctov_value,
        ps.ctov_percentile,
        ps.load_value,
        ps.load_percentile,
        ps.creation_value,
        ps.creation_percentile,
        ps.portability_value,
        ps.portability_percentile,
        ps.passer_rating_value,
        ps.craftedopm_value,
        ps.craftedopm_percentile,
        ps.deflections_value,
        ps.deflections_percentile,
        ps.radtov_value,
        ps.radtov_percentile,
        ps.drb_value,
        ps.drb_percentile,
        ps.rim_defense_value,
        ps.rim_defense_percentile,
        ps.blkpct_value,
        ps.blkpct_percentile,
        ps.versatility_value,
        ps.versatility_percentile,
        ps.rpf_value,
        ps.rpf_percentile,
        ps.crafteddpm_value,
        ps.crafteddpm_percentile

    from
        player_names as pn
        inner join player_bio as pb 
        on pn.player_name = pb.player_name
        inner join player_roles as pr 
        on pn.player_name = pr.player_name
        inner join ps as ps 
        on pn.player_name = ps.player_name
)

select * from scouting_report