import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { verifyAuth } from '../utils/auth';
import { PointHistory } from '../utils/types';

export const createRandomArtworkPurchase = onRequest({
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

    const db = admin.firestore();
    const profileRef = db.collection('profile').doc(uid);
    const RANDOM_ARTWORK_PRICE = 500;

    // 트랜잭션으로 포인트 차감 및 랜덤 아트워크 저장 처리
    const result = await db.runTransaction(async (transaction) => {
      // 프로필 정보 확인
      const profileDoc = await transaction.get(profileRef);
      if (!profileDoc.exists) {
        throw new Error('프로필 정보를 찾을 수 없습니다.');
      }
      const profileData = profileDoc.data()!;
      const userPoint = profileData.point || 0;

      if (userPoint < RANDOM_ARTWORK_PRICE) {
        throw new Error('포인트가 부족합니다.');
      }

      // 사용자가 이미 보유한 아트워크 ID 목록 조회
      const userArtworksSnapshot = await profileRef.collection('artworks').get();
      const ownedArtworkIds = new Set(userArtworksSnapshot.docs.map(doc => doc.id));

      // 전체 아트워크 중에서 구매하지 않은 것들만 필터링
      const allArtworksSnapshot = await db.collection('artworks').get();
      const availableArtworks = allArtworksSnapshot.docs.filter(doc => !ownedArtworkIds.has(doc.id));

      if (availableArtworks.length === 0) {
        throw new Error('구매 가능한 아트워크가 없습니다.');
      }

      // 랜덤하게 아트워크 선택
      const randomIndex = Math.floor(Math.random() * availableArtworks.length);
      const selectedArtwork = availableArtworks[randomIndex];
      const artworkId = selectedArtwork.id;
      const artworkData = selectedArtwork.data();

      // 포인트 차감
      transaction.update(profileRef, { point: admin.firestore.FieldValue.increment(-RANDOM_ARTWORK_PRICE) });

      // 아트워크 서브컬렉션에 저장
      const artworkRef = profileRef.collection('artworks').doc(artworkId);
      transaction.set(artworkRef, {
        id: artworkId,
        ...artworkData,
        purchased_at: admin.firestore.Timestamp.now(),
        is_random_purchase: true, // 랜덤 구입 표시
      });

      return {
        artworkId,
        artworkData,
        price: RANDOM_ARTWORK_PRICE
      };
    });

    // 트랜잭션 밖에서 포인트 내역 기록
    const pointHistoryRef = profileRef.collection('point_history').doc();
    const artworkName = result.artworkData.prdct_nm_korean || '알 수 없는 작품';

    const pointHistoryData: PointHistory = {
      id: pointHistoryRef.id,
      profile_uid: uid,
      action_type: '아트워크구매',
      points_earned: -result.price,
      description: `랜덤 아트워크 "${artworkName}" 구매`,
      related_id: result.artworkId,
      created_at: admin.firestore.Timestamp.now(),
    };
    
    await pointHistoryRef.set(pointHistoryData);

    res.status(200).json({
      success: true,
      message: '랜덤 아트워크가 성공적으로 구매되었습니다.',
      data: {
        artworkId: result.artworkId,
        artworkName: artworkName,
        price: result.price
      }
    });
  } catch (error: any) {
    console.error('랜덤 아트워크 구매 처리 중 오류:', error);
    res.status(500).json({ success: false, error: error.message || '랜덤 아트워크 구매 처리 중 오류가 발생했습니다.' });
  }
}); 