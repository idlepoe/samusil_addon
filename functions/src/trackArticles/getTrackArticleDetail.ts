import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { verifyAuth } from '../utils/auth';
import { TrackArticle, MainComment } from '../utils/types';
import { FIRESTORE_COLLECTION_TRACK_ARTICLE } from '../utils/constants';

export const getTrackArticleDetail = onRequest({ 
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
    await verifyAuth(req);

    const { id, incrementView = true } = req.body;

    if (!id) {
      res.status(400).json({ success: false, error: '트랙 아티클 ID가 필요합니다.' });
      return;
    }

    const db = admin.firestore();
    const trackArticleRef = db.collection(FIRESTORE_COLLECTION_TRACK_ARTICLE).doc(id);
    
    // 트랜잭션을 사용하여 조회수 증가와 데이터 조회를 원자적으로 처리
    const result = await db.runTransaction(async (transaction) => {
      const trackArticleDoc = await transaction.get(trackArticleRef);
      
      if (!trackArticleDoc.exists) {
        throw new Error('존재하지 않는 플레이리스트입니다.');
      }

      const trackArticleData = trackArticleDoc.data() as TrackArticle;

      // 조회수 증가
      if (incrementView) {
        transaction.update(trackArticleRef, {
          count_view: admin.firestore.FieldValue.increment(1)
        });
        trackArticleData.count_view += 1;
      }

      // 댓글 조회
      const commentsSnapshot = await db
        .collection(FIRESTORE_COLLECTION_TRACK_ARTICLE)
        .doc(id)
        .collection('comments')
        .orderBy('created_at', 'desc')
        .get();

      const comments: MainComment[] = [];
      commentsSnapshot.forEach(doc => {
        comments.push({
          ...doc.data() as MainComment,
          key: doc.id,
        });
      });

      return {
        ...trackArticleData,
        id: trackArticleDoc.id,
        comments,
      };
    });

    res.status(200).json({
      success: true,
      message: '플레이리스트를 성공적으로 조회했습니다.',
      data: result,
    });

  } catch (error) {
    console.error('getTrackArticleDetail 오류:', error);
    
    const message = error instanceof Error ? error.message : '플레이리스트 조회 중 오류가 발생했습니다.';
    const statusCode = error instanceof Error && error.message === '존재하지 않는 플레이리스트입니다.' ? 404 : 500;
    
    res.status(statusCode).json({ 
      success: false, 
      error: message 
    });
  }
}); 