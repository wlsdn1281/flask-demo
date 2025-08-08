#!/bin/bash
cd /home/ec2-user/flask-demo

# 이미지 URI 읽기
IMAGE_URI=$(cat /home/ec2-user/flask-demo/image_uri.txt)
echo "Deploying image: $IMAGE_URI"

# 기존 컨테이너 중지 및 제거
docker stop flask-demo 2>/dev/null || true
docker rm flask-demo 2>/dev/null || true

# ECR 로그인
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 905418139133.dkr.ecr.us-east-1.amazonaws.com

# 이미지 pull 및 실행
docker pull $IMAGE_URI
docker run -d --name flask-demo -p 5000:5000 --restart unless-stopped $IMAGE_URI

echo "Flask demo container started successfully"
