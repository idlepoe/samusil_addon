import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { onRequest } from 'firebase-functions/v2/https';

export const createArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
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

    const { article } = req.body;
    
    if (!article) {
      res.status(400).json({ success: false, error: 'Article data is required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(article.key);

    // 중복 확인
    const existingDoc = await articleRef.get();
    if (existingDoc.exists) {
      res.status(409).json({ success: false, error: 'Article with this key already exists' });
      return;
    }

    // Firestore에 저장
    await articleRef.set({
      key: article.key,
      board_index: article.board_index,
      profile_key: article.profile_key,
      profile_name: article.profile_name,
      count_view: article.count_view,
      count_like: article.count_like,
      count_unlike: article.count_unlike,
      title: article.title,
      contents: article.contents,
      created_at: article.created_at,
      comments: article.comments,
      is_notice: article.is_notice,
      thumbnail: article.thumbnail,
    });

    res.status(200).json({
      success: true,
      message: 'Article created successfully',
      data: { key: article.key }
    });

  } catch (error) {
    console.error('Error creating article:', error);
    res.status(500).json({ success: false, error: 'Failed to create article' });
  }
}); 