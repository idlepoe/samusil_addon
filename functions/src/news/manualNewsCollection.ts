import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { fetchAndParseGameNews, fetchAndParseEntertainmentNews } from './scheduledNewsCollection';

export const manualNewsCollection = onRequest({ cors: true, region: 'asia-northeast3' }, async (req, res) => {
  try {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    const db = admin.firestore();
    await fetchAndParseGameNews(db);
    res.status(200).json({ success: true, message: '게임뉴스 수동 수집 완료' });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
});

export const manualEntertainmentNewsCollection = onRequest({ cors: true, region: 'asia-northeast3' }, async (req, res) => {
  try {
    if (!admin.apps.length) {
      admin.initializeApp();
    }
    const db = admin.firestore();
    await fetchAndParseEntertainmentNews(db);
    res.status(200).json({ success: true, message: '연예뉴스 수동 수집 완료' });
  } catch (error: any) {
    res.status(500).json({ success: false, error: error.message });
  }
}); 