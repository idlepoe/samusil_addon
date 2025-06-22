import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { verifyAuth } from '../utils/auth';

export const getWish = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // GET 요청만 허용
    if (req.method !== 'GET') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    await verifyAuth(req);

    const db = admin.firestore();

    // Wish 컬렉션에서 최신순으로 조회
    const wishSnapshot = await db
      .collection('wish')
      .orderBy('created_at', 'desc')
      .limit(50) // 최근 50개만 조회
      .get();

    const wishList = [];
    for (const doc of wishSnapshot.docs) {
      const wishData = doc.data();
      wishList.push({
        index: wishData.index || 1,
        profile_uid: wishData.profile_uid || '',
        comment: wishData.comment || '',
        profile_name: wishData.profile_name || '',
        streak: wishData.streak || 1,
        created_at: wishData.created_at,
      });
    }

    res.status(200).json({
      success: true,
      data: {
        wishList,
      },
    });
  } catch (error) {
    console.error('getWish error:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to get wish list' });
    }
  }
}); 