import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_PROFILE } from '../utils/constants';

export const updateProfile = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
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

    const { profileKey, profileData } = req.body;
    
    if (!profileKey || !profileData) {
      res.status(400).json({ success: false, error: 'Profile key and data are required' });
      return;
    }

    const db = admin.firestore();
    const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(profileKey);

    await profileRef.update(profileData);

    res.status(200).json({
      success: true,
      message: 'Profile updated successfully'
    });

  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ success: false, error: 'Failed to update profile' });
  }
}); 