# 백엔드 서버 배포 가이드

## Railway 배포 방법 (무료, 추천)

### 1. Railway 계정 생성
1. https://railway.app 접속
2. GitHub 계정으로 로그인
3. 무료 플랜 선택 (월 $5 크레딧 제공)

### 2. 새 프로젝트 생성
```bash
# Railway CLI 설치 (선택사항)
npm install -g @railway/cli

# 또는 웹 인터페이스 사용
```

### 3. GitHub 저장소와 연결
1. Railway 대시보드에서 "New Project" 클릭
2. "Deploy from GitHub repo" 선택
3. `nps_stock_app` 저장소 선택
4. Root Directory를 `/backend`로 설정

### 4. 배포 확인
- 배포가 자동으로 시작됩니다
- 약 2-3분 후 완료
- 배포 URL 확인 (예: `https://your-app-name.up.railway.app`)

### 5. Flutter 앱 URL 업데이트

#### lib/config/api_config.dart 파일 수정:
```dart
static const String _productionUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://YOUR-APP-NAME.up.railway.app',  // 여기에 Railway URL 입력
);
```

### 6. 프로덕션 빌드
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 다른 배포 옵션

### Render (무료)
1. https://render.com 접속
2. "New Web Service" 생성
3. GitHub 저장소 연결
4. Root Directory: `backend`
5. Build Command: `pip install -r requirements.txt`
6. Start Command: `gunicorn app:app`

### Heroku (유료)
```bash
heroku login
cd backend
heroku create your-app-name
git push heroku main
```

## 배포 테스트

### 헬스 체크
```bash
curl https://your-app-name.up.railway.app/api/health
```

### API 테스트
```bash
curl https://your-app-name.up.railway.app/api/nps/top5
```

## 환경 변수 설정 (Railway)

Railway 대시보드에서 환경 변수 추가 가능:
- `PORT`: 자동 설정됨 (변경 불필요)
- 추가 환경 변수가 필요한 경우 Variables 탭에서 설정

## 문제 해결

### 배포 실패 시
1. Railway 로그 확인
2. requirements.txt 의존성 확인
3. Python 버전 확인 (runtime.txt)

### CORS 오류 시
- Flask-CORS가 올바르게 설정되어 있는지 확인
- 모든 origin 허용 중 (`CORS(app)`)

### 네이버 크롤링 실패 시
- 서버 IP가 차단되었을 가능성
- User-Agent 헤더 확인
- 요청 빈도 조정 필요

## 비용 예상

### Railway (무료 플랜)
- 월 $5 크레딧
- 500 실행 시간
- 소규모 앱에 충분

### Render (무료 플랜)
- 완전 무료
- 15분 비활성 후 sleep
- 첫 요청 시 느림

## 모니터링

### Railway
- 대시보드에서 실시간 로그 확인
- CPU/메모리 사용량 모니터링

### 로그 확인
```bash
# Railway CLI
railway logs

# 또는 웹 대시보드에서 Deployments > Logs
```

## 자동 배포 (CI/CD)

GitHub에 push하면 자동으로 Railway에 배포됨:
```bash
git add .
git commit -m "Update backend"
git push origin main
```

## 주의사항

1. **네이버 크롤링 법적 검토 필요**
   - 서비스 약관 확인
   - 과도한 요청 금지

2. **Rate Limiting 권장**
   - API 요청 빈도 제한
   - 캐싱 구현 고려

3. **에러 로깅**
   - Sentry 등 에러 추적 도구 사용 권장

4. **보안**
   - HTTPS 사용 (Railway 자동 제공)
   - API 키 관리 (환경 변수 사용)

## 다음 단계

1. ✅ 백엔드 배포 완료
2. ⬜ Flutter 앱 URL 업데이트
3. ⬜ 프로덕션 빌드 및 테스트
4. ⬜ 앱 스토어 제출 준비
