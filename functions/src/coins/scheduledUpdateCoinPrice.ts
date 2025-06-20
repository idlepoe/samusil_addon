import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as admin from 'firebase-admin';
import { updateCoinPrices } from './updateCoinPrice';

// 스케줄 설정 옵션:
// "*/5 * * * *" - 매 5분마다
// "*/10 * * * *" - 매 10분마다  
// "0 * * * *" - 매시간
// "0 */2 * * *" - 2시간마다
// "0 0 * * *" - 매일 자정
export const scheduledUpdateCoinPrice = onSchedule({
  schedule: '*/15 * * * *',
  timeZone: 'Asia/Seoul',
  region: 'asia-northeast3'
}, async (event) => {
  try {
    console.log('Starting scheduled coin price update...');
    
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    
    const db = admin.firestore();
    const result = await updateCoinPrices(db);

    console.log(`Scheduled update completed: Updated ${result.updatedCount} coins, Created ${result.createdCount} new coins, Deleted ${result.deletedCount} old documents out of ${result.totalProcessed} total`);

  } catch (error) {
    console.error('Error in scheduled coin price update:', error);
  }
}); 