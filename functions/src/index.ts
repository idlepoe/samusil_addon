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
export { createAvatarPurchase } from './profiles/createAvatarPurchase';
export { createArtworkPurchase } from './profiles/createArtworkPurchase';
export { createRandomArtworkPurchase } from './profiles/createRandomArtworkPurchase';
export { unlockTitle } from './profiles/unlockTitle';
export { setSelectedTitle } from './profiles/setSelectedTitle';
export { scheduledSeoulMuseumSync } from './profiles/scheduledSeoulMuseumSync';
export { manualSeoulMuseumSync } from './profiles/manualSeoulMuseumSync';

// News
export { scheduledGameNewsCollection, scheduledEntertainmentNewsCollection } from './news/scheduledNewsCollection';
export { manualNewsCollection, manualEntertainmentNewsCollection } from './news/manualNewsCollection';

// Race
export { scheduledCreateHorseRace } from './race/scheduledCreateHorseRace';
export { scheduledUpdateHorseRace } from './race/scheduledUpdateHorseRace';
export { placeBet } from './race/placeBet';

// Utils
export { updatePoints } from './utils/updatePoints'; 