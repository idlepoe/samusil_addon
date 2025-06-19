import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { Profile } from '../utils/types';
import { FIRESTORE_COLLECTION_PROFILE, FIRESTORE_ERROR_CODE_NOT_FOUND } from '../utils/constants';

export const updatePoint = onRequest({ 
  cors: true,
  region: 'us-central1'
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

    const { profileKey, point } = req.body;
    
    if (!profileKey || point === undefined) {
      res.status(400).json({ success: false, error: 'Profile key and point are required' });
      return;
    }

    const db = admin.firestore();
    const profileRef = db.collection(FIRESTORE_COLLECTION_PROFILE).doc(profileKey);

    try {
      // 포인트 업데이트 시도
      await profileRef.update({
        point: admin.firestore.FieldValue.increment(point)
      });

      // 업데이트된 프로필 조회
      const docSnapshot = await profileRef.get();
      if (docSnapshot.exists) {
        const profileData = docSnapshot.data() as Profile;
        res.status(200).json({
          success: true,
          data: profileData
        });
      } else {
        res.status(404).json({ success: false, error: 'Profile not found' });
      }

    } catch (error: any) {
      // 문서가 존재하지 않는 경우 새로 생성
      if (error.code === FIRESTORE_ERROR_CODE_NOT_FOUND) {
        await profileRef.set({ point });
        const docSnapshot = await profileRef.get();
        const profileData = docSnapshot.data() as Profile;
        
        res.status(200).json({
          success: true,
          data: profileData
        });
      } else {
        throw error;
      }
    }

  } catch (error) {
    console.error('Error updating point:', error);
    res.status(500).json({ success: false, error: 'Failed to update point' });
  }
}); 