#!/bin/bash
set -e

export AWS_PROFILE=ecs

STACK_NAME="ecs-test-stack"
TEMPLATE_FILE="./ecs-gocd/ecs-gocd/deploy/ecs-test-stack.yaml"
REGION="us-east-1"
PARAMETERS_FILE="./ecs-gocd/ecs-gocd/deploy/ecs-parameters.json"

echo "=== Debug: Working Directory ==="
pwd
echo

echo "=== Debug: List deploy directory ==="
ls -l "$(dirname "$PARAMETERS_FILE")"
echo

echo "=== Debug: Contents of parameters file ==="
if [[ -f "$PARAMETERS_FILE" ]]; then
    cat "$PARAMETERS_FILE"
else
    echo "ERROR: Parameters file not found at $PARAMETERS_FILE"
    exit 1
fi

# Now parse the parameters
PARAMS=$(jq -r '.[] | "ParameterKey=\(.ParameterKey),ParameterValue=\(.ParameterValue)" ' "$PARAMETERS_FILE" | tr '\n' ' ')

echo "=== Debug: Parsed PARAMS ==="
echo "$PARAMS"
echo

if [ -z "$PARAMS" ]; then
    echo "No parameters found in $PARAMETERS_FILE."
    exit 1
fi

# Deploy using CloudFormation
echo "=== Debug: Deploying CloudFormation Stack ==="
eval aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides $PARAMS \
  --region "$REGION"

echo "Deployment successful!! :)"
