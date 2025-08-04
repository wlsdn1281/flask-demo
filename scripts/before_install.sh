#!/bin/bash
cd /home/ec2-user/flask-demo

# 기존 컨테이너 정리
docker stop flask-demo 2>/dev/null || true
docker rm flask-demo 2>/dev/null || true

# 사용하지 않는 이미지 정리
docker image prune -f
