FROM python:3.9-slim

WORKDIR /app

# 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# CodeArtifact 설정을 위한 인자들
ARG CODEARTIFACT_AUTH_TOKEN
ARG CODEARTIFACT_DOMAIN
ARG CODEARTIFACT_REPOSITORY
ARG AWS_ACCOUNT_ID
ARG AWS_DEFAULT_REGION

# 패키지 설치
COPY requirements.txt .
RUN pip config set global.index-url https://aws:${CODEARTIFACT_AUTH_TOKEN}@${CODEARTIFACT_DOMAIN}-${AWS_ACCOUNT_ID}.d.codeartifact.${AWS_DEFAULT_REGION}.amazonaws.com/pypi/${CODEARTIFACT_REPOSITORY}/simple/ && \
    pip config set global.trusted-host ${CODEARTIFACT_DOMAIN}-${AWS_ACCOUNT_ID}.d.codeartifact.${AWS_DEFAULT_REGION}.amazonaws.com && \
    pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
