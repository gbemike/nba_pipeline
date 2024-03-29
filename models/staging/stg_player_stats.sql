{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_stats') }}
),

renamed as (
    select
        player_name,

        -- stats
        {{ string_to_float('ts_value') }} as ts_percentage,
        SAFE_CAST(ts_percentile as decimal) as ts_percentile,
        SAFE_CAST(sq_value as decimal) as sq_value,
        SAFE_CAST(sq_percentile as decimal) as sq_percentile,
        {{ string_to_float('ftr_value') }} as ftr_percentage,
        SAFE_CAST(ftr_percentile as decimal) as ftr_percentile,
        {{ string_to_float('three_par_value') }} as three_par_percentage,
        SAFE_CAST(three_par_percentile as decimal) as three_par_percentile,
        SAFE_CAST(orb_value as decimal) as orb_value,
        SAFE_CAST(orb_percentile as decimal) as orb_percentile,
        {{ string_to_float('ctov_value') }} as ctov_percentage,
        SAFE_CAST(ctov_percentile as decimal) as ctov_percentile,
        SAFE_CAST(load_value as decimal) as load_value,
        SAFE_CAST(load_percentile as decimal) as load_percentile,
        SAFE_CAST(creation_value as decimal) as creation_value,
        SAFE_CAST(creation_percentile as decimal) as creation_percentile,
        SAFE_CAST(portability_value as decimal) as portability_value,
        SAFE_CAST(portability_percentile as decimal) as portability_percentile,
        SAFE_CAST(passer_rating_value as decimal) as passer_rating_value,
        SAFE_CAST(craftedopm_value as decimal) as craftedopm_value,
        SAFE_CAST(craftedopm_percentile as decimal) as craftedopm_percentile,
        SAFE_CAST(deflections_value as decimal) as deflections_value,
        SAFE_CAST(deflections_percentile as decimal) as deflections_percentile,
        SAFE_CAST(radtov_value as decimal) as radtov_value,
        SAFE_CAST(radtov_percentile as decimal) as radtov_percentile,
        SAFE_CAST(drb_value as decimal) as drb_value,
        SAFE_CAST(drb_percentile as decimal) as drb_percentile,
        SAFE_CAST(rim_defense_value as decimal) as rim_defense_value,
        SAFE_CAST(rim_defense_percentile as decimal) as rim_defense_percentile,
        SAFE_CAST(rim_frequency_value as decimal) as rim_frequency_value,
        SAFE_CAST(rim_frequency_percentile as decimal) as rim_frequency_percentile,
        SAFE_CAST(blkpct_value as decimal) as blkpct_value,
        SAFE_CAST(blkpct_percentile as decimal) as blkpct_percentile,
        SAFE_CAST(versatility_value as decimal) as versatility_value,
        SAFE_CAST(versatility_percentile as decimal) as versatility_percentile,
        SAFE_CAST(rpf_value as decimal) as rpf_value,
        SAFE_CAST(rpf_percentile as decimal) as rpf_percentile,
        SAFE_CAST(crafteddpm_value as decimal) as crafteddpm_value,
        SAFE_CAST(crafteddpm_percentile as decimal) as crafteddpm_percentile,

    from source
)

select * from renamed