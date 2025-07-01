import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { verifyAuth } from '../utils/auth';
import { PointHistory } from '../utils/types';

export const createAvatarPurchase = onRequest({
  cors: true,
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
    const { avatarId, avatarUrl, avatarName, price } = req.body;

    if (!avatarId || !avatarUrl || !avatarName || !price) {
      res.status(400).json({ success: false, error: '필수 정보가 누락되었습니다.' });
      return;
    }

    const db = admin.firestore();
    const profileRef = db.collection('profile').doc(uid);
    const avatarRef = profileRef.collection('avatars').doc(avatarId);

    // 트랜잭션으로 포인트 차감 및 아바타 저장만 처리
    await db.runTransaction(async (transaction) => {
      const profileDoc = await transaction.get(profileRef);
      if (!profileDoc.exists) {
        throw new Error('프로필 정보를 찾을 수 없습니다.');
      }
      const profileData = profileDoc.data()!;
      const userPoint = profileData.point || 0;
      if (userPoint < price) {
        throw new Error('포인트가 부족합니다.');
      }

      // 이미 구매한 아바타인지 확인
      const avatarDoc = await transaction.get(avatarRef);
      if (avatarDoc.exists) {
        throw new Error('이미 구매한 아바타입니다.');
      }

      // 포인트 차감
      transaction.update(profileRef, { point: admin.firestore.FieldValue.increment(-price) });

      // 아바타 서브컬렉션에 저장
      transaction.set(avatarRef, {
        id: avatarId,
        imageUrl: avatarUrl,
        name: avatarName,
        price: price,
        purchased_at: admin.firestore.Timestamp.now(),
      });
    });

    // 트랜잭션 밖에서 포인트 내역 기록
    const pointHistoryRef = profileRef.collection('point_history').doc();
    const pointHistoryData: PointHistory = {
      id: pointHistoryRef.id,
      profile_uid: uid,
      action_type: '아바타구매',
      points_earned: -price,
      description: `아바타 "${avatarName}" 구매`,
      related_id: avatarId,
      created_at: admin.firestore.Timestamp.now(),
    };
    
    await pointHistoryRef.set(pointHistoryData);

    res.status(200).json({
      success: true,
      message: '아바타가 성공적으로 구매되었습니다.'
    });
  } catch (error: any) {
    console.error('아바타 구매 처리 중 오류:', error);
    res.status(500).json({ success: false, error: error.message || '아바타 구매 처리 중 오류가 발생했습니다.' });
  }
}); 