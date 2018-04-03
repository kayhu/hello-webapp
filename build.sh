#!/bin/bash

# 是否新创建镜像
NewImage=false

buildImage() {
echo "building image ${ToImage}"
# 生成Dockerfile文件
#echo "FROM ${FromImage}" > Dockerfile
#cat >> Dockerfile << EOF
#${Dockerfile}
#EOF

# 开始构建镜像
docker build --rm --no-cache=${NoCache} -t ${ToImage} .
NewImage=true
}

if ! ${NoCache}
then
  # 检查当前版本的镜像是否已经存在， 镜像不存在则创建镜像
  echo "checking if image ${ToImage} exist"
  docker image inspect ${ToImage} >/dev/null 2>&1 && echo "image ${ToImage} exists" || buildImage
else
  # 创建镜像
  buildImage
fi

# 循环部署多实例
for AppAddress in ${AppAddresses}
do
  # 初始化变量
  # AppAddress      格式 宿主机地址:宿主机端口,外部端口:内部端口,外部端口:内部端口, e.g. localhost:2375,80:8080,443:8443
  # HostAddress     宿主机地址和宿主机端口, e.g. localhost:2375
  # HostParam       远程宿主机地址, e.g. -H localhost:2375
  # AppExpose       端口映射, e.g. -p 80:8080 -p 443:8443
  # AppIp           实例地址, e.g. localhost
  # AppPort         实例端口取第一个外部端口, e.g. 80
  # AppId           实例Id/容器名, e.g. IAKUH_DEV_HELLOWEBAPP_LOCALHOST_80
  # AppHostname     实例主机名, e.g. 80-localhost-hellowebapp-dev-iakuh
  # RunImage        版本镜像, e.g. registry.cn-hangzhou.aliyuncs.com/iakuh/hellowebapp-dev:master
  HostAddress=${AppAddress%%,*}
  if ${RemoteHost}
  then
    HostParam="-H ${HostAddress}"
  else
    HostParam=""
  fi
  AppExpose=`echo ,${AppAddress#*,} | sed 's/,/ -p /g'`
  AppIp=`echo ${HostAddress%%_*} | sed 's/:.*//'`
  AppPort=`echo ${AppAddress#*,} | sed 's/:.*//'`
  AppId=`echo ${AppOrg}_${AppEnv}_${AppName}_${AppIp}_${AppPort} | sed 's/[^a-zA-Z0-9_]//g' | tr "[:upper:]" "[:lower:]"`
  AppHostname=`echo ${AppPort}-${AppIp}-${AppName}-${AppEnv}-${AppOrg} | sed 's/[^a-zA-Z0-9-]//g'| tr "[:upper:]" "[:lower:]"`
  RunImage=${ToImage%:*}:${GitBranch##*/}

  JmxPort=$(( AppPort + 10 ))

  docker ${HostParam} tag ${ToImage} ${RunImage} # 新增镜像Tag
  LastImageId=`docker ${HostParam} inspect -f '{{.Image}}' ${AppId} || echo 0` # 保留当前实例的镜像Id
  docker ${HostParam} stop ${AppId} || echo # 停止当前实例
  docker ${HostParam} rm ${AppId} || echo # 删除当前实例

  sleep 3

  # 部署新实例
  docker ${HostParam} run -t -d --name=${AppId} --hostname=${AppHostname} \
  -e CFG_LABEL=${CfgLabelBaseNode}/${AppId%_*_*} \
  -v ${LogBasePath}/${AppId}:/volume_logs -e UMASK=0022 \
  ${AppExpose} ${RunOptions} ${RunImage} ${RunCmd}

  if ${NewImage}
  then
    echo "deleting unused image ${LastImageId}"
    docker ${HostParam} rmi ${LastImageId} || echo # 删除之前的镜像
  fi

done