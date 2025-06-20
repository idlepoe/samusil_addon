import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { Article } from '../utils/types';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';

export const searchArticles = onRequest({ 
  cors: true,
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'GET' && req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    let searchQuery: string;
    let limit: number;

    if (req.method === 'GET') {
      searchQuery = (req.query.search as string) || '';
      limit = Number(req.query.limit) || 20;
    } else {
      const { search, limit: limitParam } = req.body;
      searchQuery = search || '';
      limit = Number(limitParam) || 20;
    }

    if (!searchQuery) {
      res.status(400).json({ success: false, error: 'Search query is required' });
      return;
    }

    const db = admin.firestore();
    const snapshot = await db.collection(FIRESTORE_COLLECTION_ARTICLE)
      .orderBy('key', 'desc')
      .limit(limit)
      .get();

    const articles: Article[] = [];
    const searchLower = searchQuery.toLowerCase();

    snapshot.forEach(doc => {
      const articleData = doc.data() as Article;
      
      // 제목에서 검색
      if (articleData.title.toLowerCase().includes(searchLower)) {
        articles.push(articleData);
        return;
      }

      // 내용에서 검색
      const contentMatch = articleData.contents.some(content => 
        !content.isPicture && content.contents.toLowerCase().includes(searchLower)
      );
      
      if (contentMatch) {
        articles.push(articleData);
      }
    });

    res.status(200).json({
      success: true,
      data: articles
    });

  } catch (error) {
    console.error('Error searching articles:', error);
    res.status(500).json({ success: false, error: 'Failed to search articles' });
  }
}); 