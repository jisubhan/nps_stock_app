# NPS Stock Backend Server

국민연금 주식 매수 데이터를 제공하는 Python Flask API 서버

## 설치

```bash
cd backend
pip install -r requirements.txt
```

## 실행

```bash
python app.py
```

서버가 `http://localhost:5000`에서 실행됩니다.

## API 엔드포인트

### 1. Health Check
```
GET /api/health
```

### 2. 국민연금 Top5 조회
```
GET /api/nps/top5
```

**응답 예시:**
```json
{
  "date": "20241122",
  "stocks": [
    {
      "name": "삼성전자",
      "code": "005930",
      "shares": 150000,
      "amount": 8500000000,
      "buy_volume": 200000,
      "sell_volume": 50000,
      "buy_amount": 10000000000,
      "sell_amount": 1500000000
    }
  ]
}
```

## 기술 스택

- Flask: 웹 프레임워크
- pykrx: 한국 주식 시장 데이터
- Flask-CORS: CORS 지원
