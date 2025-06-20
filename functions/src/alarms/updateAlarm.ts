import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ALARM } from '../utils/constants';

export const updateAlarm = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // PUT 요청만 허용
    if (req.method !== 'PUT') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const { alarmKey, alarmData } = req.body;
    
    if (!alarmKey || !alarmData) {
      res.status(400).json({ success: false, error: 'Alarm key and data are required' });
      return;
    }

    const db = admin.firestore();
    const alarmRef = db.collection(FIRESTORE_COLLECTION_ALARM).doc(alarmKey);

    await alarmRef.update(alarmData);

    res.status(200).json({
      success: true,
      message: 'Alarm updated successfully'
    });

  } catch (error) {
    console.error('Error updating alarm:', error);
    res.status(500).json({ success: false, error: 'Failed to update alarm' });
  }
}); 