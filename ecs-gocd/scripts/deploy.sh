#!/bin/bash
set -e
echo "AWS Access Key ID: $AWS_ACCESS_KEY_ID"
echo "AWS Secret Access Key: $AWS_SECRET_ACCESS_KEY"
echo "AWS Region: $AWS_DEFAULT_REGION"

STACK_NAME="ecs-test-stack"
TEMPLATE_FILE="./ecs-gocd/ecs-gocd/deploy/ecs-test-stack.yaml"
REGION="us-east-1"
PARAMETERS_FILE="./ecs-gocd/ecs-gocd/deploy/ecs-parameters.json"

echo "Creating CloudFormation Stack: $STACK_NAME"

PARAMS=$(jq -r '.[] | "ParameterKey=\(.ParameterKey),ParameterValue=\(.ParameterValue)"' "$PARAMETERS_FILE" | tr '\n' ' ')

aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides $PARAMS \
  --region "$REGION"

echo "Deployment successfull!! :)"

