import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { onRequest } from 'firebase-functions/v2/https';

export const createArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
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
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc();

    // Firestore에 저장 (docId는 자동 생성됨)
    await articleRef.set({
      id: articleRef.id,
      board_name: article.board_name,
      profile_uid: article.profile_uid,
      profile_name: article.profile_name,
      profile_photo_url: article.profile_photo_url,
      count_view: article.count_view,
      count_like: article.count_like,
      count_unlike: article.count_unlike,
      count_comments: 0,
      title: article.title,
      contents: article.contents,
      created_at: article.created_at,
      is_notice: article.is_notice,
      thumbnail: article.thumbnail,
    });

    res.status(200).json({
      success: true,
      message: 'Article created successfully',
      data: { id: articleRef.id }
    });

  } catch (error) {
    console.error('Error creating article:', error);
    res.status(500).json({ success: false, error: 'Failed to create article' });
  }
}); 