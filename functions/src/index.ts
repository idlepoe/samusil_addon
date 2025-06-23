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

// Track Articles
export { createTrackArticle } from './trackArticles/createTrackArticle';
export { getTrackArticleList } from './trackArticles/getTrackArticleList';
export { getTrackArticleDetail } from './trackArticles/getTrackArticleDetail';
export { updateTrackArticle } from './trackArticles/updateTrackArticle';
export { deleteTrackArticle } from './trackArticles/deleteTrackArticle';
export { toggleTrackArticleLike } from './trackArticles/toggleTrackArticleLike';

// Profiles
export { createWish } from './profiles/createWish';
export { getWish } from './profiles/getWish';

// News
export { scheduledGameNewsCollection } from './news/scheduledNewsCollection';
export { manualNewsCollection } from './news/manualNewsCollection';

// Race
export { scheduledCreateHorseRace } from './race/scheduledCreateHorseRace';
export { scheduledUpdateHorseRace } from './race/scheduledUpdateHorseRace';
export { placeBet } from './race/placeBet'; 