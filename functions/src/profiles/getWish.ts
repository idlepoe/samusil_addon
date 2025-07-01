import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { verifyAuth } from '../utils/auth';

export const getWish = onRequest({ 
  cors: true,
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

    // 오늘 날짜
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];

    // 오늘 날짜의 Wish만 조회
    const wishSnapshot = await db
      .collection('wish')
      .where('date', '==', todayStr)
      .orderBy('created_at', 'desc')
      .limit(50)
      .get();

    const wishList = [];
    let index = 1;
    for (const doc of wishSnapshot.docs) {
      const wishData = doc.data();
      wishList.push({
        index: index++,
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