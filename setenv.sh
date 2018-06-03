#!/bin/bash

# basic info
export ORG=iakuh
export APP=hello-webapp
export ENV=dev

# source code info
export GIT_REPO=https://github.com/kayhu/hello-webapp.git
export GIT_BRANCH=master
export GIT_COMMIT=commit-id

# docker related info
export DOCKER_ADDRESSES=localhost:2375,28080:8080,28000:8000
export DOCKER_REGISTRY=registry.cn-hangzhou.aliyuncs.com
#export DOCKER_REGISTRY=harbor.dev.chinacsci.com
export DOCKER_BASE_IMAGE=${DOCKER_REGISTRY}/iakuh/base:jdk8-tomcat8-gradle2.14.1
export DOCKER_IMAGE=${DOCKER_REGISTRY}/${ORG}/${APP}-${ENV}
export DOCKER_VERSIONED_IMAGE=${DOCKER_IMAGE}:${GIT_COMMIT}
export DOCKER_TAGGED_IMAGE=${DOCKER_IMAGE}:${GIT_BRANCH}
export DOCKER_FILE_CONTENT='
RUN mkdir -p workspace

COPY . workspace/

RUN gradle clean war -p workspace/ && \
    rm -rf $CATALINA_HOME/webapps/* && mkdir $CATALINA_HOME/webapps/ROOT && \
    unzip -o workspace/build/libs/hello-webapp.war -d $CATALINA_HOME/webapps/ROOT/ && \
    rm -rf workspace/

RUN sed -i "7,18d" $CATALINA_HOME/conf/context.xml
'
export DOCKER_LOG_VOLUME_OUTER=D:/code/docker/volume/logs
export DOCKER_LOG_VOLUME_INNER=/usr/local/apache-tomcat-8.5.31/logs
export DOCKER_RUN_OPTIONS="-e JPDA_ADDRESS=8000"
export DOCKER_RUN_COMMAND="catalina.sh run"
export DOCKER_NO_CACHE=false
export DOCKER_REMOTE_HOST=false