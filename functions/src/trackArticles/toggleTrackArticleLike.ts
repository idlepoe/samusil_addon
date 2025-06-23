import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { verifyAuth } from '../utils/auth';
import { FIRESTORE_COLLECTION_TRACK_ARTICLE, FIRESTORE_COLLECTION_PROFILE } from '../utils/constants';

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

    // 트랜잭션으로 처리
    const result = await db.runTransaction(async (transaction) => {
      // trackArticle 문서 가져오기
      const trackArticleRef = db.collection(FIRESTORE_COLLECTION_TRACK_ARTICLE).doc(id);
      const trackArticleDoc = await transaction.get(trackArticleRef);

      if (!trackArticleDoc.exists) {
        throw new Error('TrackArticle not found');
      }

      // 사용자 프로필 문서 가져오기
      const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(uid);
      const profileDoc = await transaction.get(profileRef);

      if (!profileDoc.exists) {
        throw new Error('Profile not found');
      }

      const profileData = profileDoc.data();
      const likedTrackArticles = profileData?.liked_track_articles || [];
      const trackArticleData = trackArticleDoc.data();
      const currentLikeCount = trackArticleData?.count_like || 0;

      let isLiked = false;
      let newLikeCount = currentLikeCount;

      // 좋아요 상태 확인 및 토글
      const likeIndex = likedTrackArticles.indexOf(id);
      
      if (likeIndex > -1) {
        // 좋아요 제거
        likedTrackArticles.splice(likeIndex, 1);
        newLikeCount = Math.max(0, currentLikeCount - 1);
        isLiked = false;
      } else {
        // 좋아요 추가
        likedTrackArticles.push(id);
        newLikeCount = currentLikeCount + 1;
        isLiked = true;
      }

      // 프로필의 좋아요 목록 업데이트
      transaction.update(profileRef, {
        liked_track_articles: likedTrackArticles,
        updated_at: admin.firestore.FieldValue.serverTimestamp()
      });

      // trackArticle 좋아요 수 업데이트
      transaction.update(trackArticleRef, {
        count_like: newLikeCount,
        updated_at: admin.firestore.FieldValue.serverTimestamp()
      });

      return {
        isLiked,
        likeCount: newLikeCount
      };
    });

    res.status(200).json({
      success: true,
      data: {
        isLiked: result.isLiked,
        likeCount: result.likeCount
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