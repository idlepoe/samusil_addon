import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';

export const getArticleList = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    const { board_name, search, limit, is_popular, is_notice, exclude_news } = req.query;
    
    if (!board_name || typeof board_name !== 'string') {
      res.status(400).json({ success: false, error: 'Board name is required' });
      return;
    }

    const db = admin.firestore();
    let query: admin.firestore.Query = db.collection(FIRESTORE_COLLECTION_ARTICLE);

    // 게시판별 필터링
    if (board_name !== 'all') {
      query = query.where('board_name', '==', board_name);
    }

    // 검색어 필터링
    if (search && typeof search === 'string' && search.trim() !== '') {
      // 제목에서 검색 (간단한 구현)
      query = query.where('title', '>=', search).where('title', '<=', search + '\uf8ff');
    }

    // 인기글 필터링
    if (is_popular === 'true') {
      query = query.orderBy('count_like', 'desc');
    }

    // 공지사항 필터링
    if (is_notice === 'true') {
      query = query.where('is_notice', '==', true);
    }

    // 뉴스 제외 필터링
    if (exclude_news === 'true') {
      query = query.where('board_name', 'not-in', ['game_news', 'entertainment_news', 'it_news']);
    }

    // 기본 정렬 (최신순)
    query = query.orderBy('created_at', 'desc');

    // 개수 제한
    const limitValue = limit ? parseInt(limit as string) : 20;
    query = query.limit(limitValue);

    const querySnapshot = await query.get();
    const articles = querySnapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        id: doc.id,
        board_name: data.board_name,
        profile_uid: data.profile_uid,
        profile_name: data.profile_name,
        profile_photo_url: data.profile_photo_url,
        count_view: data.count_view || 0,
        count_like: data.count_like || 0,
        count_unlike: data.count_unlike || 0,
        count_comments: data.count_comments || 0,
        title: data.title,
        contents: data.contents || [],
        created_at: data.created_at,
        is_notice: data.is_notice || false,
        thumbnail: data.thumbnail,
      };
    });

    res.status(200).json({
      success: true,
      data: articles
    });

  } catch (error) {
    console.error('Error getting article list:', error);
    res.status(500).json({ success: false, error: 'Failed to get article list' });
  }
}); 