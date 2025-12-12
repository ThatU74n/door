#!/bin/bash

terraform init
terraform apply -var-file=example.tfvars -auto-approve
