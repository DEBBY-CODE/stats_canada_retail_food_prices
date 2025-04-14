# Project: Statistic Canada - Monthly Average Retail Products Prices 

## Quick Navigation
- [Overview](#Overview)
- [Project Goals](#Project-Goals)
- [Architecture](#Architecture)
- [Data Source](#Data-Source)
- [Technology Stack](#Technology-Stack)
- [Reproducing the Project](#Reproducing-the-Project-Detailed-Section) 
- [Analytics Report/Dashboard](#Analytics-ReportDashboard) 
## Overview
### 
Food and household essential product prices are among the most universally impactful economic indicators affecting individuals, families, communities, and nations. Whether you're a policymaker setting inflation targets, a retailer managing inventory, or a consumer budgeting for groceries, understanding food price trends is essential for making informed decisions.

Global food and product markets have experienced significant volatility in recent years due to inflation, climate change, geopolitical events, and supply chain disruptions. These changes ripple into household budgets, nutritional access, and political stability. In Canada, like in many other nations, tracking selected essential food and product price fluctuations helps:

- Households plan spending, savings, and consumption habits.

- Governments assess the cost of living and adjust support programs.

- Retailers and manufacturers forecast demand, plan pricing, and manage inventory.

- Researchers and economists analyze inflation, economic inequality, and long-term trends.

In short, household essential product prices are a daily reality and an economic signal.

This project analyzes Canada's average retail  prices for selected products by building an automated data pipeline that ingests public data, transforms it into clean analytical models, and visualizes key trends. This helps stakeholders understand what’s changing, why it matters, and who it impacts.

It answers key analytical questions such as:

- How have food and product prices changed in Canada and across provinces over time?

- Which  product categories or products have experienced the highest or lowest  price growth?

- How do prices compare nationally vs. regionally?

The project follows the modern data stack: extracting raw data from cloud storage, transforming it with DBT, and visualizing it using a BI tool, e.g. Power BI.
This was created as part of the DataTalksClub Data Engineering Certification requirements, demonstrating cloud infrastructure integration, data modeling, and business intelligence.

## Project Goals
Develop and build an analytical dashboard  with at least two tiles by the below deliverables:
- Select a dataset of interest (see Data Source Section)
- Create a batch pipeline for processing this dataset and putting it into a datalake 
- Create a batch pipeline for moving the data from the lake to a data warehouse
- Transform & Model the data in the data warehouse: prepare it for the dashboard
- Build a dashboard to visualize the data
  
## Architecture 

![DA](https://github.com/user-attachments/assets/9d228666-c0c0-4ff9-bd1d-f1a64b37bf4b)
The data architecture, as seen in the image above, reflects a complete end-to-end pipeline that enables automated ingestion, transformation, and visualization of Statistics Canada data. It consists of the following components:

- Data Ingestion: Source data are uploaded to Google Cloud Storage (GCS), serving as the data lake.

- Data Loading & Staging: Following the medallion architecture structure, files are incrementally batch-loaded into BigQuery, starting with the bronze layer, which captures the untransformed original data from our data source, then progressing through the silver layer, which holds the clean and standardized tables, and lastly the gold layer, in which the final analytics models reside, These include fact and dimension tables used for reporting and dashboarding.

- Data Transformation: DBT Cloud cleans, enriches, and models the data using a modular, layered approach.

- Data Visualization: The final DBT models (gold data tables) are visualized in Power BI, providing insights into national and regional food price trends for our project.
  
## Data Source
The data source can be viewed here: [Statistic Canada Monthly Average Retail Prices](https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1810024501). To reproduce the project, leverage the API resource by accessing it via [Statistic Canada Web Data Service](https://www.statcan.gc.ca/en/developers/wds/user-guide#a12-6). Use the getFullTableDownloadCSV option for the API URL section in the ingestion script.

📌Below are the key data fields/columns from the source:

- REF_DATE: Reference Period of the month data was uploaded for, usually the first day of the month as uploaded monthly e.g 2017-01-01 or 2025-02-01
-	GEO: Geography or region, e.g. Canada and its provinces e.g Alberta, Ontario, Quebec etc.
-	Products: Products such as food items and other essentials
-	UOM: Unit of Measure, usually in dollars
-	VALUE: Average Price per product

The rest below are not crucial for our analysis
-	DGUID
-	UOM_ID
-	SCALAR_FACTOR
-	SCALAR_ID
-	VECTOR
-	COORDINATE
-	STATUS
-	SYMBOL
-	TERMINATED
-	DECIMALS


## Technology Stack
- Google Cloud Storage (GCS): Object storage for source data, e.g. our CSV files extracted from our Stats Canada API

- Google BigQuery: Analytical data warehouse

- Terraform: Infrastructure as Code – used to provision GCP resources

- Docker: Containerization for running services like Kestra

- Python & DLT Package: Used in scripts to support ingestion and incremental data loads

- Kestra: Workflow orchestration (GCS → BigQuery etc.)
  
- Slack: To get success or failure notifications of our pipeline jobs in Kestra

- DBT Cloud: Data transformation & modeling

- Power BI: Data visualization
  
## Reproducing the Project (Detailed Section)
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
- Enable the following GCP APIs for the project: BigQuery API, Cloud Storage API, and Compute Engine API.
- Create a new GCP project via the Cloud Console and note down the Project ID, as you’ll need it throughout the setup process.
- Create a Google Cloud Service Account with the following roles: BigQuery Admin, Storage Admin, Compute Admin.
- Once the service account has been created, Create and Download the service account JSON key file in a secure location on your system. This will authenticate Google services and build the pipeline workflow with tools like Kestra, DBT, Power BI, etc.

📌OPTIONAL: Using a Google Cloud VM (Recommended Setup)

This project uses a Compute Engine VM manually created in Google Cloud to manage orchestration and transformations in a cloud environment.

🔁 You can also choose to run everything locally on your machine if you prefer. The VM is optional but useful for separating environments and running Dockerized services like Kestra.

Using a GCP VM, you can connect to it in two ways: Option 1 - SSH via gcloud CLI terminal  or Option 2 - VSCode Remote SSH Extension and install the required tools/resources, e.g., Terraform, docker, dbt, etc.

For a more comfortable development experience, use option 2 - VS Code with the Remote SSH extension; below are  detailed links to set things up correctly:
- How to create a GCP VM  [Setting Up A VM on GCP](https://youtu.be/18QgmuKq4zE?si=X2lsKFM_vLXxqb_0)
- Connecting to your remote VM instance [Two Ways to Add SSH Keys GCP VM](https://youtu.be/91MXOH0VV7U?si=nXWZaJNx_Czo5plZ).
- Additional Video to support  the first and second link [Setting Up A VM on GCP + SSH Access](https://www.youtube.com/watch?v=ae-CV2KfoN0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=16)

⚠️ Note: A newly created VM is essentially a bare system; it does not come pre-installed with the tools your project depends on.
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

1. Ensure terraform has been installed correctly; you can check for it by inputting this in your terminal to return the version of terraform you're using ``` terraform --version ```
2.  In your terminal, Create a new directory for Terraform and a folder called stats_canada_steup to nest our tf files for this project. Alternatively, you can clone this repository if you don't mind.
     ```mkdir -p ~/terraform/stats_canada_setup ```
3. Navigate into the terraform directory/folder  created ```cd  ~/terraform/stats_canada_setup```
4. Create the following files inside the directory/folder and copy the contents of the files in the repo :
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

⚠️ If you’re not cloning the repository, manually create the project structure and upload the required files directly to your VM.

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

6. Once Flows are created, execute them to run, if successful you should see the below and receive a Slack notification for the upload to GCS:
   ![Screenshot (69)](https://github.com/user-attachments/assets/91f198ef-33c6-4e97-967b-ccb0be98f22a)

⚠️ Note: I included triggers to run a monthly cron job  to automate the pipelines and used KV store in Namespaces to store confidential credentials that are referenced in the flows; these videos will assist you in creating them and working with Kestra [Scheduling with Kestra](https://youtu.be/DoaZ5JWEkH0?si=uVw1GClALO39Ux28) [Setting up a pipeline in Kestra UI and using KV store for credentials](https://youtu.be/nKqjjLJ7YXs?si=Rm5g65nf3z9nv2BF)

### 5. Data Transformation with DBT 
DBT cloud was used for the data transformation stage in this project, refer to the DBT videos in the DataTalksClub DE Zoomcamp playlist to learn how to use DBT and deploy data models to production [DBT Video Tutorial](https://www.youtube.com/watch?v=gsKuETFJr54&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=6)

📌  Step-by-Step Instructions to  Set Up DBT Cloud

1. Create a free account if you haven't already.
2. Create a DBT Project
   - Select Big Query as your datawarehouse for your development connection
   -  Use the same service account credentials used for Python and Kestra.  DBT Cloud will request your project ID, dataset location (e.g., US or EU), and the service account JSON key. For the location input, the region you used  to create your GCP resources, e.g. northamerica-northeast1
   -   Connect Your GitHub Repo (Optional if you're using version control); I recommend connecting your GitHub repo to enable the development and deployment of models using branches and pull requests to the main branch.
   -   Add the dbt folder as a project subdirectory
   -   Watch this video on a guide to creating a DBT Project [DBT Project Setup Guide] ](https://youtu.be/J0XCDyKiU64?si=0o9P9nssRZNTtuou)
3. Recreate the dbt files structure and content in the DBT folder of this repo, you can also watch these videos to guide you on developing dbt models and deployment[Creating DBT Models](https://youtu.be/ueVy2N54lyc?si=YxMCjwb2JTMr1CAZ)
   - Your DBT file structure should look like the below:
     ![Screenshot (73)](https://github.com/user-attachments/assets/2d7c8138-7d9e-4c47-83f1-701898aa8f94)

4. Once you've created and saved the models, compile and build them using dbt run and dbt build. You can test it with your dev environment, and once you're sure everything works, commit to pushing the request to your main GitHub branch. That way, when DBT prod JOBS are run, the correct data model goes into your production tables.
   - Your DAG should look like the following:
  ![Screenshot (74)](https://github.com/user-attachments/assets/148bd753-0b75-4f62-b4fa-be9093c8e9e3)

 - A successful build shows green, but to confirm that your data models are present, check your big query dataset, and you should have the below for both dev(testing phase) and prod
![Screenshot (77)](https://github.com/user-attachments/assets/e9d4eb12-e722-404d-b73c-a3bb5d0be9ff)

⚠️ Note that I created DBT Macros (clean_utils) for some transformations,  added a seed file called product_categories, which is gotten from the list of products in my table, and ensured the data models are incremental tables.

  
6. Navigate to the Deploy code section in the dbt cloud, create a production environment and set a schedule JOB to automate the refresh of data models. For this project, I put it to run monthly at a particular period.  [Deploy DBT Models to Prod](https://youtu.be/V2m5C0n8Gro?si=XKD5Mi4GUskW3Reh)
  
   - To test the production job, manually trigger the job, and you should have the following :
     ![Screenshot (78)](https://github.com/user-attachments/assets/cf934731-a811-4a16-9012-e4c580324529)
   
### 6. Data Visualization - Power BI

1. Download/Install Power BI Desktop
2. Create a connection to your Google Cloud account to access the datasets in Big Query. To do this, go to the get data section in Power BI and  Search for  Google Big Query.
3. Model the fact and dimension tables in the model view as seen below:
![Screenshot (75)](https://github.com/user-attachments/assets/5f186415-05cb-4a0f-862c-bab0d5eb57d1)
4. Start building the dashboard; it's important to note that certain calculated fields, like the Average Price Measure, MoM Price Growth Rate, Calendar Date Table, have been created.

## Analytics Report/Dashboard 
The live interactive dashboard  can be viewed here [Stats Canada Power BI Dashboard/Report](https://app.powerbi.com/view?r=eyJrIjoiODdkYTFlMjEtYWFiMi00YzZlLWIyODEtYzlhYjk2OWQwZmIxIiwidCI6IjA2ZjNhOGJlLThkYWUtNGM5MS05Y2RhLTliZTM3ZjhmYTgyNiJ9), it presents insights across three key pages :
1. National Overview

![Screenshot (82)](https://github.com/user-attachments/assets/9314f909-78a9-43c7-b9af-c7cde6782201)

2. Provincial
   
![Screenshot (81)](https://github.com/user-attachments/assets/b91706d2-df13-4aef-8b9a-b03e29748739)

4. Month-on-Month Price Growth Tracker
   
![Screenshot (80)](https://github.com/user-attachments/assets/050a3bcc-556b-4e48-aa66-47e7dce2cf58)

## Contact 
Have questions or feedback? Let’s connect!
[💼 LinkedIn – Deborah Alenkhe](https://www.linkedin.com/public-profile/settings?lipi=urn%3Ali%3Apage%3Ad_flagship3_profile_self_edit_contact-info%3Bv%2Bca91M6Tn2ZgulfjUpxXA%3D%3D)

