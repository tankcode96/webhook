#!/bin/bash

WORK_PATH='/usr/projects/webrtc-demo-server'

cd $WORK_PATH

echo "清除可能存在的代码修改"
git reset --hard origin/webrtc
git clean -f

echo "拉取最新代码"
git pull origin webrtc

echo "编译项目"
npm run build

echo "开始执行构建"
docker build -t webrtc-demo:1.0 .

echo "停止旧容器并删除旧容器"
docker stop webrtc-demo-server-container
docker rm webrtc-demo-server-container

echo "启动新容器"
docker container run -p 3000:3000 --name webrtc-demo-container -d webrtc-demo:1.0
