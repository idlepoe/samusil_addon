import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_PROFILE, FIRESTORE_FIELD_COIN_BALANCE } from '../utils/constants';

export const buyCoin = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const { profileKey, symbol, quantity, price } = req.body;
    
    if (!profileKey || !symbol || !quantity || !price) {
      res.status(400).json({ success: false, error: 'Profile key, symbol, quantity, and price are required' });
      return;
    }

    const db = admin.firestore();
    const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(profileKey);

    await profileRef.update({
      [FIRESTORE_FIELD_COIN_BALANCE]: admin.firestore.FieldValue.arrayUnion([{
        symbol,
        quantity: Number(quantity),
        price: Number(price)
      }])
    });

    res.status(200).json({
      success: true,
      message: 'Coin purchased successfully'
    });

  } catch (error) {
    console.error('Error buying coin:', error);
    res.status(500).json({ success: false, error: 'Failed to buy coin' });
  }
}); 