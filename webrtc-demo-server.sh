#!/bin/bash

WORK_PATH = '/usr/projects/webrtc-demo-server'

cd $WORK_PATH

echo "清除可能存在的代码修改"
git reset --hard origin/master
git clean -f

echo "拉取最新代码"
git pull origin master

echo "开始执行构建"
docker build -t webrtc-demo-server .

echo "停止旧容器并删除旧容器"
docker stop webrtc-demo-server-container
docker rm webrtc-demo-server-container

echo "启动新容器"
docker container run -p 3010:3010 --name webrtc-demo-server-container -d webrtc-demo-server
