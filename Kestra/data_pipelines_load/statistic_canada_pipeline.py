import dlt
import requests
import zipfile
import io
import pandas as pd
from google.cloud import storage
from datetime import datetime, timedelta

#  Google Cloud Storage (GCS) Config
BUCKET_NAME = "stats-canada-data-lake-tf"
DESTINATION_BLOB_NAME = "stats_canada_data.csv"

# Stats Canada API URL
API_URL = "https://www150.statcan.gc.ca/t1/wds/rest/getFullTableDownloadCSV/18100245/en"

# Fetch ZIP file from the API
response = requests.get(API_URL)
zip_url = response.json()["object"]
zip_response = requests.get(zip_url)
zip_bytes = io.BytesIO(zip_response.content)

# Extract CSV from the ZIP file
with zipfile.ZipFile(zip_bytes, "r") as z:
    csv_filename = z.namelist()[0]
    print(f" Extracting CSV file: {csv_filename}")
    with z.open(csv_filename) as csv_file:
        df = pd.read_csv(csv_file)

#  Convert date format
df["REF_DATE"] = pd.to_datetime(df["REF_DATE"], errors='coerce')

#  Authenticate with Google Cloud
client = storage.Client()
bucket = client.bucket(BUCKET_NAME)
blob = bucket.blob(DESTINATION_BLOB_NAME)

# Check if file exists in GCS
if blob.exists():
    print(" File exists in GCS. Checking for missing months...")

    # Download existing file from GCS
    existing_data = blob.download_as_text()
    df_existing = pd.read_csv(io.StringIO(existing_data))
    df_existing["REF_DATE"] = pd.to_datetime(df_existing["REF_DATE"], errors='coerce')

    #  Identify existing and new month periods
    existing_months = df_existing["REF_DATE"].dt.to_period("M").unique()
    df["month_period"] = df["REF_DATE"].dt.to_period("M")
    df_missing = df[~df["month_period"].isin(existing_months)].drop(columns=["month_period"])

    if df_missing.empty:
        print("✅ No new months to add. GCS is up to date.")
    else:
        print(f" Found {df_missing['REF_DATE'].dt.to_period('M').nunique()} missing month(s). Uploading...")

        # Combine and deduplicate
        df_combined = pd.concat([df_existing, df_missing])
        df_combined = df_combined.drop_duplicates(
            subset=["REF_DATE", "GEO", "Products", "VECTOR"],
            keep="last"
        )

        # Upload updated file
        blob.upload_from_string(df_combined.to_csv(index=False), "text/csv")
        print("✅ Uploaded missing month(s) to GCS successfully!")

else:
    print("File does NOT exist in GCS. Uploading full dataset from 2017...")

    # Upload all data from 2017 onwards
    df_filtered = df[df["REF_DATE"] >= "2017-01-01"]
    blob.upload_from_string(df_filtered.to_csv(index=False), "text/csv")
    print("✅ Uploaded full dataset from 2017 to GCS!")

