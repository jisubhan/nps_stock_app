from flask import Flask, jsonify
from flask_cors import CORS
from pykrx import stock
from datetime import datetime, timedelta
import pandas as pd
import requests
from bs4 import BeautifulSoup
import re

app = Flask(__name__)
CORS(app)  # Flutter 앱에서 접근 가능하도록

def get_recent_trading_day():
    """최근 거래일 찾기 (최대 10일 전까지)"""
    today = datetime.now()

    for i in range(10):
        target_date = today - timedelta(days=i)

        # 주말 건너뛰기
        if target_date.weekday() >= 5:  # 5=토요일, 6=일요일
            continue

        date_str = target_date.strftime('%Y%m%d')

        try:
            # 해당 날짜에 데이터가 있는지 테스트
            df = stock.get_market_net_purchases_of_equities_by_ticker(
                date_str, date_str, "ALL", "연기금"
            )

            if not df.empty:
                return date_str
        except:
            continue

    return None

def get_realtime_price(ticker):
    """네이버 금융에서 실시간 주가 정보 가져오기"""
    try:
        url = f'https://finance.naver.com/item/main.nhn?code={ticker}'
        headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        }

        response = requests.get(url, headers=headers, timeout=5)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')

        # 현재가 가져오기
        price_element = soup.select_one('.no_today .blind')
        if not price_element:
            return None, None

        current_price = int(price_element.text.replace(',', ''))

        # 등락률 가져오기 (전일 대비 %)
        change_rate = 0.0

        # no_exday 섹션에서 등락 방향과 퍼센트 찾기
        exday_section = soup.select_one('.no_exday')
        if exday_section:
            # 상승/하락 방향 확인
            is_up = exday_section.select_one('.no_up') is not None
            is_down = exday_section.select_one('.no_down') is not None

            # blind 스팬들 중 두 번째가 퍼센트 (첫 번째는 가격 변동액)
            blind_spans = exday_section.select('.blind')
            if len(blind_spans) >= 2:
                rate_text = blind_spans[1].text.strip().replace('%', '')
                try:
                    rate = float(rate_text)
                    # 상승이면 +, 하락이면 -
                    change_rate = rate if is_up else -rate if is_down else 0.0
                except ValueError:
                    change_rate = 0.0

        return current_price, change_rate

    except Exception as e:
        print(f'실시간 가격 조회 실패 ({ticker}): {e}')
        return None, None

@app.route('/api/nps/top5', methods=['GET'])
def get_nps_top5():
    """국민연금 순매수 Top5 종목 조회"""
    try:
        # 최근 거래일 찾기
        trading_day = get_recent_trading_day()

        if not trading_day:
            return jsonify({
                'error': '최근 거래일 데이터를 찾을 수 없습니다'
            }), 404

        # 연기금 순매수 데이터 조회
        df = stock.get_market_net_purchases_of_equities_by_ticker(
            trading_day, trading_day, "ALL", "연기금"
        )

        if df.empty:
            return jsonify({
                'error': '데이터가 없습니다'
            }), 404

        # 순매수거래대금 기준으로 정렬
        df = df.sort_values('순매수거래대금', ascending=False)

        # Top 5 추출
        top5 = df.head(5)

        # JSON 형식으로 변환
        result = []
        for ticker, row in top5.iterrows():
            # 종목명 가져오기
            try:
                stock_name = stock.get_market_ticker_name(ticker)
            except:
                stock_name = ticker

            # 실시간 현재가 및 등락률 가져오기 (네이버 금융)
            realtime_price, realtime_change = get_realtime_price(ticker)

            # 차트용 가격 히스토리 가져오기 (과거 데이터는 pykrx 사용)
            try:
                from_date = (datetime.strptime(trading_day, '%Y%m%d') - timedelta(days=7)).strftime('%Y%m%d')
                ohlcv = stock.get_market_ohlcv_by_date(from_date, trading_day, ticker)

                if not ohlcv.empty:
                    # 차트용 가격 히스토리 (최근 6일)
                    price_history = ohlcv['종가'].tail(6).tolist()

                    # 실시간 가격이 있으면 사용, 없으면 최근 종가 사용
                    if realtime_price:
                        current_price = float(realtime_price)
                        change_rate = realtime_change
                    else:
                        current_price = float(ohlcv['종가'].iloc[-1])
                        if len(ohlcv) >= 2:
                            prev_close = float(ohlcv['종가'].iloc[-2])
                            change_rate = ((current_price - prev_close) / prev_close) * 100
                        else:
                            change_rate = 0.0
                else:
                    current_price = float(realtime_price) if realtime_price else 0.0
                    change_rate = realtime_change if realtime_change else 0.0
                    price_history = []
            except Exception as e:
                print(f'가격 데이터 조회 오류 ({ticker}): {e}')
                current_price = float(realtime_price) if realtime_price else 0.0
                change_rate = realtime_change if realtime_change else 0.0
                price_history = []

            result.append({
                'name': stock_name,
                'code': ticker,
                'shares': int(row['순매수거래량']),
                'amount': float(row['순매수거래대금']),
                'current_price': current_price,
                'change_rate': change_rate,
                'price_history': price_history,
                'buy_volume': int(row['매수거래량']),
                'sell_volume': int(row['매도거래량']),
                'buy_amount': float(row['매수거래대금']),
                'sell_amount': float(row['매도거래대금']),
            })

        return jsonify({
            'date': trading_day,
            'stocks': result
        })

    except Exception as e:
        return jsonify({
            'error': str(e)
        }), 500

@app.route('/api/health', methods=['GET'])
def health_check():
    """서버 상태 확인"""
    return jsonify({
        'status': 'ok',
        'message': 'NPS Stock API Server is running'
    })

if __name__ == '__main__':
    import os
    port = int(os.environ.get('PORT', 5001))

    print('🚀 NPS Stock API Server starting...')
    print('📊 pykrx를 사용하여 국민연금 데이터를 제공합니다')
    print(f'🌐 Server: http://0.0.0.0:{port}')
    print(f'📡 API: http://0.0.0.0:{port}/api/nps/top5')
    app.run(host='0.0.0.0', port=port, debug=False)
