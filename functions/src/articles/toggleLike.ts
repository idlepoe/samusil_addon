import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { verifyAuth } from '../utils/auth';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { awardPointsForLike } from '../utils/pointService';
import { sendLikeNotification } from '../utils/notificationService';

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
    const articleDoc = await articleRef.get();

    if (!articleDoc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    const articleData = articleDoc.data()!;
    const profileUid = articleData.profile_uid;

    const likeRef = articleRef.collection('likes').doc(uid);
    const likeDoc = await likeRef.get();

    let isLiked = false;
    let pointsEarned = 0;
    let newPoints = 0;

    if (likeDoc.exists) {
      // 좋아요 취소
      await likeRef.delete();
      
      // 게시글의 좋아요 수 감소
      await articleRef.update({
        count_like: admin.firestore.FieldValue.increment(-1)
      });
    } else {
      // 좋아요 추가
      await likeRef.set({
        user_uid: uid,
        created_at: new Date()
      });
      
      // 게시글의 좋아요 수 증가
      await articleRef.update({
        count_like: admin.firestore.FieldValue.increment(1)
      });

      isLiked = true;

      // 좋아요 시 포인트 지급 (작성자에게)
      if (uid !== profileUid && profileUid && profileUid.trim()) {
        newPoints = await awardPointsForLike(profileUid, articleId);
        pointsEarned = 1;
      }

      // 좋아요 알림 발송
      const likerProfileRef = admin.firestore().collection('profile').doc(uid);
      const likerProfileDoc = await likerProfileRef.get();
      let likerName = '사용자';
      
      if (likerProfileDoc.exists) {
        const likerProfileData = likerProfileDoc.data();
        likerName = likerProfileData?.name || '사용자';
      }

      await sendLikeNotification(
        articleId,
        articleData.title,
        profileUid,
        uid,
        likerName
      );
    }

    // 업데이트된 좋아요 수 반환
    const updatedArticleDoc = await articleRef.get();
    const updatedCountLike = updatedArticleDoc.data()?.count_like || 0;

    res.status(200).json({
      success: true,
      data: {
        isLiked: isLiked,
        countLike: updatedCountLike,
        pointsEarned: pointsEarned,
        newPoints: newPoints
      }
    });
  } catch (error: any) {
    console.error('Error toggling like:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to toggle like' });
    }
  }
}); 