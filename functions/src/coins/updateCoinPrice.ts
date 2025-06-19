import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { CoinPrice, PriceHistory } from '../utils/types';
import { FIRESTORE_COLLECTION_COIN } from '../utils/constants';

// 공통 코인 가격 업데이트 함수
async function updateCoinPrices(db: admin.firestore.Firestore) {
  try {
    console.log('Starting coin price update...');
    
    // Coinpaprika API에서 가격 데이터 가져오기
    const response = await fetch('https://api.coinpaprika.com/v1/exchanges/binance/markets');
    
    if (!response.ok) {
      throw new Error('Failed to fetch coin data from Coinpaprika');
    }

    const result = await response.json();
    const coinPriceList: CoinPrice[] = [];

    // 가격 데이터 파싱
    for (const item of result) {
      const coinPrice: CoinPrice = {
        id: item.base_currency_id,
        price: item.quotes.USD.price,
        volume_24h: item.quotes.USD.volume_24h,
        last_updated: item.last_updated,
      };

      // 중복 제거
      if (!coinPriceList.find(cp => cp.id === coinPrice.id)) {
        coinPriceList.push(coinPrice);
      }
    }

    // 기존 코인 목록 가져오기
    const coinSnapshot = await db.collection(FIRESTORE_COLLECTION_COIN).get();
    const existingCoins = new Map();
    coinSnapshot.docs.forEach(doc => {
      existingCoins.set(doc.id, doc.data());
    });

    // 가격 업데이트
    let updatedCount = 0;
    let createdCount = 0;
    
    for (const coinPrice of coinPriceList) {
      const coinRef = db.collection(FIRESTORE_COLLECTION_COIN).doc(coinPrice.id);
      const priceHistoryRef = coinRef.collection('price_history');
      
      try {
        if (existingCoins.has(coinPrice.id)) {
          
          await coinRef.update({
            current_price: coinPrice.price,
            current_volume_24h: coinPrice.volume_24h,
            last_updated: coinPrice.last_updated,
          });
          
          // 한국시간으로 현재 시각 생성
          const now = new Date();
          const seoulTime = new Date(now.toLocaleString('en-US', { timeZone: 'Asia/Seoul' }));
          const currentTime = seoulTime.toISOString().replace('T', ' ').substring(0, 19);
          
          // 서브컬렉션에 가격 히스토리 추가
          const priceHistory: PriceHistory = {
            price: coinPrice.price,
            volume_24h: coinPrice.volume_24h,
            timestamp: currentTime,
          };
          
          await priceHistoryRef.doc(currentTime).set(priceHistory);
          updatedCount++;
          
        } else {
          // 새로운 코인인 경우: 메인 문서 생성 + 서브컬렉션 추가
          const newCoin = {
            id: coinPrice.id,
            name: coinPrice.id, // API에서 name 정보가 없으므로 id 사용
            symbol: coinPrice.id.toUpperCase(),
            rank: 0, // 기본값
            is_active: true,
            current_price: coinPrice.price,
            current_volume_24h: coinPrice.volume_24h,
            last_updated: coinPrice.last_updated,
          };
          
          await coinRef.set(newCoin);
          
          // 한국시간으로 현재 시각 생성
          const now = new Date();
          const seoulTime = new Date(now.toLocaleString('en-US', { timeZone: 'Asia/Seoul' }));
          const currentTime = seoulTime.toISOString().replace('T', ' ').substring(0, 19);
          
          // 서브컬렉션에 가격 히스토리 추가
          const priceHistory: PriceHistory = {
            price: coinPrice.price,
            volume_24h: coinPrice.volume_24h,
            timestamp: currentTime,
          };
          
          await priceHistoryRef.doc(currentTime).set(priceHistory);
          createdCount++;
        }
        
      } catch (error: any) {
        console.error(`Error processing coin ${coinPrice.id}:`, error);
      }
    }

    return {
      success: true,
      updatedCount,
      createdCount,
      totalProcessed: coinPriceList.length
    };

  } catch (error) {
    console.error('Error updating coin prices:', error);
    throw error;
  }
}

export const updateCoinPrice = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const db = admin.firestore();
    const result = await updateCoinPrices(db);

    res.status(200).json({
      success: true,
      message: `Updated ${result.updatedCount} coins, Created ${result.createdCount} new coins`,
      data: result
    });

  } catch (error) {
    console.error('Error in updateCoinPrice:', error);
    res.status(500).json({ success: false, error: 'Failed to update coin prices' });
  }
});

// 공통 함수 export (다른 파일에서 사용 가능)
export { updateCoinPrices }; 