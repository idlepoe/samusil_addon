import { setGlobalOptions } from 'firebase-functions/v2';
setGlobalOptions({ region: 'asia-northeast3', maxInstances: 10 });

import * as admin from 'firebase-admin';

// Firebase Admin 초기화
if (!admin.apps.length) {
  admin.initializeApp();
}

// // Articles
// export { createArticle } from './articles/createArticle';
// export { getArticle } from './articles/getArticle';
// export { getArticleList } from './articles/getArticleList';
// export { updateArticle } from './articles/updateArticle';
// export { deleteArticle } from './articles/deleteArticle';
// export { createComment } from './articles/createComment';
// export { deleteComment } from './articles/deleteComment';
// export { updateArticleCount } from './articles/updateArticleCount';
// export { searchArticles } from './articles/searchArticles';

// // Profiles
// export { getProfile } from './profiles/getProfile';
// export { updateProfile } from './profiles/updateProfile';
// export { updatePoint } from './profiles/updatePoint';
// export { createProfile } from './profiles/createProfile';

// // Coins
// export { getCoinList } from './coins/getCoinList';
// export { buyCoin } from './coins/buyCoin';
// export { sellCoin } from './coins/sellCoin';
// export { updateCoinPrice } from './coins/updateCoinPrice';
export { manualUpdateCoinPrice } from './coins/manualUpdateCoinPrice';
export { scheduledUpdateCoinPrice } from './coins/scheduledUpdateCoinPrice';

// // Alarms
// export { createAlarm } from './alarms/createAlarm';
// export { getAlarms } from './alarms/getAlarms';
// export { updateAlarm } from './alarms/updateAlarm';

// News
// export { scheduledGameNewsCollection } from './news/scheduledNewsCollection';
export { manualNewsCollection } from './news/manualNewsCollection'; 