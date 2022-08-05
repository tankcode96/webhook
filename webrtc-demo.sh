#!/bin/bash

WORK_PATH='/usr/projects/webrtc-demo'

cd $WORK_PATH

echo "清除可能存在的代码修改"
git reset --hard origin/webrtc
git clean -f

echo "拉取最新代码"
git pull origin webrtc

echo "开始下载依赖包"
npm install

echo "开始编译项目"
npm run build

echo "停止并删除旧容器"
docker stop webrtc-demo-container
docker rm webrtc-demo-container

echo "删除旧镜像"
docker rmi -f webrtc-demo:1.0

echo "开始构建新镜像"
docker build -t webrtc-demo:1.0 .

echo "启动新容器"
docker container run \
  --name webrtc-demo-container \
  -p 80:80 -p 443:443 \
  # -v /usr/local/nginx/logs:/var/log/nginx \
  # -v /usr/local/nginx/html:/usr/share/nginx/html \
  # -v /usr/local/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
  # -v /usr/local/nginx/conf.d:/etc/nginx/conf.d \
  -v /usr/local/nginx/ssl:/etc/nginx/ssl/ \
  -d webrtc-demo:1.0
# docker container run -it -p 80:80 -p 443:443 --name webrtc-demo-container -d webrtc-demo:1.0 /bin/bash
# docker container run -p 80:80 -p 443:443 --name webrtc-demo-container --rm -d webrtc-demo:1.0

# echo "开始删除旧镜像"
# docker rmi -f $(docker images | grep "none" | awk '{print $3}')
