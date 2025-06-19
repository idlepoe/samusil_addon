import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { Coin } from '../utils/types';
import { FIRESTORE_COLLECTION_COIN } from '../utils/constants';

export const getCoinList = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // GET, POST 요청 허용
    if (req.method !== 'GET' && req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    let withoutNoTrade = false;

    if (req.method === 'GET') {
      withoutNoTrade = req.query.withoutNoTrade === 'true';
    } else {
      const { withoutNoTrade: withoutNoTradeParam } = req.body;
      withoutNoTrade = withoutNoTradeParam || false;
    }

    const db = admin.firestore();
    const coinRef = db.collection(FIRESTORE_COLLECTION_COIN);
    const snapshot = await coinRef.get();

    const coinPromises = snapshot.docs.map(async doc => {
      const coinData = doc.data() as Coin;
      
      // 거래 내역이 없는 코인 제외 (current_price가 0이거나 없는 경우)
      if (withoutNoTrade && (!coinData.current_price || coinData.current_price === 0)) {
        return null;
      }

      // 랜덤 색상 추가
      coinData.color = Math.random() * 0xFFFFFF;

      // 가격 변동률 계산 (서브컬렉션에서 최근 데이터 가져오기)
      try {
        const priceHistoryRef = doc.ref.collection('price_history');
        const priceSnapshot = await priceHistoryRef.orderBy('timestamp', 'desc').limit(2).get();
        
        if (priceSnapshot.docs.length >= 2) {
          const latestPrice = priceSnapshot.docs[0].data().price;
          const previousPrice = priceSnapshot.docs[1].data().price;
          coinData.diffPercentage = ((latestPrice - previousPrice) / previousPrice) * 100;
        }
      } catch (error) {
        console.log(`Error getting price history for ${coinData.id}:`, error);
      }

      return coinData;
    });

    const coinResults = await Promise.all(coinPromises);
    const filteredCoins = coinResults.filter(coin => coin !== null) as Coin[];

    // 랭크순 정렬
    filteredCoins.sort((a, b) => a.rank - b.rank);

    res.status(200).json({
      success: true,
      data: filteredCoins
    });

  } catch (error) {
    console.error('Error getting coin list:', error);
    res.status(500).json({ success: false, error: 'Failed to get coin list' });
  }
}); 