import os

from dagster import (
    Definitions,
    load_assets_from_modules,
    define_asset_job,
    EnvVar
    )
from dagster_dbt import DbtCliResource

from dagster_gcp import BigQueryResource
from dagster_gcp_pandas import BigQueryPandasIOManager
from dagster_gcp.gcs import GCSPickleIOManager, GCSResource

from .assets import (
    nba_pipeline_dbt_assets, 
    player_names, 
    player_bio, 
    player_roles, 
    player_stats
)

from .constants import dbt_project_dir
from .schedules import schedules
from .jobs import jobs

defs = Definitions(
    assets=[nba_pipeline_dbt_assets, player_names, player_bio, player_roles, player_stats],
    schedules=schedules,
    jobs=jobs,
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
        "bigquery_io_manager": BigQueryPandasIOManager(
            project=EnvVar("PROJECT_ID"),
            location=EnvVar("LOCATION"),
            dataset="nba_data",
            gcp_credentials=EnvVar("GCP_CREDENTIALS"),
            timeout=15.0
        )
    },
   
)