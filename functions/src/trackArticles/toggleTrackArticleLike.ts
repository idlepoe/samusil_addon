import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { verifyAuth } from '../utils/auth';
import { FIRESTORE_COLLECTION_TRACK_ARTICLE } from '../utils/constants';
import { awardPointsForLike } from '../utils/pointService';

export const toggleTrackArticleLike = onRequest({ 
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

    const { id } = req.body;

    // 필수 파라미터 확인
    if (!id) {
      res.status(400).json({
        success: false,
        error: 'trackArticle id is required'
      });
      return;
    }

    const db = admin.firestore();
    const trackArticleRef = db.collection(FIRESTORE_COLLECTION_TRACK_ARTICLE).doc(id);
    const trackArticleDoc = await trackArticleRef.get();

    if (!trackArticleDoc.exists) {
      res.status(404).json({ success: false, error: 'TrackArticle not found' });
      return;
    }

    const trackArticleData = trackArticleDoc.data()!;
    const authorUid = trackArticleData.profile_uid;

    const likeRef = trackArticleRef.collection('likes').doc(uid);
    const likeDoc = await likeRef.get();

    let isLiked = false;
    let pointsEarned = 0;
    let newPoints = 0;

    if (likeDoc.exists) {
      // 좋아요 취소
      await likeRef.delete();
      
      // 플레이리스트의 좋아요 수 감소
      await trackArticleRef.update({
        count_like: admin.firestore.FieldValue.increment(-1)
      });
    } else {
      // 좋아요 추가
      await likeRef.set({
        user_uid: uid,
        created_at: new Date()
      });
      
      // 플레이리스트의 좋아요 수 증가
      await trackArticleRef.update({
        count_like: admin.firestore.FieldValue.increment(1)
      });

      isLiked = true;

      // 좋아요 시 포인트 지급 (작성자에게)
      if (uid !== authorUid && authorUid && authorUid.trim()) {
        newPoints = await awardPointsForLike(authorUid, id);
        pointsEarned = 1;
      }
    }

    // 업데이트된 좋아요 수 반환
    const updatedTrackArticleDoc = await trackArticleRef.get();
    const updatedCountLike = updatedTrackArticleDoc.data()?.count_like || 0;

    res.status(200).json({
      success: true,
      data: {
        isLiked: isLiked,
        countLike: updatedCountLike,
        pointsEarned: pointsEarned,
        newPoints: newPoints
      }
    });

  } catch (error) {
    console.error('toggleTrackArticleLike 오류:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ 
        success: false, 
        error: error instanceof Error ? error.message : 'Internal server error'
      });
    }
  }
}); 