#!/bin/bash

export DOCKER_REGISTRY=registry.cn-hangzhou.aliyuncs.com
export ProjectRecipientList=
export AppOrg=iakuh
export AppEnv=dev
export AppName=hellowebapp
export AppAddresses=localhost:2375,80:8080,443:8443
export GitRepo=https://github.com/kayhu/hello-webapp.git
export GitBranch=master
export GIT_COMMIT=2
export FromImage=${DOCKER_REGISTRY}/base/tomcat:8.5.29-jre8-gradle2.14.1
export Dockerfile=
export ToImage=${DOCKER_REGISTRY}/${AppOrg}/${AppName}-${AppEnv}:${GIT_COMMIT}
export CfgLabelBaseNode=instances
export LogBasePath=D:/code/docker/volume/logs
export RunOptions=
export RunCmd=
export NoCache=false
export RemoteHost=false