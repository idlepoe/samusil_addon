import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';

export const updateArticleCount = onRequest({ 
  cors: true,
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'PUT, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'PUT') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const { articleKey, countType, increment = 1 } = req.body;
    
    if (!articleKey || !countType) {
      res.status(400).json({ success: false, error: 'Article key and count type are required' });
      return;
    }

    const validCountTypes = ['count_view', 'count_like', 'count_unlike'];
    if (!validCountTypes.includes(countType)) {
      res.status(400).json({ success: false, error: 'Invalid count type' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(articleKey);

    await articleRef.update({
      [countType]: admin.firestore.FieldValue.increment(increment)
    });

    res.status(200).json({
      success: true,
      message: 'Article count updated successfully'
    });

  } catch (error) {
    console.error('Error updating article count:', error);
    res.status(500).json({ success: false, error: 'Failed to update article count' });
  }
}); 