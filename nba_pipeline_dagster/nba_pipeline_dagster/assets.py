from dagster import asset, AssetExecutionContext, EnvVar
from dagster_dbt import DbtCliResource, dbt_assets

from dagster_gcp import BigQueryResource
from google.cloud import bigquery

import json
import os
import requests

import pandas as pd
from bs4 import BeautifulSoup
from datetime import datetime

import csv

from .constants import dbt_manifest_path


@dbt_assets(manifest=dbt_manifest_path)
def nba_pipeline_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()

@asset(compute_kind="python",io_manager_key="bigquery_io_manager")
def player_names(context: AssetExecutionContext) -> pd.DataFrame:
    """
    Get player names from https://craftednba.com/players
    """
    url = "https://craftednba.com/players"

    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')

    #Find all elements with class 'name' (assuming 'name' is the class for player names)
    player_names = soup.find_all(class_='name')

    #Extract player names, add hyphen, and make them lowercase
    names_list = ['-'.join(name.get_text().lower().split()) for name in player_names]
    
    df = pd.DataFrame(names_list, columns=['player_name'])

    # preprocessing
    df['player_name'] = df['player_name'].str.replace("'","")
    df.columns = df.columns.str.replace(':','')
    df.columns = df.columns.str.lower()

    # creates the data/raw directory if it doesn't exsit
    os.makedirs("data/raw", exist_ok=True)
    df.to_csv('data/raw/player_names.csv', index=False)

    return df

@asset(compute_kind="python", deps=[player_names], io_manager_key="bigquery_io_manager")
def player_bio(context:AssetExecutionContext) -> pd.DataFrame:
    """
    Get Player Bio
    """
    player_names_df = pd.read_csv('data/raw/player_names.csv')
    player_names = player_names_df['player_name'].tolist()
    # player_names = ['austin-reaves']

    player_bio = []

    for player_name in player_names:
        # Construct the URL for the player
        player_url = f"https://craftednba.com/players/{player_name}"

        # Send a GET request to the player's URL
        response = requests.get(player_url)

        # Parse the HTML content of the player's page
        soup = BeautifulSoup(response.content, 'html.parser')

        # Find the team section containing the desired data
        team_section = soup.find(class_='team flex-wrap')

        # Find all <p> tags within the team section
        p_tags = team_section.find_all('p')

        # Extract the labels and values from the <strong> and <span> tags within <p> tags
        data = {'player_name':player_name}
        for p_tag in p_tags:
            strong_tag = p_tag.find('strong')
            if strong_tag:
                label = strong_tag.text.strip()
                value = p_tag.find('span').text.strip()
                data[label] = value

        # Append the data to the player_data list
        player_bio.append(data)
    
    # Create a DataFrame from the player_data list
    df = pd.DataFrame(player_bio)
    # preprocessing
    df.columns = df.columns.str.replace(':','')
    df.columns = df.columns.str.replace(' ','_')
    df.columns = df.columns.str.lower()

    df.to_csv('data/raw/player_bio.csv', index=False)

    return df

@asset(compute_kind="python", deps=[player_names], io_manager_key="bigquery_io_manager")
def player_roles(context: AssetExecutionContext) -> pd.DataFrame:
    """
    Get players positional role
    """
    player_names_df = pd.read_csv('data/raw/player_names.csv')
    player_names = player_names_df['player_name'].tolist()
    # player_names = ['austin-reaves']

    player_roles = []

    for player_name in player_names:
        player_url = f"https://craftednba.com/players/{player_name}"
        response = requests.get(player_url)
        # Scraping player roles
        player_role_info = {}
        player_role_info['player name'] = player_name
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # finding the the div class
        div = soup.find(class_='inline-block border border-slate-med rounded-b-lg py-2 px-5 customShadow')
        if div:
            p_tags = div.find_all('p')
            for p_tag in p_tags:
                span_tag = p_tag.find_all('span')
                if span_tag:
                    label = span_tag[0].text.strip()
                    value = span_tag[1].text.strip()
                    player_role_info[label] = value
            player_roles.append(player_role_info)
        # not all players have roles so we have to skip that
        else:
            continue
    # Combine all data into one DataFrame
    df = pd.DataFrame(player_roles)
    
    # preprocessing
    df.columns = df.columns.str.replace(':','')
    df.columns = df.columns.str.replace(' ','_')
    df.columns = df.columns.str.lower()

    df.to_csv('data/raw/player_roles.csv', index=False)

    return df

@asset(compute_kind="python", deps=[player_names], io_manager_key="bigquery_io_manager")
def player_stats(context: AssetExecutionContext) -> pd.DataFrame:
    """
    Get players scouting report stats
    """
    player_names_df = pd.read_csv('data/raw/player_names.csv')
    player_names = player_names_df['player_name'].tolist()
    # player_names = ['austin-reaves']

    player_stats = []

    for player_name in player_names:
        player_url = f"https://craftednba.com/players/{player_name}"
        response = requests.get(player_url)
        
        player_stat_info = {}
        player_stat_info['player name'] = player_name

        soup = BeautifulSoup(response.content, 'html.parser')

        # fidning table class
        table = soup.find(class_='w-full sm:w-auto')
        
        # if table class is found on webpage
        if table:
            tbody = table.find('tbody')
            if tbody:
                # find all table rows in tbody
                tr_elements = tbody.find_all('tr')
                for tr in tr_elements:
                    th_element = tr.find('th')
                    td_elements = tr.find_all('td')
                    # validates if the table header and table data exists
                    if th_element and len(td_elements) == 3:
                        # get stat_name
                        stat_name = th_element.text.strip('')
                        # get corresponding stat values
                        # Assuming `stat_value` is your dictionary
                        stat_value = td_elements[0].text.strip()
                        # get corresponding stat percentile
                        percentile_value = td_elements[1].text.strip()
                        
                        player_stat_info[f"{stat_name}_value"] = stat_value
                        player_stat_info[f"{stat_name}_percentile"] = percentile_value

            stats_df = pd.DataFrame(player_stat_info, index=[0])
            player_stats.append(stats_df)
            
        # not all players have a provided scouting report stats on the website
        else:
            continue
    df = pd.concat(player_stats)

    # preprocessing
    df.columns = df.columns.str.replace(':','')
    df.columns = df.columns.str.replace(' ','_')
    #df.columns = df.columns.str.replace('%','')
    df.columns = df.columns.str.lower()
    #df['col'] = df['col'].str.rstrip('%').astype('float') / 100.0

    df.drop(['_value', '_percentile'],inplace=True, axis=1)

    df.to_csv('data/raw/player_stats.csv')

    return df