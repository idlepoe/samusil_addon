import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE, FIRESTORE_FIELD_COMMENTS } from '../utils/constants';

export const createComment = onRequest({ 
  cors: true,
  region: 'us-central1'
}, async (req, res) => {
  try {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

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

    const { articleKey, comment } = req.body;
    
    if (!articleKey || !comment) {
      res.status(400).json({ success: false, error: 'Article key and comment are required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(articleKey);

    // 댓글 추가
    await articleRef.update({
      [FIRESTORE_FIELD_COMMENTS]: admin.firestore.FieldValue.arrayUnion([comment])
    });

    // 업데이트된 댓글 목록 조회
    const docSnapshot = await articleRef.get();
    if (docSnapshot.exists) {
      const articleData = docSnapshot.data();
      const comments = articleData?.[FIRESTORE_FIELD_COMMENTS] || [];
      
      res.status(200).json({
        success: true,
        data: comments
      });
    } else {
      res.status(404).json({ success: false, error: 'Article not found' });
    }

  } catch (error) {
    console.error('Error creating comment:', error);
    res.status(500).json({ success: false, error: 'Failed to create comment' });
  }
}); 