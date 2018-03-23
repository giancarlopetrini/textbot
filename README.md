# textbot [![Build Status](https://travis-ci.org/giancarlopetrini/textbot.svg?branch=master)](https://travis-ci.org/giancarlopetrini/textbot)
A bot using AWS Lex, Lambdas, and Twilio, deployed with Terraform

Eventual guide will be at -> https://giancarlopetrini.com

Currently, for testing:
1. `terraform init` with terraform.tf commented out (cleaner way to do this part to come) 
2. `terraform apply` 
3. uncomment terraform.tf 
4. `terraform init` 
5. `travis open` restart build in the UI 
6. `terraform apply` 