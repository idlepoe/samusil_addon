import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { Alarm } from '../utils/types';
import { FIRESTORE_COLLECTION_ALARM } from '../utils/constants';

export const getAlarms = onRequest({ 
  cors: true,
  region: 'us-central1'
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'GET') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const { profileKey } = req.query;
    
    if (!profileKey) {
      res.status(400).json({ success: false, error: 'Profile key is required' });
      return;
    }

    const db = admin.firestore();
    const snapshot = await db.collection(FIRESTORE_COLLECTION_ALARM)
      .where('profile_key', '==', profileKey)
      .orderBy('created_at', 'desc')
      .get();

    const alarms: Alarm[] = [];
    snapshot.forEach(doc => {
      alarms.push(doc.data() as Alarm);
    });

    res.status(200).json({
      success: true,
      data: alarms
    });

  } catch (error) {
    console.error('Error getting alarms:', error);
    res.status(500).json({ success: false, error: 'Failed to get alarms' });
  }
}); 