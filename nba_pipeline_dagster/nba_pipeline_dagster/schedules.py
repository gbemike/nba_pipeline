"""
To add a daily schedule that materializes your dbt assets, uncomment the following lines.
"""
from dagster import (
    AssetSelection,
    ScheduleDefinition,
)

from .jobs import nba_assets_job

from dagster_dbt import build_schedule_from_dbt_selection

from .assets import nba_pipeline_dbt_assets

schedules = [
     build_schedule_from_dbt_selection(
         [nba_pipeline_dbt_assets],
         job_name="materialize_dbt_models",
         cron_schedule="0 0 1 * *",
         dbt_select="fqn:*",
     ),

    ScheduleDefinition(
        name="materialize_python_assets",
        job=nba_assets_job,
        cron_schedule="0 0 1 * *",
    )
]