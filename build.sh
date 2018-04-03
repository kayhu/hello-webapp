#!/bin/bash

buildImage() {
echo 'building image'
# 生成Dockerfile文件
echo "FROM ${FromImage}" > Dockerfile
cat >> Dockerfile << EOF
${Dockerfile}
EOF

# 开始构建镜像
docker build --rm --no-cache=${NoCache} -t ${ToImage} .
}

if ! ${NoCache}
then
  # 检查当前版本的镜像是否已经存在， 镜像不存在则创建镜像
  echo 'checking if image exist'
  docker images | grep ${ToImage} && echo 'Image' ${ToImage} 'already exist' || buildImage
else
  # 创建镜像
  buildImage
fi
