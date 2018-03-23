# textbot [![Build Status](https://travis-ci.org/giancarlopetrini/textbot.svg?branch=master)](https://travis-ci.org/giancarlopetrini/textbot)
A bot using AWS Lex, Lambdas, and Twilio, deployed with Terraform

Eventual guide will be at -> https://giancarlopetrini.com

Currently, for testing:
`terraform init` with terraform.tf commented out (cleaner way to do this part to come) 
`terraform apply` 
uncomment terraform.tf 
`terraform init` 
`travis open` restart build in the UI 
`terraform apply` 