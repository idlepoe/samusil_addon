import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_PROFILE } from '../utils/constants';

export const updatePoint = onRequest({ 
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

    const { profile_key, point } = req.body;
    
    if (!profile_key || point === undefined) {
      res.status(400).json({ success: false, error: 'Profile key and point are required' });
      return;
    }

    const db = admin.firestore();
    const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(profile_key);

    // 현재 프로필 조회
    const profileDoc = await profileRef.get();
    if (!profileDoc.exists) {
      res.status(404).json({ success: false, error: 'Profile not found' });
      return;
    }

    const currentProfile = profileDoc.data()!;
    const currentPoint = currentProfile.point || 0;
    const newPoint = currentPoint + point;

    // 포인트 업데이트 (음수 포인트 방지)
    const finalPoint = Math.max(0, newPoint);

    await profileRef.update({
      point: finalPoint
    });

    // 업데이트된 프로필 조회하여 반환
    const updatedDoc = await profileRef.get();
    const updatedProfile = updatedDoc.data()!;

    res.status(200).json({
      success: true,
      message: 'Point updated successfully',
      data: updatedProfile
    });

  } catch (error) {
    console.error('Error updating point:', error);
    res.status(500).json({ success: false, error: 'Failed to update point' });
  }
}); 