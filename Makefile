ENVIRONMENT ?= development
AWS_REGIONS ?= $(subst ., ,"eu-west-1")
REGION ?= eu-west-1

PROJECT_NAME := pnp-data-lake

S3_BUCKET := ${PROJECT_NAME}-deployment-lambda
AWS_PROFILE_NAME := ${PROJECT_NAME}-terraform

LDFLAGS := -ldflags "-X main.Version=${EXECUTION_ID}"
SUBDIRS := $(subst /,,$(subst src/,,$(dir $(wildcard src/*/main.go))))


aws_assume_role:
	chmod +x assume_role.sh
	./assume_role.sh ${CLIENT_ROLE_ARN} $(AWS_PROFILE_NAME)-${ENVIRONMENT}

terraform_plan:
	mkdir -p plan

	terraform init terraform/ && \
    	terraform workspace select $(ENVIRONMENT)-${REGION} terraform/ && \
    	terraform plan -var 'application_name=$(APPLICATION_NAME)' -var 'aws_region=${REGION}' -var-file=terraform/$(ENVIRONMENT).tfvars -out=plan/$(ENVIRONMENT)-${REGION}.plan terraform/

terraform_apply:
	terraform init terraform/ && \
    	terraform workspace select $(ENVIRONMENT)-${REGION} terraform/ && \
    	terraform apply plan/$(ENVIRONMENT)-${REGION}.plan

terraform_validate:
	# The Validate command sets the workspace to default, this is causing some string operations on the workspace to fail.
	# https://github.com/hashicorp/terraform/issues/24339
	#terraform init -backend=false terraform/
	#terraform validate terraform/
