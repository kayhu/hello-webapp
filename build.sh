#!/bin/bash

# 是否创建过镜像
image_created=false

# 构建镜像
build_image() {
echo "Building image ${DOCKER_IMAGE}"
# 生成Dockerfile文件
#echo "FROM ${DOCKER_BASE_IMAGE}" > Dockerfile
#cat >> Dockerfile << EOF
#${DOCKER_FILE_CONTENT}
#EOF

docker build --rm --no-cache=${DOCKER_NO_CACHE} -t ${DOCKER_IMAGE} .
image_created=true
}

# 主函数
main() {

if ! ${DOCKER_NO_CACHE}
then
  # 检查当前版本的镜像是否已经存在， 镜像不存在则创建镜像
  echo "Checking image ${DOCKER_IMAGE} exist"
  docker image inspect ${DOCKER_IMAGE} >/dev/null 2>&1 && echo "Image ${DOCKER_IMAGE} exists" || build_image
else
  # 创建镜像
  build_image
fi

# 循环部署多实例
for app_addr in ${DOCKER_ADDRESSES}
do
  # 初始化变量
  # app_addr        格式 宿主机地址:宿主机端口,外部端口:内部端口,外部端口:内部端口, e.g. localhost:2375,80:8080,443:8443
  # host_addr       宿主机地址和宿主机端口, e.g. localhost:2375
  # host_param      远程宿主机地址, e.g. -H localhost:2375
  # app_expose      端口映射, e.g. -p 80:8080 -p 443:8443
  # app_ip          实例地址, e.g. localhost
  # app_port        实例端口取第一个外部端口, e.g. 80
  # app_id          实例Id/容器名, e.g. IAKUH_DEV_HELLOWEBAPP_LOCALHOST_80
  # app_hostname    实例主机名, e.g. 80-localhost-hellowebapp-dev-iakuh
  # run_image       版本镜像, e.g. registry.cn-hangzhou.aliyuncs.com/iakuh/hellowebapp-dev:master
  host_addr=${app_addr%%,*}
  if ${DOCKER_REMOTE_HOST}
  then
    host_param="-H ${host_addr}"
  else
    host_param=""
  fi
  app_expose=`echo ,${app_addr#*,} | sed 's/,/ -p /g'`
  app_ip=`echo ${host_addr%%_*} | sed 's/:.*//'`
  app_port=`echo ${app_addr#*,} | sed 's/:.*//'`
  app_id=`echo ${ORG}_${ENV}_${APP}_${app_ip}_${app_port} | sed 's/[^a-zA-Z0-9_]//g' | tr "[:upper:]" "[:lower:]"`
  app_hostname=`echo ${app_port}-${app_ip}-${APP}-${ENV}-${ORG} | sed 's/[^a-zA-Z0-9-]//g'| tr "[:upper:]" "[:lower:]"`
  run_image=${DOCKER_IMAGE%:*}:${GIT_BRANCH##*/}

  jmx_port=$(( app_port + 10 ))

  docker ${host_param} tag ${DOCKER_IMAGE} ${run_image} # 新增镜像Tag
  last_image_id=`docker ${host_param} inspect -f '{{.Image}}' ${app_id} || echo 0` # 保留当前实例的镜像Id
  echo "Removing container ${app_id}"
  docker ${host_param} stop ${app_id} || echo # 停止当前实例
  docker ${host_param} rm ${app_id} || echo # 删除当前实例

  sleep 3

  # 部署新实例
  echo "Deploying container ${app_id}"
  docker ${host_param} run -d --name=${app_id} --hostname=${app_hostname} \
  -v ${DOCKER_LOG_VOLUME}/${app_id}:/usr/local/apache-tomcat-8.5.29/logs \
  ${app_expose} ${DOCKER_RUN_OPTIONS} ${run_image} ${DOCKER_RUN_COMMAND}

  if ${image_created}
  then
    echo "Removing image ${last_image_id}"
    docker ${host_param} rmi ${last_image_id} || echo # 删除之前的镜像
  fi

done
}

# 主函数入口
main