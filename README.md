### Crafted NBA Data Pipeline
Welcome to the Crafted NBA Data Pipeline project! 🏀 This is where data engineering meets the world of basketball, all thanks to the magic of Dagster and dbt. Where we scrape, transform, and load NBA player data from the [crafted NBA website](https://craftednba.com/players).

### Overview
The project involves scraping player data from the crafted nba website. The goal of the project is to create a pipeline using Dagster that scrapes data from the craftednba site using beautiful soup, transforms the data using dbt, specifically Dagsters dbt integration and using Dagsters BigQuery integration we send our data to Big Query then connect the database to tableau and build a dashboard. 

## Data Scraping

Dagter is responsible for the execution of the python scraping modules. The assets are run once a month, a Dagster Asset is an object produced by a pipeline. Beautiful soup is used as the scraping tool.

- The first asset, `player_names`, scrapes player names and headshots from the Crafted NBA website. Player names are transformed into a DataFrame and stored in a CSV file for further processing. The headshot URLs are also extracted and stored along with the player names.
- The `player_bio` task fetches player bio data such as height and age from the website. It iterates through player names, constructs URLs for each player, sends HTTP requests to retrieve player data, and extracts relevant information using BeautifulSoup. The extracted data is then formatted into a DataFrame.
- `player_roles` task retrieves players' positional roles from the website. Similar to `player_bio`, it iterates through player names, constructs URLs, and extracts role information using BeautifulSoup. The extracted data is stored in a DataFrame.
- The `player_stats` task collects scouting report stats for players. It follows a similar process of iterating through player names, constructing URLs, and extracting stats data using BeautifulSoup. The extracted data is stored in a DataFrame.

![Asset Lineage](images/dagster_assets_display.png)

## Data Transformation

Our Dagster assets contain python code that scrape data from the [crafted NBA website](https://craftednba.com/players) as well as our dbt models.
We use the outputs of our assets which are csv files as the seeds for the dbt side of this project, it contains the `player_names`, `player_bio`, `player_roles` and `player_stats` csv files.
In our `schema.yml` file at `models/core` and `models/staging`, we declare the sources, which are the replacements for a seed

Our models contain transformations made on the our the raw file collected from scraping. They are split into two models `staging` and `core`. The `staging` directory contains the `player_names`, `player_bio`, `player_roles` and `player_stats` assets. These assets are still raw, unclean and need a few transformations. We cast data type to their appropriate types and call our needed macros to its needed attributes 
 
##  Data Storage
For data storage the project uses `dbt-bigquery`, which is dbt BigQuery integration. We as use `BigQueryPandsIOManager`. This is a Dagster BigQuery integration that helps us store a pandas dataframe into our database.
To set up `BigQueryPandasIOManager`, we declare it as resource in the `definition.py` file in our dagster directory:

```bash
defs = Definitions(
    """
    ........
    """"
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
```

## Integration with dbt
The nba_pipeline_dbt_assets function integrates the data pipeline with dbt (data build tool), allowing you to execute dbt commands within the context of your Dagster pipeline.
This integration enables you to leverage dbt for further data modeling, transformation, and analysis tasks, building on top of the raw data scraped and prepared by your Dagster assets.

### How it works

To run the application, enter the dagster directory:
```bash
cd nba_pipeline_dagster
```
Then run:
```bash
dagster dev
```
The command above runs the Dagster UI and from here we can run our dagster assets

![Dagster Assets](images/dagster_assets_display.png)

### Dashboard
From the Data the following dashboard was created:

![Crafted NBA Dashboard](images/tableau_dashboard.png)
