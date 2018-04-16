#!/bin/bash

# basic info
export ORG=iakuh
export APP=hellowebapp
export ENV=dev

# source code info
export GIT_REPO=https://github.com/kayhu/hello-webapp.git
export GIT_BRANCH=master
export GIT_COMMIT=2

# docker related info
export DOCKER_ADDRESSES=localhost:2375,28080:8080,28000:8000
export DOCKER_REGISTRY=registry.cn-hangzhou.aliyuncs.com
export DOCKER_BASE_IMAGE=${DOCKER_REGISTRY}/base/tomcat:8.5.29-jre8-gradle2.14.1
export DOCKER_IMAGE=${DOCKER_REGISTRY}/${ORG}/${APP}-${ENV}:${GIT_COMMIT}
export DOCKER_FILE_CONTENT=
export DOCKER_LOG_VOLUME=D:/code/docker/volume/logs
export DOCKER_RUN_OPTIONS="-e JPDA_ADDRESS=8000 -e CFG_ADDR=10.18.19.29:2181 -e DR_CFG_ZOOKEEPER_ENV_URL=10.18.19.24:52181 -e DLMC_CFG_JOB_ENABLED=true -e CFG_FILES=conf/context.xml,bin/setenv.sh"
export DOCKER_RUN_COMMAND="catalina.sh jpda run"
export DOCKER_NO_CACHE=false
export DOCKER_REMOTE_HOST=false

export CfgLabelBaseNode=instances
export ProjectRecipientList=
