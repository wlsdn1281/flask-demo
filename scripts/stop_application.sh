#!/bin/bash
echo "Stopping flask-demo container..."
docker stop flask-demo 2>/dev/null || true
docker rm flask-demo 2>/dev/null || true
echo "Flask demo container stopped"
