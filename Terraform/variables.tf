## GCP Project ID 
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}


## GCP Region 
variable "region" {
  description = "Region for GCP resources"
  type        = string
}


## Google Cloud Storage bucket name
variable "bucket_name" {
  description = "Globally unique name for the GCS bucket"
  type        = string
}


## Storage class for the bucket
variable "storage_class" {
  description = "GCS storage class (e.g., STANDARD, NEARLINE, COLDLINE)"
  type        = string
  default     = "STANDARD"
}

## Big Query dataset(schema) name for the raw table

variable "raw_dataset" {
  description = "Name of the BigQuery dataset for raw ingested data"
  type        = string
}


## Big Query dataset(schema) name for the cleaned data gotten from the raw table
variable "staging_dataset" {
  description = "Name of the BigQuery dataset for storing staging models done in dbt"
  type        = string
}



## Big Query dataset(schema) name for the cleaned and analytics ready data gotten from the raw table
variable "mart_dataset" {
  description = "Name of the BigQuery dataset for storing analytics marts models done in dbt"
  type        = string
}
