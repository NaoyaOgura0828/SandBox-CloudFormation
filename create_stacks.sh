#!/bin/sh

if [ $# -ne 1 ]; then
    echo "      $0 <ENV_TYPE(dev|stg|prod)>"
    exit 1
elif [ "$1" != "dev" -a "$1" != "stg" -a "$1" != "prod" ]; then
    echo "      $0 <ENV_TYPE(dev|stg|prod)>"
    exit 1
fi

cd `dirname $0`

SYSTEM_NAME=SandBox
ENV_TYPE=$1

create_stack () {
    STACK_NAME=$1
    aws cloudformation create-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
    --cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}

    aws cloudformation wait stack-create-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}
}

# create_stack iam
# create_stack network
# create_stack sg
# create_stack ec2

exit 0