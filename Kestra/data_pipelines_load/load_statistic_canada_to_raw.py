from google.cloud import bigquery, storage
from google.oauth2 import service_account
import pandas as pd
import io
import os


# GCP Config
PROJECT_ID =  os.getenv("GCP_PROJECT_ID", "Please insert your GCP project-ID here ")
DATASET_ID = "bronze_stats_canada_raw"
TABLE_ID = "stats_canada_raw"
GCS_BUCKET = "stats-canada-data-lake-tf"
GCS_FILE = "stats_canada_data.csv"

# Authentication
bq_client = bigquery.Client(project=PROJECT_ID)
gcs_client = storage.Client(project=PROJECT_ID)

# Read CSV from GCS
bucket = gcs_client.get_bucket(GCS_BUCKET)
blob = bucket.blob(GCS_FILE)
csv_data = blob.download_as_bytes()
df_new = pd.read_csv(io.BytesIO(csv_data))

# Clean & parse REF_DATE
df_new["REF_DATE"] = pd.to_datetime(df_new["REF_DATE"], errors='coerce')

# Define table ref
table_ref = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"

# Check if table exists
try:
    table = bq_client.get_table(table_ref)
    print("Table exists. Checking for new months...")

    # Load current table into memory (only REF_DATEs)
    query = f"SELECT DISTINCT REF_DATE FROM `{table_ref}`"
    df_existing = bq_client.query(query).to_dataframe()

    # Filter only new months
    df_diff = df_new[~df_new["REF_DATE"].isin(df_existing["REF_DATE"])]

    if df_diff.empty:
        print("✅ No new months to load. Data is up-to-date.")
    else:
        print(f"Loading {len(df_diff)} new rows to BigQuery...")
        job = bq_client.load_table_from_dataframe(df_diff, table_ref)
        job.result()
        print("✅ Incremental load complete.")

except Exception as e:
    if "Not found" in str(e):
        print("Table does NOT exist. Creating and loading full dataset from 2017...")
        df_filtered = df_new[df_new["REF_DATE"] >= "2017-01-01"]
        job = bq_client.load_table_from_dataframe(df_filtered, table_ref)
        job.result()
        print("✅ Table created and full dataset loaded.")
    else:
        raise

