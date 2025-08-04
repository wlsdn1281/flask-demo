#!/bin/bash

# ECR 로그인
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

# 이미지 URI 읽기
IMAGE_URI=$(cat /home/ec2-user/flask-demo/image_uri.txt)

# 이미지 pull 및 실행
docker pull $IMAGE_URI
docker run -d --name flask-demo -p 5000:5000 $IMAGE_URI
