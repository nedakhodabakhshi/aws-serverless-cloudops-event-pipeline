# Serverless CloudOps Event Pipeline

## Overview

This project demonstrates a **production-style, serverless, event-driven CloudOps pipeline** built entirely on AWS using Infrastructure as Code (CloudFormation).

The purpose of this project is to show how a real-world CloudOps system handles:
- Event ingestion
- Decoupling
- Retry logic
- Failure handling with DLQ
- Data persistence
- Observability

---

## Architecture

High-level event flow:

S3 → SQS → Lambda → DynamoDB
↳ Dead Letter Queue (DLQ)

yaml
Copy code

![Architecture Diagram](architecture/diagram.png)

---

## Why This Architecture?

This design follows real CloudOps and reliability best practices:

- Loose coupling via SQS
- Automatic retries
- Failure isolation using DLQ
- Fully serverless and scalable
- Clear observability using logs and data persistence
- Infrastructure managed with CloudFormation (IaC)

---

## AWS Services Used

- **Amazon S3** – Event source (file uploads)
- **Amazon SQS** – Message queue and buffer
- **Amazon SQS DLQ** – Captures failed messages
- **AWS Lambda** – Event processor
- **Amazon DynamoDB** – Stores processed records
- **Amazon CloudWatch** – Logs and monitoring
- **AWS CloudFormation** – Infrastructure as Code

---

## Project Structure

serverless-cloudops-event-pipeline/
├─ README.md
├─ .gitignore
├─ architecture/
│ └─ diagram.png
├─ cloudformation/
│ ├─ main.yaml
│ ├─ s3.yaml
│ ├─ sqs.yaml
│ ├─ lambda.yaml
│ └─ dynamodb.yaml
├─ lambda/
│ └─ processor.py
├─ sample-data/
│ ├─ test-log.json
│ └─ dlq-test.json
├─ scripts/
│ ├─ package.sh
│ ├─ deploy.sh
│ └─ delete.sh
└─ screenshots/

yaml
Copy code

---

## Deployment

### 1. Package Lambda code

```bash
./scripts/package.sh
This uploads CloudFormation templates and prepares the deployment artifacts.

2. Deploy the infrastructure
bash
Copy code
./scripts/deploy.sh
This command creates:

Root CloudFormation stack

Nested stacks for S3, SQS, Lambda, and DynamoDB

Testing the Pipeline
Happy Path Test
Upload sample-data/test-log.json to the S3 input bucket

Verify:

S3 triggers an event

Message appears in SQS

Lambda processes the message

Item is stored in DynamoDB

Failure & DLQ Test
Upload sample-data/dlq-test.json

Lambda is forced to fail

Message is retried automatically

After retries, the message moves to the DLQ

Verification Screenshots
All verification evidence is available in the screenshots/ folder.

Screenshot Order
01-cloudformation-stacks.png
All CloudFormation stacks in CREATE_COMPLETE

02-cloudformation-root-outputs.png
Root stack outputs (bucket name, queue URLs, Lambda name)

03-s3-input-bucket.png
S3 input bucket configuration

04-sqs-queue.png
SQS main queue and DLQ with redrive policy

05-sqs-main-queue
SQS main queue

06-lambda-function.png
Lambda function configuration

07-lambda-logs.png
CloudWatch logs showing Lambda execution

08-dynamodb-created.png
DynamoDB table created and active

09-dynamodb-items-Explore-created.png
DynamoDB items written by Lambda

10-package.png
Successful execution of package.sh

11-deploy.png
Successful execution of deploy.sh

Cleanup
To remove all resources created by this project:

bash
Copy code
./scripts/delete.sh
What This Project Demonstrates
Event-driven serverless architecture

CloudOps reliability patterns

Retry and DLQ handling

Infrastructure as Code using CloudFormation

Production-ready AWS design principles
