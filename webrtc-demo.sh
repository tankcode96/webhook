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

echo "开始执行构建"
docker build -t webrtc-demo:1.0 .

echo "停止旧容器并删除旧容器"
docker stop webrtc-demo-container
docker rm webrtc-demo-container

echo "启动新容器"
docker container run -p 80:80 --name webrtc-demo-container -d webrtc-demo:1.0
# docker container run -it -p 80:80 -p 443:443 --name webrtc-demo-container -d webrtc-demo:1.0 /bin/bash
# docker container run -p 80:80 -p 443:443 --name webrtc-demo-container --rm -d webrtc-demo:1.0

echo "开始删除旧镜像"
docker rmi -f $(docker images | grep "none" | awk '{print $3}')
