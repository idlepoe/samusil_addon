import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_WISH, FIRESTORE_COLLECTION_PROFILE } from '../utils/constants';

// Firebase Auth 토큰 검증 함수
async function verifyAuthToken(req: any): Promise<string> {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('No valid authorization header');
  }

  const token = authHeader.split('Bearer ')[1];
  const decodedToken = await admin.auth().verifyIdToken(token);
  return decodedToken.uid;
}

export const createWish = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    let userUid: string;
    try {
      userUid = await verifyAuthToken(req);
    } catch (error) {
      res.status(401).json({ success: false, error: 'Unauthorized' });
      return;
    }

    const { comment } = req.body;
    
    if (!comment || comment.trim().isEmpty) {
      res.status(400).json({ success: false, error: 'Comment is required' });
      return;
    }

    const db = admin.firestore();
    
    // 사용자 프로필 조회
    const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(userUid);
    const profileDoc = await profileRef.get();
    
    if (!profileDoc.exists) {
      res.status(404).json({ success: false, error: 'Profile not found' });
      return;
    }

    const profile = profileDoc.data()!;
    const currentStreak = profile.wish_streak || 1;
    const currentPoint = profile.point || 0;

    // 오늘 날짜 확인
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0]; // YYYY-MM-DD 형식
    const lastWishDate = profile.wish_last_date || '';

    let newStreak = currentStreak;
    let pointToAdd = 5; // 기본 포인트

    // 연속 기도 체크
    if (lastWishDate === todayStr) {
      res.status(400).json({ success: false, error: 'Already wished today' });
      return;
    } else if (lastWishDate === getYesterdayString()) {
      // 연속 기도
      newStreak = currentStreak + 1;
      pointToAdd = 5 + (newStreak - 1); // 기본 5점 + 연속 보너스
    } else {
      // 연속 끊김
      newStreak = 1;
      pointToAdd = 5;
    }

    // Wish 생성
    const wishData = {
      key: userUid,
      comments: comment.trim(),
      nick_name: profile.name || 'Anonymous',
      streak: newStreak,
      created_at: admin.firestore.Timestamp.now(),
      index: 0, // 나중에 업데이트
    };

    // 오늘 Wish 문서에 추가
    const wishRef = db.collection(FIRESTORE_COLLECTION_WISH).doc(todayStr);
    
    try {
      await wishRef.update({
        list: admin.firestore.FieldValue.arrayUnion([wishData])
      });
    } catch (error) {
      // 문서가 없으면 생성
      await wishRef.set({
        list: [wishData]
      });
    }

    // 프로필 업데이트 (연속 기도, 포인트, 마지막 기도 날짜)
    await profileRef.update({
      wish_streak: newStreak,
      wish_last_date: todayStr,
      point: currentPoint + pointToAdd
    });

    // 업데이트된 Wish 목록 조회
    const updatedWishDoc = await wishRef.get();
    const wishList = updatedWishDoc.data()?.list || [];
    
    // 인덱스 업데이트
    const indexedWishList = wishList.map((wish: any, index: number) => ({
      ...wish,
      index: index + 1
    }));

    // 업데이트된 프로필 조회
    const updatedProfileDoc = await profileRef.get();
    const updatedProfile = updatedProfileDoc.data()!;

    res.status(200).json({
      success: true,
      message: 'Wish created successfully',
      data: {
        profile: updatedProfile,
        wishList: indexedWishList,
        pointAdded: pointToAdd,
        newStreak: newStreak
      }
    });

  } catch (error) {
    console.error('Error creating wish:', error);
    res.status(500).json({ success: false, error: 'Failed to create wish' });
  }
});

// 어제 날짜 문자열 반환
function getYesterdayString(): string {
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  return yesterday.toISOString().split('T')[0];
} 