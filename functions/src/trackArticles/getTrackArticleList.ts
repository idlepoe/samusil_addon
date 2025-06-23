import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { TrackArticle } from '../utils/types';
import { FIRESTORE_COLLECTION_TRACK_ARTICLE } from '../utils/constants';

export const getTrackArticleList = onRequest({ 
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

    const db = admin.firestore();
    const {
      lastDocumentId,
      limit = 20,
      orderBy = 'created_at',
      orderDirection = 'desc'
    } = req.body;

    let query = db.collection(FIRESTORE_COLLECTION_TRACK_ARTICLE)
      .orderBy(orderBy, orderDirection as 'asc' | 'desc')
      .limit(limit);

    // 페이지네이션 처리
    if (lastDocumentId) {
      const lastDoc = await db.collection(FIRESTORE_COLLECTION_TRACK_ARTICLE).doc(lastDocumentId).get();
      if (lastDoc.exists) {
        query = query.startAfter(lastDoc);
      }
    }

    const snapshot = await query.get();
    const trackArticles: TrackArticle[] = [];

    snapshot.forEach(doc => {
      const data = doc.data() as TrackArticle;
      trackArticles.push({
        ...data,
        id: doc.id,
      });
    });

    res.status(200).json({
      success: true,
      message: '플레이리스트 목록을 성공적으로 조회했습니다.',
      data: {
        trackArticles,
        hasMore: snapshot.size === limit,
        lastDocumentId: snapshot.size > 0 ? snapshot.docs[snapshot.size - 1].id : null,
      },
    });

  } catch (error) {
    console.error('getTrackArticleList 오류:', error);
    res.status(500).json({ 
      success: false, 
      error: '플레이리스트 목록 조회 중 오류가 발생했습니다.' 
    });
  }
}); 