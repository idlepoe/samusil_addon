import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { Article } from '../utils/types';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';

export const getArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // GET 요청만 허용
    if (req.method !== 'GET') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const { key } = req.query;
    
    if (!key) {
      res.status(400).json({ success: false, error: 'Article key is required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(key as string);
    const doc = await articleRef.get();

    if (!doc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    const articleData = doc.data() as Article;

    res.status(200).json({
      success: true,
      data: articleData
    });

  } catch (error) {
    console.error('Error getting article:', error);
    res.status(500).json({ success: false, error: 'Failed to get article' });
  }
}); 