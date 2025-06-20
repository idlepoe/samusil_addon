import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';

export const deleteArticle = onRequest({ 
  cors: true,
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'DELETE, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'DELETE') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const { key } = req.body;
    
    if (!key) {
      res.status(400).json({ success: false, error: 'Article key is required' });
      return;
    }

    const db = admin.firestore();
    await db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(key).delete();

    res.status(200).json({
      success: true,
      message: 'Article deleted successfully'
    });

  } catch (error) {
    console.error('Error deleting article:', error);
    res.status(500).json({ success: false, error: 'Failed to delete article' });
  }
}); 