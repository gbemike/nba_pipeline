from setuptools import find_packages, setup

setup(
    name="nba_pipeline_dagster",
    version="0.0.1",
    packages=find_packages(),
    install_requires=[
        "dagster",
        "dagster-cloud",
        "dagster-dbt",
        "dbt-bigquery",
        "dbt-postgres",
    ],
    extras_require={
        "dev": [
            "dagster-webserver",
        ]
    },
)