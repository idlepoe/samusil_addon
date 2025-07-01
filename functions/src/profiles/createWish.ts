import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_WISH, FIRESTORE_COLLECTION_PROFILE } from '../utils/constants';
import { verifyAuth } from '../utils/auth';
import { updatePointsInternal } from '../utils/updatePoints';

export const createWish = onRequest({ 
  cors: true,
}, async (req, res) => {
  try {
    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // POST 요청만 허용
    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const { comment } = req.body;
    
    if (!comment || typeof comment !== 'string') {
      res.status(400).json({ success: false, error: 'Comment is required' });
      return;
    }

    const db = admin.firestore();
    
    // 사용자 프로필 조회
    const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(uid);
    const profileDoc = await profileRef.get();
    
    if (!profileDoc.exists) {
      res.status(404).json({ success: false, error: 'Profile not found' });
      return;
    }

    const profile = profileDoc.data()!;
    const currentStreak = profile.wish_streak || 0;

    // 오늘 날짜 확인
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0]; // YYYY-MM-DD 형식
    const lastWishDate = profile.wish_last_date || '';

    let newStreak = currentStreak;
    let basePoints = 20; // 기본 20포인트
    let streakBonus = 0; // 연승 보너스

    // 연속 기도 체크
    if (lastWishDate === todayStr) {
      res.status(400).json({ success: false, error: 'Already wished today' });
      return;
    } else if (lastWishDate === getYesterdayString()) {
      // 연속 기도
      newStreak = currentStreak + 1;
      streakBonus = 9 + newStreak; // 첫 연승: +10 (9+1), 둘째: +11 (9+2), 셋째: +12 (9+3)...
    } else {
      // 연속 끊김
      newStreak = 1;
      streakBonus = 0; // 첫날은 보너스 없음
    }

    const totalPoints = basePoints + streakBonus;

    // Wish 생성 - 개별 문서로 저장
    const wishData = {
      profile_uid: uid,
      comment: comment,
      profile_name: profile.name || 'Anonymous',
      streak: newStreak,
      created_at: admin.firestore.Timestamp.now(),
      date: todayStr, // 날짜 필드 추가 (쿼리용)
    };

    // 개별 Wish 문서 생성
    const wishRef = db.collection(FIRESTORE_COLLECTION_WISH).doc();
    await wishRef.set(wishData);

    // 프로필 업데이트 (연속 기도, 마지막 기도 날짜)
    await profileRef.update({
      wish_streak: newStreak,
      wish_last_date: todayStr,
    });

    // 포인트 지급 (updatePoints API 사용)
    const pointResult = await updatePointsInternal(
      uid,
      totalPoints,
      'wish',
      `소원빌기 ${newStreak}일차 (기본 ${basePoints}P${streakBonus > 0 ? ` + 연승보너스 ${streakBonus}P` : ''})`,
      {
        wishStreak: newStreak,
        basePoints: basePoints,
        streakBonus: streakBonus,
        totalPoints: totalPoints
      }
    );

    if (!pointResult.success) {
      console.error('포인트 지급 실패:', pointResult.error);
      // 포인트 지급이 실패해도 소원은 생성되었으므로 성공으로 처리
    }

    // 업데이트된 프로필 조회
    const updatedProfileDoc = await profileRef.get();
    const updatedProfile = updatedProfileDoc.data()!;

    res.status(200).json({
      success: true,
      message: 'Wish created successfully',
      data: {
        profile: updatedProfile,
        pointsEarned: totalPoints,
        basePoints: basePoints,
        streakBonus: streakBonus,
        newStreak: newStreak,
        newPoints: pointResult.newPoints
      }
    });

  } catch (error) {
    console.error('Error creating wish:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to create wish' });
    }
  }
});

// 어제 날짜 문자열 반환
function getYesterdayString(): string {
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  return yesterday.toISOString().split('T')[0];
} 