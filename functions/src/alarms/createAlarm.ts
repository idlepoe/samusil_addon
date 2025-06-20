import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ALARM } from '../utils/constants';

export const createAlarm = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
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

    const { alarm } = req.body;
    
    if (!alarm) {
      res.status(400).json({ success: false, error: 'Alarm data is required' });
      return;
    }

    const db = admin.firestore();
    const alarmRef = db.collection(FIRESTORE_COLLECTION_ALARM).doc(alarm.key);

    await alarmRef.set(alarm);

    res.status(200).json({
      success: true,
      message: 'Alarm created successfully',
      data: { key: alarm.key }
    });

  } catch (error) {
    console.error('Error creating alarm:', error);
    res.status(500).json({ success: false, error: 'Failed to create alarm' });
  }
}); 