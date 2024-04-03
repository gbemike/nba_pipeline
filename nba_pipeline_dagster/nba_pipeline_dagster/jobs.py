from dagster import (
    define_asset_job,
    AssetSelection,
    AssetKey
)

nba_assets = AssetSelection.all()

# job
nba_assets_job = define_asset_job(
    name="materialize_assets_job",
    selection=nba_assets,
)

jobs = [
    nba_assets_job
]