import { setGlobalOptions } from 'firebase-functions/v2';
setGlobalOptions({ region: 'asia-northeast3', maxInstances: 10 });

import * as admin from 'firebase-admin';

// Firebase Admin 초기화
if (!admin.apps.length) {
  admin.initializeApp();
}

// Articles
export { createArticle } from './articles/createArticle';
export { getArticleList } from './articles/getArticleList';
export { getArticleDetail } from './articles/getArticleDetail';
export { updateArticle } from './articles/updateArticle';
export { deleteArticle } from './articles/deleteArticle';
export { createComment } from './articles/createComment';
export { deleteComment } from './articles/deleteComment';
export { toggleLike } from './articles/toggleLike';

// Profiles
export { createWish } from './profiles/createWish';
export { getWish } from './profiles/getWish';

// Alarms
export { createAlarm } from './alarms/createAlarm';
export { getAlarms } from './alarms/getAlarms';
export { updateAlarm } from './alarms/updateAlarm';

// News
export { scheduledGameNewsCollection } from './news/scheduledNewsCollection';
export { manualNewsCollection } from './news/manualNewsCollection';

// Race
export { scheduledCreateHorseRace } from './race/scheduledCreateHorseRace';
export { scheduledUpdateHorseRace } from './race/scheduledUpdateHorseRace';
export { placeBet } from './race/placeBet';

// // Alarms
// export { createAlarm } from './alarms/createAlarm';
// export { getAlarms } from './alarms/getAlarms';
// export { updateAlarm } from './alarms/updateAlarm';

// News
// export { scheduledGameNewsCollection } from './news/scheduledNewsCollection';
// export { manualNewsCollection } from './news/manualNewsCollection';

// export * from './articles/toggleLike'; 