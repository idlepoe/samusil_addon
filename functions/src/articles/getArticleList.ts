import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { Article } from '../utils/types';
import { FIRESTORE_COLLECTION_ARTICLE, DEFAULT_BOARD_GET_LENGTH, BOARD_IT_NEWS, BOARD_GAME_NEWS } from '../utils/constants';

export const getArticleList = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // GET, POST 요청 허용
    if (req.method !== 'GET' && req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    let boardName: string;
    let search: string;
    let listLength: number;
    let isPopular: boolean | undefined;
    let isNotice: boolean | undefined;
    let excludeNews: boolean | undefined;

    if (req.method === 'GET') {
      // GET 요청: query parameters 사용
      boardName = (req.query.board_name as string) || '';
      search = (req.query.search as string) || '';
      listLength = Number(req.query.list_length) || DEFAULT_BOARD_GET_LENGTH;
      isPopular = req.query.is_popular === 'true';
      isNotice = req.query.is_notice === 'true';
      excludeNews = req.query.exclude_news === 'true';
    } else {
      // POST 요청: body 사용
      const { board_name, search: searchParam, list_length, is_popular, is_notice, exclude_news } = req.body;
      boardName = board_name || '';
      search = searchParam || '';
      listLength = Number(list_length) || DEFAULT_BOARD_GET_LENGTH;
      isPopular = is_popular;
      isNotice = is_notice;
      excludeNews = exclude_news;
    }

    const db = admin.firestore();
    let query: admin.firestore.Query = db.collection(FIRESTORE_COLLECTION_ARTICLE);

    // 게시판 필터링
    if (boardName && boardName !== 'all_board') { // 전체 게시판이 아닌 경우
      if (excludeNews) {
        // 뉴스 게시판 제외
        query = query.where('board_name', 'not-in', [BOARD_IT_NEWS, BOARD_GAME_NEWS]);
      } else {
        query = query.where('board_name', '==', boardName);
      }
    }

    // 정렬 (최신순)
    query = query.orderBy('key', 'desc').limit(listLength);

    const snapshot = await query.get();
    const articles: Article[] = [];

    snapshot.forEach(doc => {
      const articleData = doc.data() as Article;
      
      // 검색 필터링
      if (search) {
        const searchLower = search.toLowerCase();
        const titleMatch = articleData.title.toLowerCase().includes(searchLower);
        const contentMatch = articleData.contents.some(content => 
          !content.isPicture && content.contents.toLowerCase().includes(searchLower)
        );
        
        if (!titleMatch && !contentMatch) {
          return; // 검색 결과에 포함되지 않음
        }
      }

      // 인기글 필터링
      if (isPopular && articleData.count_like <= 3) {
        return;
      }

      // 공지사항 필터링
      if (isNotice && !articleData.is_notice) {
        return;
      }

      articles.push(articleData);
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