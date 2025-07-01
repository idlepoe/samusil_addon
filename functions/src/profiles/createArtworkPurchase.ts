import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { verifyAuth } from '../utils/auth';
import { PointHistory } from '../utils/types';

export const createArtworkPurchase = onRequest({
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
    const { artworkId } = req.body;

    if (!artworkId) {
      res.status(400).json({ success: false, error: '아트워크 ID가 필요합니다.' });
      return;
    }

    const db = admin.firestore();
    const profileRef = db.collection('profile').doc(uid);
    const artworkRef = profileRef.collection('artworks').doc(artworkId);
    const globalArtworkRef = db.collection('artworks').doc(artworkId);

    // 트랜잭션으로 포인트 차감 및 아트워크 저장 처리
    await db.runTransaction(async (transaction) => {
      // 프로필 정보 확인
      const profileDoc = await transaction.get(profileRef);
      if (!profileDoc.exists) {
        throw new Error('프로필 정보를 찾을 수 없습니다.');
      }
      const profileData = profileDoc.data()!;
      const userPoint = profileData.point || 0;

      // 글로벌 아트워크 정보 조회
      const globalArtworkDoc = await transaction.get(globalArtworkRef);
      if (!globalArtworkDoc.exists) {
        throw new Error('아트워크 정보를 찾을 수 없습니다.');
      }
      const artworkData = globalArtworkDoc.data()!;
      const price = artworkData.price || 0;

      if (userPoint < price) {
        throw new Error('포인트가 부족합니다.');
      }

      // 이미 구매한 아트워크인지 확인
      const userArtworkDoc = await transaction.get(artworkRef);
      if (userArtworkDoc.exists) {
        throw new Error('이미 구매한 아트워크입니다.');
      }

      // 포인트 차감
      transaction.update(profileRef, { point: admin.firestore.FieldValue.increment(-price) });

      // 아트워크 서브컬렉션에 저장
      transaction.set(artworkRef, {
        id: artworkId,
        ...artworkData,
        purchased_at: admin.firestore.Timestamp.now(),
      });
    });

    // 트랜잭션 밖에서 포인트 내역 기록
    const pointHistoryRef = profileRef.collection('point_history').doc();
    const globalArtworkDoc = await globalArtworkRef.get();
    const artworkData = globalArtworkDoc.data()!;
    const artworkName = artworkData.prdct_nm_korean || '알 수 없는 작품';
    const price = artworkData.price || 0;

    const pointHistoryData: PointHistory = {
      id: pointHistoryRef.id,
      profile_uid: uid,
      action_type: '아트워크구매',
      points_earned: -price,
      description: `아트워크 "${artworkName}" 구매`,
      related_id: artworkId,
      created_at: admin.firestore.Timestamp.now(),
    };
    
    await pointHistoryRef.set(pointHistoryData);

    res.status(200).json({
      success: true,
      message: '아트워크가 성공적으로 구매되었습니다.'
    });
  } catch (error: any) {
    console.error('아트워크 구매 처리 중 오류:', error);
    res.status(500).json({ success: false, error: error.message || '아트워크 구매 처리 중 오류가 발생했습니다.' });
  }
}); 