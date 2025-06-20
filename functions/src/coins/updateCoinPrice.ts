import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { CoinPrice, PriceHistory } from '../utils/types';
import { FIRESTORE_COLLECTION_COIN } from '../utils/constants';

// 한국시간을 Firebase Timestamp로 변환하는 함수
function getKoreanTimestamp(): admin.firestore.Timestamp {
  // asia-northeast3 리전에서 실행되므로 이미 한국시간이 적용되어 있음
  return admin.firestore.Timestamp.now();
}

// 24시간 이전 가격 히스토리 데이터 삭제 함수
async function cleanupOldPriceHistory(priceHistoryRef: admin.firestore.CollectionReference, seoulTime: Date): Promise<number> {
  const oneDayAgo = new Date(seoulTime.getTime() - 24 * 60 * 60 * 1000);
  const oneDayAgoTimestamp = admin.firestore.Timestamp.fromDate(oneDayAgo);
  
  const oldDataQuery = priceHistoryRef.where('timestamp', '<', oneDayAgoTimestamp);
  const oldDataSnapshot = await oldDataQuery.get();
  
  if (!oldDataSnapshot.empty) {
    const deletePromises = oldDataSnapshot.docs.map(doc => doc.ref.delete());
    await Promise.all(deletePromises);
    return oldDataSnapshot.docs.length;
  }
  
  return 0;
}

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

    // 24시간 거래량 기준으로 정렬하여 상위 10개만 선택
    coinPriceList.sort((a, b) => (b.volume_24h || 0) - (a.volume_24h || 0));
    const top10Coins = coinPriceList.slice(0, 10);

    console.log(`Processing top 10 coins by 24h volume: ${top10Coins.map(c => c.id).join(', ')}`);

    // 기존 코인 목록 가져오기
    const coinSnapshot = await db.collection(FIRESTORE_COLLECTION_COIN).get();
    const existingCoins = new Map();
    coinSnapshot.docs.forEach(doc => {
      existingCoins.set(doc.id, doc.data());
    });

    // 가격 업데이트
    let updatedCount = 0;
    let createdCount = 0;
    let deletedCount = 0;
    
    for (let i = 0; i < top10Coins.length; i++) {
      const coinPrice = top10Coins[i];
      const coinRef = db.collection(FIRESTORE_COLLECTION_COIN).doc(coinPrice.id);
      const priceHistoryRef = coinRef.collection('price_history');
      
      try {
        if (existingCoins.has(coinPrice.id)) {
          
          // 한국시간으로 Firebase Timestamp 생성
          const currentTimestamp = getKoreanTimestamp();
          
          await coinRef.update({
            current_price: coinPrice.price,
            current_volume_24h: coinPrice.volume_24h,
            last_updated: currentTimestamp,
            rank: i + 1, // 1부터 10까지의 랭크
          });
          
          // 한국시간으로 Firebase Timestamp 생성
          const currentTimeStr = currentTimestamp.toDate().toISOString().replace('T', ' ').substring(0, 19);
          
          // 서브컬렉션에 가격 히스토리 추가
          const priceHistory: PriceHistory = {
            price: coinPrice.price,
            volume_24h: coinPrice.volume_24h,
            timestamp: currentTimestamp,
          };
          
          await priceHistoryRef.doc(currentTimeStr).set(priceHistory);
          
          // 24시간 이전 데이터 삭제
          deletedCount += await cleanupOldPriceHistory(priceHistoryRef, currentTimestamp.toDate());
          
          updatedCount++;
          
        } else {
          // 새로운 코인인 경우: 메인 문서 생성 + 서브컬렉션 추가
          const currentTimestamp = getKoreanTimestamp();
          
          const newCoin = {
            id: coinPrice.id,
            name: coinPrice.id, // API에서 name 정보가 없으므로 id 사용
            symbol: coinPrice.id.toUpperCase(),
            rank: i + 1, // 1부터 10까지의 랭크
            is_active: true,
            current_price: coinPrice.price,
            current_volume_24h: coinPrice.volume_24h,
            last_updated: currentTimestamp,
          };
          
          await coinRef.set(newCoin);
          
          // 한국시간으로 Firebase Timestamp 생성
          const currentTimeStr = currentTimestamp.toDate().toISOString().replace('T', ' ').substring(0, 19);
          
          // 서브컬렉션에 가격 히스토리 추가
          const priceHistory: PriceHistory = {
            price: coinPrice.price,
            volume_24h: coinPrice.volume_24h,
            timestamp: currentTimestamp,
          };
          
          await priceHistoryRef.doc(currentTimeStr).set(priceHistory);
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
      deletedCount,
      totalProcessed: top10Coins.length
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
    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const db = admin.firestore();
    const result = await updateCoinPrices(db);

    res.status(200).json({
      success: true,
      message: `Updated ${result.updatedCount} coins, Created ${result.createdCount} new coins, Deleted ${result.deletedCount} old coins`,
      data: result
    });

  } catch (error) {
    console.error('Error in updateCoinPrice:', error);
    res.status(500).json({ success: false, error: 'Failed to update coin prices' });
  }
});

// 공통 함수 export (다른 파일에서 사용 가능)
export { updateCoinPrices }; 