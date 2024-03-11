#!/bin/bash
# Execute this script with bash

# Uncomment if you need to clean previous roles
aws iam delete-role-policy --role-name vmimport --policy-name vmimport
aws iam delete-role --role-name vmimport

aws iam create-role --role-name vmimport --assume-role-policy-document file://trust-policy.json
aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document file://role-policy.json