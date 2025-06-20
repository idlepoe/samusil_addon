import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { verifyAuth } from '../utils/auth';

export const deleteArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'DELETE, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // DELETE 요청만 허용
    if (req.method !== 'DELETE') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const { id } = req.body;

    if (!id) {
      res.status(400).json({ success: false, error: 'Article ID is required' });
      return;
    }

    // 게시글 존재 여부 확인
    const articleRef = admin.firestore().collection(FIRESTORE_COLLECTION_ARTICLE).doc(id);
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
      res.status(403).json({ success: false, error: 'Only the author can delete the article' });
      return;
    }

    // 게시글 삭제
    await articleRef.delete();

    res.status(200).json({
      success: true,
      message: 'Article deleted successfully'
    });

  } catch (error) {
    console.error('Error deleting article:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to delete article' });
    }
  }
}); 