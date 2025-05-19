#!/bin/bash
set -x

export AWS_PROFILE=ecs-test
export AWS_DEFAULT_REGION=us-east-1

#Nginx
NGINX_IMAGE=$1
NGINX_TAG=$2
NGINX_STACK_NAME="nginx-ecs-stack"
NGINX_TEMPLATE_FILE="ecs-gocd/ecs-gocd/deploy/nginx-service.yaml"
NGINX_PARAM_FILE="ecs-gocd/ecs-gocd/deploy/nginx-parameters.json"

if [[ ! -f "$NGINX_PARAM_FILE" ]]; then
  echo "ERROR: Parameter file $NGINX_PARAM_FILE does not exist"
  exit 1
fi

NGINX_PARAMS_LIST=()
while IFS= read -r line; do
  NGINX_PARAMS_LIST+=("$line")
done < <(jq -r '.[] | "\(.ParameterKey)=\(.ParameterValue)"' "$NGINX_PARAM_FILE")

aws cloudformation deploy \
  --stack-name "$NGINX_STACK_NAME" \
  --template-file "$NGINX_TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "${NGINX_PARAMS_LIST[@]}" \
    ContainerImage="${NGINX_IMAGE}:${NGINX_TAG}" \
  --region "$AWS_DEFAULT_REGION"

#HTTPD
HTTPD_IMAGE=$3
HTTPD_TAG=$4
HTTPD_STACK_NAME="httpd-service-stack"
HTTPD_TEMPLATE_FILE="ecs-gocd/ecs-gocd/deploy/httpd-service.yaml"
HTTPD_PARAM_FILE="ecs-gocd/ecs-gocd/deploy/httpd-parameters.json"

if [[ ! -f "$HTTPD_PARAM_FILE" ]]; then
  echo "ERROR: Parameter file $HTTPD_PARAM_FILE does not exist"
  exit 1
fi

HTTPD_PARAMS_LIST=()
while IFS= read -r line; do
  HTTPD_PARAMS_LIST+=("$line")
done < <(jq -r '.[] | "\(.ParameterKey)=\(.ParameterValue)"' "$HTTPD_PARAM_FILE")

aws cloudformation deploy \
  --stack-name "$HTTPD_STACK_NAME" \
  --template-file "$HTTPD_TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "${HTTPD_PARAMS_LIST[@]}" \
    ContainerImage="${HTTPD_IMAGE}:${HTTPD_TAG}" \
  --region "$AWS_DEFAULT_REGION"

echo "Deployment complete."
