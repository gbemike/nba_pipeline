{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_stats') }}
),

renamed as (
    select
        player_name,

        -- stats
        cast(ts_value as numeric) as ts_value(%),
        cast(ts_percentile as numeric) as ts_percentile,
        cast(sq_value as numeric) as sq_value,
        cast(sq_percentile as numeric) as sq_percentile,
        cast(ftr_value as numeric) as ftr_value(%),
        cast(ftr_percentile as numeric) as ftr_percentile,
        cast(3par_value as numeric) as 3par_value(%),
        cast(3par_percentile as numeric) as 3par_percentile,
        cast(orb_value as numeric) as orb_value,
        cast(orb_percentile as numeric) as orb_percentile,
        cast(ctov_value as numeric) as ctov_value(%),
        cast(ctov_percentile as numeric) as ctov_percentile,
        cast(load_value as numeric) as load_value,
        cast(load_percentile as numeric) as load_percentile,
        cast(creation_value as numeric) as creation_value,
        cast(creation_percentile as numeric) as creation_percentile,
        cast(portability_value as numeric) as portability_value,
        cast(portability_percentile as numeric) as portability_percentile,
        cast(passer_rating as numeric) as passer_rating,
        cast(craftedopm_value as numeric) as craftedopm_value,
        cast(craftedopm_percentile as numeric) as craftedopm_percentile,
        cast(deflections_value as numeric) as deflections_value,
        cast(deflections_percentile as numeric) as deflections_percentile,
        cast(radtov_value as numeric) as radtov_value,
        cast(radtov_percentile as numeric) as radtov_percentile,
        cast(drb_value as numeric) as drb_value,
        cast(drb_percentile as numeric) as drb_percentile,
        cast(rim_defense_value as numeric) as rim_defense_value,
        cast(rim_defense_percentile as numeric) as rim_defense_percentile,
        cast(rim_frequency_value as numeric) as rim_frequency_value,
        cast(rim_frequency_percentile as numeric) as rim_frequency_percentile,
        cast(blkpct_value as numeric) as blkpct_value,
        cast(versatility_value as numeric) as versatility_value,
        cast(versatility_percentile as numeric) as versatility_percentile,
        cast(rpf_value as numeric) as rpf_value,
        cast(rpf_percentile as numeric) as rpf_percentile,
        cast(crafteddpm_value as numeric) as crafteddpm_value,
        cast(crafteddpm_percentile as numeric) as crafteddpm_percentile

    from source
)

select * from renamed