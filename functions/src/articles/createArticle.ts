import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { onRequest } from 'firebase-functions/v2/https';
import { verifyAuth } from '../utils/auth';

export const createArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

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

    const { articleData } = req.body;
    
    if (!articleData) {
      res.status(400).json({ success: false, error: 'Article data is required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc();

    // Firestore에 저장 (docId는 자동 생성됨)
    await articleRef.set({
      id: articleRef.id,
      board_name: articleData.board_name,
      profile_uid: uid, // 토큰에서 추출한 uid 사용
      profile_name: articleData.profile_name,
      profile_photo_url: articleData.profile_photo_url,
      count_view: articleData.count_view,
      count_like: articleData.count_like,
      count_unlike: articleData.count_unlike,
      count_comments: 0,
      title: articleData.title,
      contents: articleData.contents,
      created_at: articleData.created_at,
      is_notice: articleData.is_notice,
      thumbnail: articleData.thumbnail,
    });

    res.status(200).json({
      success: true,
      message: 'Article created successfully',
      data: { id: articleRef.id }
    });

  } catch (error) {
    console.error('Error creating article:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to create article' });
    }
  }
}); 