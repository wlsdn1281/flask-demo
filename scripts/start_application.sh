#!/bin/bash
cd /home/ec2-user/flask-demo

# 이미지 URI 읽기
IMAGE_URI=$(cat /home/ec2-user/flask-demo/image_uri.txt)
echo "Deploying image: $IMAGE_URI"

# ECR 로그인 (AL2023에는 AWS CLI v2 기본 설치)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 905418139133.dkr.ecr.us-east-1.amazonaws.com

# 이미지 pull 및 실행
docker pull $IMAGE_URI
docker run -d --name flask-demo -p 5000:5000 --restart unless-stopped $IMAGE_URI
