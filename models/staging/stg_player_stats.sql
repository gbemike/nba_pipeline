{{ config(materialized='view') }}

with source as (
    select * from {{ source('nba_data', 'player_stats') }}
),

renamed as (
    select
        player_name,

        -- stats
        {{ dbt.safe_cast("ts_value", api.Column.translate_type("float")) }} as ts_value,
        {{ dbt.safe_cast("ts_percentile",  api.Column.translate_type("float")) }} as ts_percentile,
        {{ dbt.safe_cast("sq_value",  api.Column.translate_type("float")) }} as sq_value,
        {{ dbt.safe_cast("sq_percentile",  api.Column.translate_type("float")) }} as sq_percentile,
        {{ dbt.safe_cast("ftr_value",  api.Column.translate_type("float")) }} as ftr_value,
        {{ dbt.safe_cast("ftr_percentile",  api.Column.translate_type("float")) }} as ftr_percentile,
        {{ dbt.safe_cast("3par_value",  api.Column.translate_type("float")) }} as 3par_value,
        {{ dbt.safe_cast("3par_percentile",  api.Column.translate_type("float")) }} as 3par_percentile,
        {{ dbt.safe_cast("orb_value",  api.Column.translate_type("float")) }} as orb_value,
        {{ dbt.safe_cast("orb_percentile",  api.Column.translate_type("float")) }} as orb_percentile,
        {{ dbt.safe_cast("ctov_value",  api.Column.translate_type("float")) }} as ctov_value,
        {{ dbt.safe_cast("ctov_percentile",  api.Column.translate_type("float")) }} as ctov_percentile,
        {{ dbt.safe_cast("load_value",  api.Column.translate_type("float")) }} as load_value,
        {{ dbt.safe_cast("load_percentile",  api.Column.translate_type("float")) }} as load_percentile,
        {{ dbt.safe_cast("creation_value",  api.Column.translate_type("float")) }} as creation_value,
        {{ dbt.safe_cast("creation_percentile",  api.Column.translate_type("float")) }} as creation_percentile,
        {{ dbt.safe_cast("portability_value",  api.Column.translate_type("float")) }} as portability_value,
        {{ dbt.safe_cast("portability_percentile",  api.Column.translate_type("float")) }} as portability_percentile,
        {{ dbt.safe_cast("passer_rating",  api.Column.translate_type("float")) }} as passer_rating,
        {{ dbt.safe_cast("craftedopm_value",  api.Column.translate_type("float")) }} as craftedopm_value,
        {{ dbt.safe_cast("craftedopm_percentile",  api.Column.translate_type("float")) }} as craftedopm_percentile,
        {{ dbt.safe_cast("deflections_value",  api.Column.translate_type("float")) }} as deflections_value,
        {{ dbt.safe_cast("deflections_percentile",  api.Column.translate_type("float")) }} as deflections_percentile,
        {{ dbt.safe_cast("radtov_value",  api.Column.translate_type("float")) }} as radtov_value,
        {{ dbt.safe_cast("radtov_percentile",  api.Column.translate_type("float")) }} as radtov_percentile,
        {{ dbt.safe_cast("drb_value",  api.Column.translate_type("float")) }} as drb_value,
        {{ dbt.safe_cast("drb_percentile",  api.Column.translate_type("float")) }} as drb_percentile,
        {{ dbt.safe_cast("rim_defense_value",  api.Column.translate_type("float")) }} as rim_defense_value,
        {{ dbt.safe_cast("rim_defense_percentile",  api.Column.translate_type("float")) }} as rim_defense_percentile,
        {{ dbt.safe_cast("rim_frequency_value",  api.Column.translate_type("float")) }} as rim_frequency_value,
        {{ dbt.safe_cast("rim_frequency_percentile",  api.Column.translate_type("float")) }} as rim_frequency_percentile,
        {{ dbt.safe_cast("blkpct_value",  api.Column.translate_type("float")) }} as blkpct_value,
        {{ dbt.safe_cast("blkpct_percentile",  api.Column.translate_type("float")) }} as blkpct_percentile,
        {{ dbt.safe_cast("versatility_value",  api.Column.translate_type("float")) }} as versatility_value,
        {{ dbt.safe_cast("versatility_percentile",  api.Column.translate_type("float")) }} as versatility_percentile,
        {{ dbt.safe_cast("rpf_value",  api.Column.translate_type("float")) }} as rpf_value,
        {{ dbt.safe_cast("rpf_percentile",  api.Column.translate_type("float")) }} as rpf_percentile,
        {{ dbt.safe_cast("crafteddpm_value",  api.Column.translate_type("float")) }} as crafteddpm_value,
        {{ dbt.safe_cast("crafteddpm_percentile",  api.Column.translate_type("float")) }} as crafteddpm_percentile,

    from source
)

select * from renamed