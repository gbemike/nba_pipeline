from dagster import (
    define_asset_job,
    AssetSelection,
    AssetKey
)

# AsserSelection Returns a selection that includes assets with any of the 
# provided keys and all asset checks that target them

# player_names = AssetSelection.keys('player_names')
# player_bio = AssetSelection.keys('player_bio')
# player_roles = AssetSelection.keys('player_roles')
# player_stats = AssetSelection.keys('player_stats')

# nba_assets = AssetSelection.all()

nba_assets = AssetSelection.all()

# define_asset_job() defines a dagster job
# selection signifies what asset should is being defined it the job

# raw_rates asset job
nba_assets_job = define_asset_job(
    name="materialize_assets_job",
    selection=nba_assets,
)

jobs = [
    nba_assets_job
]