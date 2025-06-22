import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';

export const getArticleDetail = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    const { key } = req.query;
    
    if (!key || typeof key !== 'string') {
      res.status(400).json({ success: false, error: 'Article key is required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(key);
    const articleDoc = await articleRef.get();

    if (!articleDoc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    // 조회수 증가
    await articleRef.update({
      count_view: admin.firestore.FieldValue.increment(1)
    });

    // 댓글 서브컬렉션에서 댓글 가져오기
    const commentsSnapshot = await articleRef.collection('comments').orderBy('created_at', 'asc').get();
    const comments = commentsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    const updatedDoc = await articleRef.get();
    const articleData = updatedDoc.data();
    
    if (articleData) {
      const article = {
        id: updatedDoc.id,
        board_name: articleData.board_name,
        profile_uid: articleData.profile_uid,
        profile_name: articleData.profile_name,
        profile_photo_url: articleData.profile_photo_url,
        count_view: articleData.count_view || 0,
        count_like: articleData.count_like || 0,
        count_unlike: articleData.count_unlike || 0,
        count_comments: comments.length, // 서브컬렉션의 댓글 수로 업데이트
        title: articleData.title,
        contents: articleData.contents || [],
        created_at: articleData.created_at,
        is_notice: articleData.is_notice || false,
        thumbnail: articleData.thumbnail,
        comments: comments, // 댓글 데이터 포함
      };

      res.status(200).json(article);
    } else {
      res.status(404).json({ error: 'Article not found' });
    }

  } catch (error) {
    console.error('Error getting article:', error);
    res.status(500).json({ success: false, error: 'Failed to get article' });
  }
}); 