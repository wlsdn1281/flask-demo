# Flask Demo - CI/CD with CodePipeline

Flask 애플리케이션을 CodePipeline → CodeBuild → CodeDeploy → ASG로 자동 배포하는 프로젝트

## 아키텍처

```
GitHub → CodePipeline → CodeBuild → ECR + S3 → CodeDeploy → ASG (EC2)
```
[pip.conf](pip.conf)
## 주요 구성 요소

### 1. 애플리케이션
- **Flask 웹 애플리케이션**: Python 기반 간단한 웹 서비스
- **Docker 컨테이너화**: ECR에 이미지 저장
- **CodeArtifact**: Python 패키지 의존성 관리

### 2. CI/CD 파이프라인
- **buildspec.yml**: CodeBuild에서 Docker 이미지 빌드 및 ECR 푸시
- **appspec.yml**: CodeDeploy 배포 명세
- **배포 스크립트**: EC2에서 Docker 컨테이너 관리

### 3. 배포 프로세스
1. **CodeBuild**: Docker 이미지 빌드 → ECR 푸시 → 배포 아티팩트 생성
2. **CodeDeploy**: ASG의 EC2 인스턴스에 순차 배포
3. **EC2**: ECR에서 이미지 pull → 컨테이너 실행

## 파일 구조

```
├── app/                    # Flask 애플리케이션
├── scripts/               # CodeDeploy 배포 스크립트
│   ├── before_install.sh  # 배포 전 정리
│   ├── start_application.sh # 애플리케이션 시작
│   ├── stop_application.sh  # 애플리케이션 중지
│   └── validate_service.sh  # 서비스 검증
├── buildspec.yml          # CodeBuild 빌드 명세
├── appspec.yml           # CodeDeploy 배포 명세
├── Dockerfile            # Docker 이미지 빌드
└── requirements.txt      # Python 의존성
```

## 환경 변수

### CodeBuild 필수 환경 변수
- `AWS_ACCOUNT_ID`: AWS 계정 ID
- `AWS_DEFAULT_REGION`: AWS 리전
- `IMAGE_REPO_NAME`: ECR 리포지토리 이름
- `IMAGE_TAG`: Docker 이미지 태그
- `CODEARTIFACT_DOMAIN`: CodeArtifact 도메인
- `CODEARTIFACT_REPOSITORY`: CodeArtifact 리포지토리

## 배포 단계

1. **ApplicationStop**: 기존 컨테이너 중지
2. **BeforeInstall**: 환경 정리
3. **ApplicationStart**: ECR에서 이미지 pull 및 컨테이너 실행
4. **ValidateService**: 서비스 상태 확인 (포트 5000)

## 사용법

1. CodePipeline에서 GitHub 소스 연결
2. CodeBuild 프로젝트에 환경 변수 설정
3. CodeDeploy 애플리케이션 및 배포 그룹 생성 (ASG 연결)
4. 코드 푸시 시 자동 배포 실행
