#!/bin/bash
echo "Validating Flask demo service..."

# 컨테이너 상태 확인
for i in {1..30}; do
    if docker ps | grep -q flask-demo; then
        echo "Container is running, checking health..."
        break
    fi
    echo "Waiting for container to start... ($i/30)"
    sleep 2
done

# 서비스 응답 확인 (최대 60초 대기)
for i in {1..30}; do
    if curl -f -s http://localhost:5000 > /dev/null; then
        echo "✓ Flask demo service is healthy!"
        curl http://localhost:5000
        exit 0
    fi
    echo "Waiting for service to respond... ($i/30)"
    sleep 2
done

echo "✗ Service validation failed"
exit 1
