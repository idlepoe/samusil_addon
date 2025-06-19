import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { updateCoinPrices } from './updateCoinPrice';

export const manualUpdateCoinPrice = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    const db = admin.firestore();
    const result = await updateCoinPrices(db);

    res.status(200).json({
      success: true,
      message: `Manual update completed: Updated ${result.updatedCount} coins, Created ${result.createdCount} new coins`,
      data: result
    });

  } catch (error) {
    console.error('Error in manualUpdateCoinPrice:', error);
    res.status(500).json({ success: false, error: 'Failed to manually update coin prices' });
  }
}); 