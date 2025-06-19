import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_PROFILE } from '../utils/constants';

export const createProfile = onRequest({ 
  cors: true,
  region: 'us-central1'
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

    const { profile } = req.body;
    
    if (!profile) {
      res.status(400).json({ success: false, error: 'Profile data is required' });
      return;
    }

    const db = admin.firestore();
    const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(profile.key);

    // 중복 확인
    const existingDoc = await profileRef.get();
    if (existingDoc.exists) {
      res.status(409).json({ success: false, error: 'Profile with this key already exists' });
      return;
    }

    // Firestore에 저장
    await profileRef.set(profile);

    res.status(200).json({
      success: true,
      message: 'Profile created successfully',
      data: { key: profile.key }
    });

  } catch (error) {
    console.error('Error creating profile:', error);
    res.status(500).json({ success: false, error: 'Failed to create profile' });
  }
}); 