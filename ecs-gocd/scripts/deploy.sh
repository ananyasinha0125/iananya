#!/bin/bash
set -e
echo "AWS Access Key ID: $AWS_ACCESS_KEY_ID"
echo "AWS Secret Access Key: $AWS_SECRET_ACCESS_KEY"
echo "AWS Region: $AWS_DEFAULT_REGION"

STACK_NAME="ecs-test-stack"
TEMPLATE_FILE="./ecs-gocd/ecs-gocd/deploy/ecs-test-stack.yaml"
REGION="us-east-1"

# Parameter values (hardcoded or passed as env vars)
PARAMS="ParameterKey=VpcId,ParameterValue=${VpcId} \
ParameterKey=PublicSubnetIds,ParameterValue=\"${PublicSubnetIds}\" \
ParameterKey=PrivateSubnetIds,ParameterValue=\"${PrivateSubnetIds}\" \
ParameterKey=ClusterName,ParameterValue=${ClusterName} \
ParameterKey=ContainerImage,ParameterValue=${ContainerImage} \
ParameterKey=ContainerPort,ParameterValue=${ContainerPort} \
ParameterKey=InstanceType,ParameterValue=${InstanceType} \
ParameterKey=AmiId,ParameterValue=${AmiId} \
ParameterKey=DesiredCapacity,ParameterValue=${DesiredCapacity} \
ParameterKey=MaxSize,ParameterValue=${MaxSize} \
ParameterKey=MinSize,ParameterValue=${MinSize} \
ParameterKey=KeyName,ParameterValue=${KeyName}"

echo "Creating CloudFormation Stack: $STACK_NAME"

aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides $PARAMS \
  --region "$REGION"

echo "Deployment successfull!! :)"

