import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { verifyAuth } from '../utils/auth';

export const updateArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'PUT') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const { articleKey, contents } = req.body;
    
    if (!articleKey || !contents) {
      res.status(400).json({ success: false, error: 'Article key and contents are required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(articleKey);

    // 게시글 존재 여부 및 작성자 확인
    const articleDoc = await articleRef.get();
    if (!articleDoc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    const articleData = articleDoc.data();
    if (!articleData) {
      res.status(404).json({ success: false, error: 'Article data not found' });
      return;
    }

    // 작성자 확인 (토큰의 uid와 게시글의 profile_uid 비교)
    if (articleData.profile_uid !== uid) {
      res.status(403).json({ success: false, error: 'Only the author can update the article' });
      return;
    }

    // 본문만 업데이트
    await articleRef.update({
      contents: contents,
      last_updated: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).json({
      success: true,
      message: 'Article updated successfully'
    });

  } catch (error) {
    console.error('Error updating article:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to update article' });
    }
  }
}); 