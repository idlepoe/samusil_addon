import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';

export const getArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    const { key } = req.query;
    
    if (!key || typeof key !== 'string') {
      res.status(400).json({ success: false, error: 'Article key is required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(key);
    const articleDoc = await articleRef.get();

    if (!articleDoc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    const articleData = articleDoc.data();
    
    res.status(200).json({
      success: true,
      data: articleData
    });

  } catch (error) {
    console.error('Error getting article:', error);
    res.status(500).json({ success: false, error: 'Failed to get article' });
  }
}); 