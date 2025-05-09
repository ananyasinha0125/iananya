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

PARAMS_LIST=()
while IFS= read -r line; do
    PARAMS_LIST+=("$line")
done < <(jq -r '.[] | "ParameterKey=\(.ParameterKey),ParameterValue=\(.ParameterValue)"' "$PARAMETERS_FILE")

echo "=== Debug: Parameter List ==="
printf '%s\n' "${PARAMS_LIST[@]}"
echo

aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "${PARAMS_LIST[@]}" \
  --region "$REGION"

echo "Deployment successful!! :)"
