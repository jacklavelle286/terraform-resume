# Terraform Resume Infrastructure

This repository contains the Terraform code for deploying infrastructure to host a resume application. It includes all the necessary AWS resources and configurations to run the corresponding application code found in [resume-app-code](https://github.com/jacklavelle286/resume-app-code).


## Overview
This infrastructure project uses [Terraform](https://www.terraform.io/) to provision AWS resources (such as EC2, S3, or other services) to run and serve your resume application. It ensures a repeatable, version-controlled setup that is easy to manage and update. This includes everything necessary. 

---

## Architecture
High-level components may include:
- **Compute**: EC2 instances, AWS Fargate, or Lambda functions for hosting the resume application.
- **Storage**: S3 for static files or additional data storage.
- **Networking**: VPC, subnets, and security groups to isolate and secure components.
- **Load Balancing / Routing**: An Application Load Balancer or API Gateway for routing traffic.
- **Monitoring**: CloudWatch and other relevant AWS monitoring services.


