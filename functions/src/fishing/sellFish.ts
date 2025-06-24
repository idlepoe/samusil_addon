import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { CloudFunctionResponse, FishInventory, SellFishRequest } from '../utils/types';
import { awardPointsForAction } from '../utils/pointService';
import { verifyAuth } from '../utils/auth';

const db = admin.firestore();

/**
 * 물고기 판매 처리
 */
export const sellFish = onRequest({
  cors: true,
  region: 'asia-northeast3',
}, async (req, res) => {
  try {
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }
    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    
    const { fishId, fishName, sellCount, pointPerFish } = req.body as SellFishRequest;

    // 입력값 검증
    if (!fishId || !fishName || !sellCount || sellCount <= 0 || !pointPerFish || pointPerFish <= 0) {
      res.status(400).json({ success: false, error: '잘못된 판매 정보입니다.' });
      return;
    }

    const profileRef = db.collection('profile').doc(uid);
    const fishInventoryRef = profileRef.collection('fish_inventory').doc(fishId);

    const result = await db.runTransaction(async (transaction) => {
      // 현재 물고기 보유량 확인
      const fishDoc = await transaction.get(fishInventoryRef);
      
      if (!fishDoc.exists) {
        throw new Error('보유하지 않은 물고기입니다.');
      }

      const fishData = fishDoc.data() as FishInventory;
      
      // 판매하려는 수량이 보유량보다 많은지 확인
      if (fishData.currentCount < sellCount) {
        throw new Error(`보유량(${fishData.currentCount}마리)보다 많이 판매할 수 없습니다.`);
      }

      // 총 획득 포인트 계산
      const totalPoints = sellCount * pointPerFish;

      // 물고기 보유량 업데이트
      const updatedFishData: Partial<FishInventory> = {
        currentCount: fishData.currentCount - sellCount,
      };

      transaction.update(fishInventoryRef, updatedFishData);

      return {
        totalPoints,
        remainingCount: updatedFishData.currentCount!,
      };
    });

    // 포인트 지급 (트랜잭션 외부에서 처리)
    const newPoints = await awardPointsForAction(
      uid,
      '물고기판매',
      result.totalPoints,
      `${fishName} ${sellCount}마리 판매`,
      fishId
    );

    const response: CloudFunctionResponse = {
      success: true,
      message: `${fishName} ${sellCount}마리를 판매하여 ${result.totalPoints}포인트를 획득했습니다.`,
      data: {
        soldCount: sellCount,
        earnedPoints: result.totalPoints,
        remainingCount: result.remainingCount,
        totalPoints: newPoints,
      },
    };

    res.status(200).json(response);

  } catch (error: any) {
    console.error('물고기 판매 중 오류 발생:', error);
    
    const response: CloudFunctionResponse = {
      success: false,
      message: error.message || '물고기 판매에 실패했습니다.',
    };

    res.status(500).json(response);
  }
}); 