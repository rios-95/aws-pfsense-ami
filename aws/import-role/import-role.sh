#!/bin/bash

# Use a specific profile from your AWS credentials file. If not required, use import-role-default.sh instead
PROFILE="${PROFILE}"

aws iam delete-role-policy --profile ${PROFILE} --role-name vmimport --policy-name vmimport
aws iam delete-role --profile ${PROFILE} --role-name vmimport

aws iam create-role --profile ${PROFILE} --role-name vmimport --assume-role-policy-document file://trust-policy.json
aws iam put-role-policy --profile ${PROFILE} --role-name vmimport --policy-name vmimport --policy-document file://role-policy.json