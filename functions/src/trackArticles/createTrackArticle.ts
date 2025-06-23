import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { verifyAuth } from '../utils/auth';
import { TrackArticle } from '../utils/types';
import { awardPointsForAction } from '../utils/pointService';
import { FIRESTORE_COLLECTION_TRACK_ARTICLE } from '../utils/constants';

export const createTrackArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
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

    const { title, tracks, description } = req.body;
    
    // 필수 필드 검증
    if (!title || !tracks || tracks.length === 0) {
      res.status(400).json({ success: false, error: '제목과 트랙 목록은 필수입니다.' });
      return;
    }

    const db = admin.firestore();
    
    // 사용자 프로필 정보 조회
    const profileRef = db.collection('profile').doc(uid);
    const profileDoc = await profileRef.get();
    
    if (!profileDoc.exists) {
      res.status(400).json({ success: false, error: '사용자 프로필을 찾을 수 없습니다.' });
      return;
    }
    
    const profileData = profileDoc.data();
    
    // 총 재생시간 계산 (간단히 트랙 수 * 평균 3분으로 계산)
    const totalDuration = tracks.length * 180; // 3분 = 180초

    // TrackArticle 문서 생성
    const trackArticleRef = db.collection(FIRESTORE_COLLECTION_TRACK_ARTICLE).doc();
    const now = admin.firestore.Timestamp.now();
    const trackArticleData: TrackArticle = {
      id: trackArticleRef.id,
      profile_uid: uid,
      profile_name: profileData?.name || '',
      profile_photo_url: profileData?.photo_url || '',
      count_view: 0,
      count_like: 0,
      count_unlike: 0,
      count_comments: 0,

      title: title,
      tracks: tracks,
      created_at: now,
      updated_at: now,
      profile_point: profileData?.point || 0,
      total_duration: totalDuration,
      track_count: tracks.length,
      description: description || '',
    };

    await trackArticleRef.set(trackArticleData);

    // 플레이리스트 생성 포인트 지급 (50점)
    const newPoints = await awardPointsForAction(
      uid,
      '플레이리스트',
      50,
      `플레이리스트 "${title}" 생성`,
      trackArticleRef.id
    );

    res.status(200).json({
      success: true,
      message: '플레이리스트가 성공적으로 생성되었습니다.',
      data: { 
        ...trackArticleData,
        pointsEarned: 50,
        newPoints: newPoints
      }
    });

  } catch (error) {
    console.error('createTrackArticle 오류:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: '플레이리스트 생성 중 오류가 발생했습니다.' });
    }
  }
}); 