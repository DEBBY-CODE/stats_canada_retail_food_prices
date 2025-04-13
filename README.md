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

As seen in section 2, this project uses a Compute Engine VM instance to run the ingestion and orchestration components. However, you can also run everything locally if preferred.

### 1. Prerequisites
Before setting up the pipeline, ensure you have the following:  
   A. Google Cloud Platform Account setup
   
   B. Install Terraform for infrastructure provisioning on your local machine or  VM. [Tutorial](https://youtu.be/Y2ux7gq3Z0o?si=7GL0HLtkApY2CaqG)

   C. Install Docker to run Kestra and support services on your local machine or VM. [Link](https://docs.docker.com/engine/install/)

   D. Create a free DBT Cloud account; we use DBT Cloud for this project, so there is no need to install DBT CLI. [Link](https://www.getdbt.com/signup)

   E. Install Git for cloning this GitHub repository on your local machine or  VM.


### 2. Datawarehouse - Google Cloud Platform ( GCP ) Setup :  
- Create a Google Cloud Platform (GCP) account with billing enabled - If you set up a new free account, it expires in 90 days, meaning you have about $400 worth of credit to use until the 90 days expire.
- Enable the following GCP APIs for the project: BigQuery API, Cloud Storage API, Compute Engine API.
- Create a new GCP project via the Cloud Console and note down the Project ID, as you’ll need it throughout the setup process.
- Create a Google Cloud Service Account with the following roles: BigQuery Admin, Storage Admin, Compute Admin.
- Once the service account has been created, Create and Download the service account JSON key file in a secure location on your system. This will be used to authenticate Google services used to build the pipeline workflow with tools like Kestra, DBT, Power BI etc.

📌OPTIONAL: Using a Google Cloud VM (Recommended Setup)

To manage orchestration and transformations in a cloud environment, this project uses a Compute Engine VM manually created in Google Cloud.

🔁 You can also choose to run everything locally on your machine if you prefer. The VM is optional but useful for separating environments and running Dockerized services like Kestra.

Using a GCP VM, you can connect to it in two ways: Option 1 - SSH via gcloud CLI terminal  or Option 2 - VSCode Remote SSH Extension and install the required tools/resources, e.g., Terraform, docker, dbt, etc.

For a more comfortable development experience, use option 2 - VS Code with the Remote SSH extension; below are  detailed links to set things up correctly:
- How to create a GCP VM  [Setting Up A VM on GCP](https://youtu.be/18QgmuKq4zE?si=X2lsKFM_vLXxqb_0)
- Connecting to your remote VM instance [Two Ways to Add SSH Keys GCP VM](https://youtu.be/91MXOH0VV7U?si=nXWZaJNx_Czo5plZ).
- Additional Video to support  the first and second link [Setting Up A VM on GCP + SSH Access](https://www.youtube.com/watch?v=ae-CV2KfoN0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=16)

⚠️ Note: A newly created VM is essentially a bare system, it does not come pre-installed with the tools your project depends on.
Once you have connected to the VM via the VS Code remote SSH extension, your VSCode remote instance should look similar to the image below with the name you've called your VM.
![Screenshot (66)](https://github.com/user-attachments/assets/9b3168a3-4a87-47e6-bf2b-29a89c6d3cb1)

Follow these steps to install the necessary packages and set up your environment:
1. Install Git (so we can clone the repo)
2. Clone this git repository to access the project files and dependencies
3. Install system-level tools, e.g. Docker, Python packages, Terraform, etc from within the cloned project
4. Install Pip & Python
5. Install Python packages as seen in the requirements.txt file
6. Install Terraform

### 3. Infrastructure Provisioning Resources - Terraform
This project uses Terraform to provision critical cloud infrastructure on the Google Cloud Platform, ensuring repeatable and version-controlled resource creation.

Terraform is used to create:
- A GCS bucket (data lake) for storing raw CSV files
- Three BigQuery datasets representing the medallion architecture: raw_data (Bronze layer), staging_data (Silver layer), analytics_mart (Gold layer)

📌 Step-by-Step Instructions to Reproduce Similar Resources
1. Ensure terraform has been installed correctly you can check for it by inputting this in your terminal to return the version of terraform you're using ``` terraform --version ```
2.  In your terminal, Create a new directory for Terraform and a folder called stats_canada_steup to nest our tf files for this project. Alternatively You can also clone this repository.
     ```mkdir -p ~/terraform/stats_canada_setup ```
3. Navigate into the terraform directory/folder  created ```cd  ~/terraform/stats_canada_setup```
4. Create the following files inside the directory/folder, copy contents of the files in the repo :
- main.tf: Define your GCS bucket and BigQuery datasets

- variables.tf: Declare inputs like project ID, region, bucket name, etc.

- terraform.tfvars: Store actual values (you will create this manually as it holds the name of the variables in my variable.tf file). Do not commit this file to GitHub—it contains project-specific values. I have attached mine but removed the values I kept, so you can use the template to recreate yours.
Edit the variables.tf and terraform.tfvars to match your required region (Mine was north America-northeast1, similar to that of my VM), and also give your bucket and datasets the required name.

5. Initialize Terraform ``` terraform init```  to get the cloud provider (in this instance, Google)
6. Validate and preview the resources ``` terraform plan ```
7. Apply the changes to create the infrastructure ``` terraform apply ```
8. Confirm the following are created in your GCP project:
  - A GCS bucket with versioning enabled
  - BigQuery datasets: raw_data, staging_data, analytics_mart
  
### 4. Workflow Orchestration with Kestra, Docker, and DLT (Python)
This section walks you through reproducing the orchestration pipeline powered by:   
- Kestra	Workflow orchestration – Triggers ingestion 
- Docker	Containerized Kestra and supporting services for easy setup and portability
- DLT (Python)	Incremental ingestion from API data source to GCS and from GCS to  BigQuery

⚠️ Note:  I created a Python virtual environment (venv) to isolate dependencies, especially for the ingestion scripts, ensuring compatibility across environments (VM, local machine, etc.); I installed all my Python packages and dependencies needed to build and run the ingestion scripts in this environment. However, creating a virtual environment is optional; you can proceed with the project without it. 

📌 Step-by-Step Instructions to Set Up Orchestration Pipeline
⚠️ If you’re not cloning the repository, you need to manually create the project structure and upload the required files directly to your VM.

1. Ensure docker has been installed; verify Docker is working: ``` docker --version```
2. Create or upload the required Python scripts and docker compose yml files into your home directory( /home/ input your specific user account on the VM / ) . This is important to enable reference file paths to be used in the Kestra UI when setting up our ingestion flows (.yaml files)
3. Start Kestra Using Docker from the same directory as docker-compose.yml run ``` docker compose up - d ```
4. Ensure your port 8080 has been forwarded as seen below and open your browser to [http://localhost:8080](http://localhost:8080/)
![Screenshot (67)](https://github.com/user-attachments/assets/57e6be3a-6124-48b7-9a26-4541b55377c8)
5. Once the Kestra UI opens in your browser, create the data pipelines by copying/editing the contents of my flow YAML files, ensuring your topology looks like the one below
   - Pipeline 1 (load_stats_canada_data): This pipeline loads data from our API source to the GCS bucket; I have also included an incremental load to the script and a Slack notification to help notify when jobs are completed successfully or fail. Here's a link to setting up Slack notifications for Kestra [Kestra Slack](https://youtu.be/wIsbBpw3yCM?si=UhowuCBSUm8rh4x8)

![Load To GCS Kestra Pipeline Flow](https://github.com/user-attachments/assets/b39a1dc4-6778-4edc-9e6a-ac4f92f9a7c2)

   - Pipeline 2 (load_statistic_canada_to_raw): This pipeline loads data from our GCS bucket into Big Query
     
 ![Load to Big Query Kestra Pipeline Flow](https://github.com/user-attachments/assets/de817eed-a9c0-41f2-a77b-dfd607cdd4fb)

6.⚠️ Note: I included triggers to run a cron job  to automate the pipelines and used KV store in Namespaces to store confidential credentials that are referenced in the flows; these videos will assist you in creating them and working with Kestra [Scheduling with Kestra](https://youtu.be/DoaZ5JWEkH0?si=uVw1GClALO39Ux28) [Setting up a pipeline in Kestra UI and using KV store for credentials](https://youtu.be/nKqjjLJ7YXs?si=Rm5g65nf3z9nv2BF)

7. Once Flows are created, execute them to run, if successful you should see the below and receive a Slack notification for the upload to GCS:
   ![Screenshot (69)](https://github.com/user-attachments/assets/91f198ef-33c6-4e97-967b-ccb0be98f22a)

   
### 5. Data Transformation with DBT 
DBT cloud was used for the data transformation stage in this project, refer to the DBT videos in the DataTalksClub DE Zoomcamp playlist to learn how to use DBT and deploy data models to production [DBT Video Tutorial](https://www.youtube.com/watch?v=gsKuETFJr54&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=6)

📌  Step-by-Step Instructions to  Set Up DBT Cloud
1. Create a free account if you haven't already done that in the prerequisite section.
2. Create a DBT Project
   - Select Big Query as your datawarehouse for your development connection
   -  Use the same service account credentials used for Python and Kestra.  DBT Cloud will request your project ID and dataset location (e.g., US or EU) and the service account JSON key. For the location input the region you used  to create your GCP resources, e.g. northamerica-northeast1
   -   Connect Your GitHub Repo (Optional if you're using version control); I recommend connecting your github repo to enable the development and deployment of models using branches and pull requests to the main branch.
   -   Watch this video on a guide to creating a DBT Project [DBT Project Setup Guide] ](https://youtu.be/J0XCDyKiU64?si=0o9P9nssRZNTtuou)
3. Recreate the dbt files structure in this repo, you can also watch these videos to guide you on developing dbt models and deployment[Creating DBT Models](https://youtu.be/ueVy2N54lyc?si=YxMCjwb2JTMr1CAZ)
4. Deploy dbt models [Deploy DBT Models to Prod](https://youtu.be/V2m5C0n8Gro?si=XKD5Mi4GUskW3Reh)
### 6. Data Visualization - Power BI

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
