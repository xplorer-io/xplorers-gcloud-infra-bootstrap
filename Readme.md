# XPLORERS GOOGLE CLOUD INFRASTRUCTURE SETUP

Terraform to bootstrap google cloud infrastructure for Xplorers applications. Enables service APIs, creates necessary resources like storage bucket and any permissions required by the applications.

## Prerequisites

### Required software
* [Google Cloud CLI](https://cloud.google.com/sdk/docs/install)
* [Terraform CLI](https://developer.hashicorp.com/terraform/cli)

### Login to Google Cloud via gcloud cli + setup application default credentials via Application Default Credentials (ADC)

Run [***gcloud init***](https://cloud.google.com/sdk/gcloud/reference/init) to authorize gcloud and other SDK tools to access Google Cloud using your user account credentials.

Run [***gcloud auth application-default login***](https://cloud.google.com/sdk/gcloud/reference/auth/login) to obtain access credentials for your user account via a web-based authorization flow. When this command completes successfully, it sets the active account in the current configuration to the account specified. If no configuration exists, it creates a configuration named default.

> ***Your gcloud credentials are not the same as the credentials you provide to ADC using the gcloud CLI.***

### Default configuration variables

The entrypoint for this repository is in the file `configuration/defaults.conf` which stores necessary environment variables used by the Makefile to orchestrate and apply the changes using Terraform. Change these values according to your project configuration,

* `BACKEND_BUCKET_NAME` - The name of google cloud storage bucket to create and use with Terraform
* `BACKEND_BUCKET_STORAGE_CLASS` - Storage class to use with google cloud storage bucket
* `BACKEND_BUCKET_TERRAFORM_PREFIX` - Bucket prefix to store terraform state information
* `GOOGLE_CLOUD_PROJECT_ID` - Google Cloud project ID to use
* `GOOGLE_CLOUD_PROJECT_REGION` - Google Cloud region to use
* `GOOGLE_CLOUD_PROJECT_ZONE` - Google Cloud zone to use

## Validating and applying configuration to Google Cloud

Because terraform's backend uses google cloud storage, we need to enable storage API and create a storage bucket first. Run make command `make create-artifacts-bucket` to enable the API and create the storage bucket.

Once the bucket has been created, run the following commands to validate and apply the configuration,

1. Run `make init` to initialize terraform's backend and providers.
    1. Google provider is setup.
    2. Google cloud storage is used to store terraform's configuration. State locking is also supported.

2. Run `make plan` to generate a plan for the changes to be applied to Google Cloud.

3. Once you have reviewed the changes to be applied, run `make apply` to apply changes to Google Cloud.

To delete all the resources created by Terraform, run `make destroy`.

## Features and services enabled in Google Cloud

* Enable the following Google Cloud Service APIs,
    * storage.googleapis.com
    * cloudfunctions.googleapis.com
* Create a storage bucket to store terraform state information.
