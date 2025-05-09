#!/bin/bash
set -e

export AWS_PROFILE=ananya 

STACK_NAME="ecs-test-stack"
TEMPLATE_FILE="./ecs-gocd/ecs-gocd/deploy/ecs-test-stack.yaml"
REGION="us-east-1"
PARAMETERS_FILE="./ecs-gocd/ecs-gocd/deploy/ecs-parameters.json"

echo "CloudFormation Stack: $STACK_NAME"

PARAMS=$(jq -r '.[] | "ParameterKey=\(.ParameterKey),ParameterValue=\(.ParameterValue)"' "$PARAMETERS_FILE" | tr '\n' ' ')

if [ -z "$PARAMS" ]; then
    echo "No parameters found in $PARAMETERS_FILE."
    exit 1
fi

# Deploy CloudFormation stack
aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides $PARAMS \
  --region "$REGION"

echo "Deployment successful!! :)"
