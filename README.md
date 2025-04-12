# Project: Statistic Canada - Monthly Average Retail Food Prices 

## Quick Navigation

## Overview
### 
This project focuses on building a modern data pipeline to process and analyze the Average Retail Food Prices in Canada, published monthly by Statistics Canada.
The pipeline enables end-to-end automation from raw data ingestion to analytical reporting, offering insights into national and regional food pricing trends.
It answers key analytical questions such as:

- How have food prices changed in Canada and across provinces over time?

- Which food categories and products have experienced the highest or lowest  price growth?

- How do prices compare nationally vs. regionally?

The project follows the modern data stack: extracting raw data from cloud storage, transforming it with DBT, and visualizing it using a BI tool, e.g. Power BI.
This was created as part of the DataTalksClub Data Engineering Certification requirements, demonstrating cloud infrastructure integration, data modeling, and business intelligence.
## Project Goals
Develop and build an analytical dashboard  with at least two tiles by the below deliverables:
- Select a dataset of interest (see Data Source Section)
- Create a batch pipeline for processing this dataset and putting it into a datalake 
- Create a batch pipeline for moving the data from the lake to a data warehouse
- Transform & Model the data in the data warehouse: prepare it for the dashboard
- Buildia dashboard to visualize the data
## Architecture 
The data architecture, as seen in the image above, reflects a complete end-to-end pipeline that enables automated ingestion, transformation, and visualization of Statistics Canada data. It consists of the following components:

- Data Ingestion: Source data are uploaded to Google Cloud Storage (GCS), serving as the data lake.

- Data Loading & Staging: Following the medallion architecture structure, files are incrementally loaded into BigQuery, starting with the bronze layer, which captures the untransformed original data from our data source, then progressing through the silver layer, which holds the clean and standardized tables, and lastly the gold layer, in which the final analytics models reside, These include fact and dimension tables used for reporting and dashboarding.

- Data Transformation: DBT Cloud is used to clean, enrich, and model the data using a modular, layered approach.

- Data Visualization: The final DBT models (gold data tables) are visualized in Power BI, providing insights into national and regional food price trends for our project.
## Data Source
The data source can be viewed here [Statistic Canada Monthly Average Retail Prices](https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1810024501). To reproduce the project, leverage the API resource by accessing it via [Statistic Canada Web Data Service](https://www.statcan.gc.ca/en/developers/wds/user-guide#a12-6), use the getFullTableDownloadCSV option for the API URL section in the ingestion script.

Below are the data fields/columns  from the source:
- REF_DATE: Reference Period of the month data was uploaded for, usually the first day of the month as uploaded monthly e.g 2017-01-01 or 2025-02-01
-	GEO: Geography or region, e.g. Canada and its provinces e.g Alberta, Ontario, Quebec etc.
-	DGUID: Not crucial for analysis
-	Products: Products such as food items and other essentials
-	UOM: Unit of Measure, usually in dollars
-	UOM_ID: Not crucial for analysis
-	SCALAR_FACTOR: Not crucial for analysis
-	SCALAR_ID: Not crucial for analysis
-	VECTOR: Not crucial for analysis
-	COORDINATE: Not crucial for analysis
-	VALUE: Average Price per product
-	STATUS: Not crucial for analysis
-	SYMBOL: Not crucial for analysis
-	TERMINATED: Not crucial for analysis
-	DECIMALS: Not crucial for analysis

The key fields we'll be working within DBT will be ref_date, geo, products, uom and value
## Technology Stack
- Google Cloud Storage (GCS): Object storage for source data, e.g. our CSV files extracted from our Stats Canada API

- Google BigQuery: Analytical data warehouse

- Terraform: Infrastructure as Code – used to provision GCP resources

- Docker: Containerization for running services like Kestra

- Python: Used in scripts to support ingestion, backfilling, and incremental data loads

- Kestra: Workflow orchestration (GCS → BigQuery etc.)

- DBT Cloud: Data transformation & modeling

- Power BI: Data visualization
  
## How to Reproduce the Project (Detailed Section)
This section provides a step-by-step guide to replicating the entire pipeline, from infrastructure provisioning to dashboard development.

You can choose to run everything locally on your system or use a Google Cloud VM for a fully cloud-based setup (as done in this project).

### 1. Prerequisites
Before you begin, ensure you have the following tools and accounts:

a. Setup a  Google Cloud Platform (GCP) Account - If you set up a new free account, it expires in 90 days, meaning you have about $400 worth of credit to use until the 90 days expire.

b. Create a new project and keep track of the project ID as we need to for a lot of authentication 

c. Create a  service account with the following roles : 
- Big Query Admin
- Storage Admin
- Compute Admin
b. Install Terraform on your VM machine or local system if you opt for recreating the project via this method.
c. Install docker

## Analytics Report/Dashboard 
The interactive dashboard  can be viewed here [Stats Canada Power BI Dashboard/Report](https://app.powerbi.com/view?r=eyJrIjoiODdkYTFlMjEtYWFiMi00YzZlLWIyODEtYzlhYjk2OWQwZmIxIiwidCI6IjA2ZjNhOGJlLThkYWUtNGM5MS05Y2RhLTliZTM3ZjhmYTgyNiJ9), it presents insights across two key pages :
1. National Overview
![Screenshot (62)](https://github.com/user-attachments/assets/a715eaef-a950-41dc-9b15-d9393b78fd1f)

2. Provincial
   
![Screenshot (63)](https://github.com/user-attachments/assets/484c2b0b-266c-41bd-a038-cbcb6b028364)

3. National vs Provincial Price Tracker as seen in the interactive dashboard
## Contact 
Have questions or feedback? Let’s connect!
[💼 LinkedIn – Deborah Alenkhe](https://www.linkedin.com/public-profile/settings?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_self_edit_contact-info%3Bv%2Bca91M6Tn2ZgulfjUpxXA%3D%3D)
