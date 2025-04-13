
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
       version = "6.29.0"
    }
  }

  required_version = ">= 1.3.0"
}



provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "stats_canada_bucket" {
  name          = var.bucket_name
  location      = var.region

storage_class = var.storage_class  # Standard, Nearline, Coldline, etc but we'll work with Standard
  uniform_bucket_level_access = true # Recommended for managing IAM access at the bucket level

  versioning {
    enabled = true  # Keeps versions of overwritten/deleted files
  }

  force_destroy = true  # Allows Terraform to delete the bucket even if it contains files
}

resource "google_bigquery_dataset" "raw_data" {
  dataset_id                  = var.raw_dataset
  location                    = var.region
  delete_contents_on_destroy = true
}

resource "google_bigquery_dataset" "staging_data" {
  dataset_id                  = var.staging_dataset
  location                    = var.region
  delete_contents_on_destroy = true
}

resource "google_bigquery_dataset" "analytics_mart" {
  dataset_id                  = var.mart_dataset
  location                    = var.region
  delete_contents_on_destroy = true
}


