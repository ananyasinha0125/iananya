#!/bin/bash
set -x

STACK_NAME="ecs-app-stack"
REGION="us-east-1"
TEMPLATE_FILE="ecs-gocd/ecs-gocd/deploy/ecs-test-stack.yaml"

PARAM_FILE="ecs-gocd/ecs-gocd/deploy/ecs-parameters.json"

# Debug: Confirm file exists
if [[ ! -f "$PARAM_FILE" ]]; then
  echo "ERROR: Parameter file $PARAM_FILE does not exist"
  exit 1
fi

echo "=== Reading Parameters from $PARAM_FILE ==="
cat "$PARAM_FILE"

# Build parameter list
PARAMS_LIST=()
while IFS= read -r line; do
  PARAMS_LIST+=("$line")
done < <(jq -r '.[] | "ParameterKey=\(.ParameterKey),ParameterValue=\(.ParameterValue)"' "$PARAM_FILE")

# Debug output
echo "=== Final Parameter List ==="
for param in "${PARAMS_LIST[@]}"; do
  echo "$param"
done

echo "=== Deploying CloudFormation Stack ==="
aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "${PARAMS_LIST[@]}" \
  --region "$REGION"

echo "Deployment complete."
