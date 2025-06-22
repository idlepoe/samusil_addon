import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { verifyAuth } from '../utils/auth';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { awardPointsForLike } from '../utils/pointService';

export const toggleLike = onRequest({
  cors: true,
  region: 'asia-northeast3'
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

    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    const { articleId } = req.body;

    if (!articleId) {
      res.status(400).json({ success: false, error: 'Article ID is required' });
      return;
    }

    const articleRef = admin.firestore().collection(FIRESTORE_COLLECTION_ARTICLE).doc(articleId);
    const likeRef = articleRef.collection('likes').doc(uid);

    await admin.firestore().runTransaction(async (transaction) => {
      const articleDoc = await transaction.get(articleRef);
      if (!articleDoc.exists) {
        throw new Error('Article not found');
      }
      const likeDoc = await transaction.get(likeRef);
      let countLike = articleDoc.get('count_like') || 0;
      const articleData = articleDoc.data()!;
      const authorUid = articleData.profile_uid;

      if (likeDoc.exists) {
        // 좋아요 취소
        transaction.delete(likeRef);
        transaction.update(articleRef, { count_like: Math.max(0, countLike - 1) });
      } else {
        // 좋아요 추가
        transaction.set(likeRef, { created_at: new Date() });
        transaction.update(articleRef, { count_like: countLike + 1 });
        
        // 작성자에게 포인트 지급 (자신의 게시글에 좋아요를 누른 경우는 제외)
        if (authorUid !== uid) {
          try {
            await awardPointsForLike(authorUid, articleId);
          } catch (error) {
            console.error('Error awarding points for like:', error);
            // 포인트 지급 실패는 좋아요 기능에 영향을 주지 않도록 함
          }
        }
      }
    });

    res.status(200).json({ success: true });
  } catch (error: any) {
    console.error('Error toggling like:', error);
    res.status(500).json({ success: false, error: error.message || 'Failed to toggle like' });
  }
}); 