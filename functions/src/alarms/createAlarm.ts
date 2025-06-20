import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ALARM } from '../utils/constants';

export const createAlarm = onRequest({ 
  cors: true,
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