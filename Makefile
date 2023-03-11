SHELL = /bin/bash
SHELLFLAGS = -ex

# Import configuration as environment variables
include ./configuration/defaults.conf

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

####################### Enable storage API and create a bucket #######################

create-artifacts-bucket: ## Create a google cloud storage bucket to store artifacts; also enables versioning
	gcloud services enable storage.googleapis.com
	# `-` ignores any failures from the command
	-gcloud storage buckets create gs://$(BACKEND_BUCKET_NAME) --project=$(GOOGLE_CLOUD_PROJECT_ID) --default-storage-class=$(BACKEND_BUCKET_STORAGE_CLASS) --location=$(GOOGLE_CLOUD_PROJECT_REGION) --uniform-bucket-level-access
	gcloud storage buckets update gs://$(BACKEND_BUCKET_NAME) --versioning

.PHONY: create-artifacts-bucket

####################### TERRAFORM #######################

init: ## Initialize terraform's backend and providers
	$(info [+] Running terraform init....)
	@terraform init \
		-backend-config="bucket=$(BACKEND_BUCKET_NAME)" \
		-backend-config="prefix=$(BACKEND_BUCKET_TERRAFORM_PREFIX)" \

plan: ## Run terraform pre-flight checks using terraform plan
	$(info [+] Running terraform plan....)
	@terraform plan \
		-var "project_id=$(GOOGLE_CLOUD_PROJECT_ID)" \
		-var "region=$(GOOGLE_CLOUD_PROJECT_REGION)" \
		-var "zone=$(GOOGLE_CLOUD_PROJECT_ZONE)" \
		-var "github_organisation=$(GITHUB_ORGANISATION)"

apply: ## Run terraform pre-flight checks using terraform plan
	$(info [+] Deploying Xplorers infra resources, standby...)
	@terraform apply -auto-approve \
		-var "project_id=$(GOOGLE_CLOUD_PROJECT_ID)" \
		-var "region=$(GOOGLE_CLOUD_PROJECT_REGION)" \
		-var "zone=$(GOOGLE_CLOUD_PROJECT_ZONE)" \
		-var "github_organisation=$(GITHUB_ORGANISATION)"

destroy: ## Delete all resources deployed via terraform
	$(info [+] Deleting all resources, standby...)
	@terraform destroy -auto-approve \
		-var "project_id=$(GOOGLE_CLOUD_PROJECT_ID)" \
		-var "region=$(GOOGLE_CLOUD_PROJECT_REGION)" \
		-var "zone=$(GOOGLE_CLOUD_PROJECT_ZONE)" \
		-var "github_organisation=$(GITHUB_ORGANISATION)"

.PHONY: init plan apply destroy
