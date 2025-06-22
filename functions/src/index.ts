import { setGlobalOptions } from 'firebase-functions/v2';
setGlobalOptions({ region: 'asia-northeast3', maxInstances: 10 });

import * as admin from 'firebase-admin';

// Firebase Admin 초기화
if (!admin.apps.length) {
  admin.initializeApp();
}

// Articles
export { createArticle } from './articles/createArticle';
export { getArticleDetail } from './articles/getArticleDetail';
export { getArticleList } from './articles/getArticleList';

// Article
export { updateArticle } from './articles/updateArticle';
export { deleteArticle } from './articles/deleteArticle';

// Comments
export { createComment } from './articles/createComment';
export { deleteComment } from './articles/deleteComment';

// Coins
export { getCoinList } from './coins/getCoinList';
export { buyCoin } from './coins/buyCoin';
export { sellCoin } from './coins/sellCoin';

// Coins Schedule
export { updateCoinPrice } from './coins/updateCoinPrice';
export { manualUpdateCoinPrice } from './coins/manualUpdateCoinPrice';
export { scheduledUpdateCoinPrice } from './coins/scheduledUpdateCoinPrice';

// Profiles
export { createWish } from './profiles/createWish';
export { getWish } from './profiles/getWish';

// // Alarms
// export { createAlarm } from './alarms/createAlarm';
// export { getAlarms } from './alarms/getAlarms';
// export { updateAlarm } from './alarms/updateAlarm';

// News
// export { scheduledGameNewsCollection } from './news/scheduledNewsCollection';
export { manualNewsCollection } from './news/manualNewsCollection';

export * from './articles/toggleLike'; 