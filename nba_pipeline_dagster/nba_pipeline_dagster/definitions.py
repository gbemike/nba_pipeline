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

from .assets import nba_pipeline_dbt_assets
from .constants import dbt_project_dir
from .schedules import schedules

defs = Definitions(
    assets=[nba_pipeline_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=os.fspath(dbt_project_dir)),
        "bigquery_io_manager": BigQueryPandasIOManager(
            project="dezoomcamp-411023",
            location="us",
            dataset="nba_data",
            gcp_credentials=EnvVar("GCP_CREDENTIALS"),
            timeout=15.0
        )
    },
   
)