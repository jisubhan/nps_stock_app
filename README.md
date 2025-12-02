# 국민연금 주식 매수 TOP 5

국민연금이 매수한 상위 5개 종목을 실시간으로 확인할 수 있는 Flutter 모바일 애플리케이션입니다.

## 주요 기능

- 📊 국민연금 매수 상위 5개 종목 조회
- 💰 실시간 주가 정보 (네이버 금융 연동)
- 📈 전일 대비 등락률 표시
- 🔄 Pull-to-Refresh 기능
- 📱 Google AdMob 광고 통합
- 🎨 Material 3 디자인

## 기술 스택

### Frontend
- **Flutter** 3.x
- **google_mobile_ads** - AdMob 광고
- **http** - API 통신
- **fl_chart** - 차트 표시 (차후 확장)

### Backend
- **Python Flask** - REST API 서버
- **pykrx** - 한국거래소 데이터 조회
- **BeautifulSoup4** - 네이버 금융 웹 스크래핑
- **Flask-CORS** - CORS 처리

## 사전 요구사항

- Flutter SDK 3.0 이상
- Python 3.8 이상
- Android Studio / Xcode (모바일 개발용)
- 안드로이드 기기 또는 에뮬레이터 / iOS 시뮬레이터

## 설치 방법

### 1. 저장소 클론

```bash
git clone https://github.com/jisubhan/nps_stock_app.git
cd nps_stock_app
```

### 2. Flutter 의존성 설치

```bash
flutter pub get
```

### 3. Python 백엔드 설정

```bash
cd backend
pip install -r requirements.txt
```

## 실행 방법

### 1. 백엔드 서버 실행

```bash
cd backend
python3 app.py
```

서버가 `http://localhost:5001`에서 실행됩니다.

### 2. Flutter 앱 실행

#### macOS에서 실행
```bash
flutter run -d macos
```

#### Android 기기에서 실행
```bash
flutter devices  # 연결된 기기 확인
flutter run -d <device-id>
```

#### iOS 시뮬레이터에서 실행
```bash
flutter run -d "iPhone 15 Pro"
```

## 프로젝트 구조

```
nps_stock_app/
├── lib/
│   ├── main.dart                 # 앱 진입점
│   ├── models/
│   │   └── stock.dart           # 주식 데이터 모델
│   ├── screens/
│   │   └── home_screen.dart     # 메인 화면
│   ├── services/
│   │   └── nps_api_service.dart # API 서비스
│   └── widgets/
│       ├── stock_card.dart      # 주식 카드 위젯
│       └── banner_ad_widget.dart # 광고 위젯
├── backend/
│   ├── app.py                   # Flask 서버
│   └── requirements.txt         # Python 의존성
├── android/                     # Android 설정
├── ios/                         # iOS 설정
└── pubspec.yaml                 # Flutter 의존성
```

## API 엔드포인트

### GET `/api/top5-stocks`

국민연금 매수 상위 5개 종목 데이터를 반환합니다.

**응답 예시:**
```json
[
  {
    "rank": 1,
    "ticker": "207940",
    "name": "삼성바이오로직스",
    "shares": 1234567,
    "buy_amount": 1000000000,
    "current_price": 850000,
    "current_value": 1049481950000,
    "profit": 49481950000,
    "profit_rate": 4.95,
    "change_rate": -2.5,
    "price_history": [...]
  }
]
```

## Google AdMob 설정

현재 테스트 광고 ID가 설정되어 있습니다. 실제 배포 시 자신의 AdMob ID로 변경해야 합니다.

### Android 설정
`android/app/src/main/AndroidManifest.xml`의 AdMob App ID를 수정:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_APP_ID"/>
```

### iOS 설정
`ios/Runner/Info.plist`의 GADApplicationIdentifier를 수정:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-YOUR_APP_ID</string>
```

### 광고 Unit ID 변경
`lib/widgets/banner_ad_widget.dart`의 광고 Unit ID를 수정:
```dart
final String _adUnitId = Platform.isAndroid
    ? 'ca-app-pub-YOUR_APP_ID/YOUR_BANNER_ID' // Android
    : 'ca-app-pub-YOUR_APP_ID/YOUR_BANNER_ID'; // iOS
```

## 데이터 소스

- **국민연금 매수 데이터**: pykrx 라이브러리 (한국거래소 공식 데이터)
- **실시간 주가**: 네이버 금융 (웹 스크래핑)

## 주의사항

- 실시간 주가는 네이버 금융에서 스크래핑하므로, 과도한 요청 시 차단될 수 있습니다.
- Android 기기에서 실행 시, 백엔드 서버 URL을 기기가 접근 가능한 IP로 변경해야 합니다.
  - `lib/services/nps_api_service.dart`에서 `baseUrl`을 수정하세요.
- 테스트 AdMob ID는 개발 용도로만 사용하세요. 실제 배포 시 자신의 AdMob 계정으로 변경해야 합니다.

## 빌드

### Android APK 빌드
```bash
flutter build apk --release
```

### iOS 빌드
```bash
flutter build ios --release
```

## 라이선스

이 프로젝트는 개인 학습 및 포트폴리오 목적으로 제작되었습니다.

## 기여

버그 리포트나 기능 제안은 Issues에 등록해주세요.

## 개발자

Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
