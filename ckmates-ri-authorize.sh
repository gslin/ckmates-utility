#!/bin/bash -e

# Usage:
# AWS_PROFILE=company-production ./ckmates-ri-authorize.sh

# Variables
IAM_POLICY_NAME="RI-Get-Info"
IAM_USER="Key-RI-Get-Info"

#
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Policy
aws iam create-policy --policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["ec2:DescribeReservedInstances","rds:DescribeReservedDBInstances","iam:GetAccountAuthorizationDetails","elasticache:DescribeReservedCacheNodes"],"Resource":["*"]}]}' --policy-name "${IAM_POLICY_NAME}" || true

# User
aws iam create-user --user-name "${IAM_USER}" || true
aws iam tag-user --tags "Key=Name,Value=RI-KEY" --user-name "${IAM_USER}" || true

# Policy + User
aws iam attach-user-policy --policy-arn "arn:aws:iam::${ACCOUNT_ID}:policy/${IAM_POLICY_NAME}" --user-name "${IAM_USER}" || true

# Access Key
aws iam create-access-key --user-name "${IAM_USER}"
