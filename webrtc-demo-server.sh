#!/bin/bash

WORK_PATH='/usr/projects/webrtc-demo-server'

cd $WORK_PATH

echo "清除可能存在的代码修改"
git reset --hard origin/master
git clean -f

echo "拉取最新代码"
git pull origin master

echo "开始下载依赖包"
npm install

echo "停止旧容器并删除旧容器"
docker stop webrtc-demo-server-container
docker rm webrtc-demo-server-container

echo "删除旧镜像"
docker rmi -f webrtc-demo-server:1.0

echo "开始构建新镜像"
docker build -t webrtc-demo-server:1.0 .

echo "启动新容器"
docker container run --name webrtc-demo-server-container -p 3010:3010 -v /usr/local/nginx/ssl:/etc/nginx/ssl/ -d webrtc-demo-server:1.0
