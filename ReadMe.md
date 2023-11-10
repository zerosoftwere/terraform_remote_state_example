# Terrafom Remote State Example

## About Project

Creates VPC and Subnet configuration in the [vpc](./vpc) project to used by the [instance](./instance) project to provision an EC2 insatnce

## How to use

This project uses the **AWS** and **S3** backend

- Setup your aws-cli configuration
- Create s3 bucket to hold the terraform state
- Replace `<s3 state bucket>` with the s3 bucket name created above
- Apply the [vpc](./vpc) project first
- Lastly apply the [instance](./instances) project