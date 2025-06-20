import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE, FIRESTORE_FIELD_COMMENTS } from '../utils/constants';

export const deleteComment = onRequest({ 
  cors: true,
}, async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'DELETE, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'DELETE') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    const { articleKey, commentKey } = req.body;
    
    if (!articleKey || !commentKey) {
      res.status(400).json({ success: false, error: 'Article key and comment key are required' });
      return;
    }

    const db = admin.firestore();
    const articleRef = db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(articleKey);

    // 현재 게시글 데이터 가져오기
    const articleDoc = await articleRef.get();
    if (!articleDoc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    const articleData = articleDoc.data();
    const comments = articleData?.[FIRESTORE_FIELD_COMMENTS] || [];

    // 삭제할 댓글 찾기
    const commentToDelete = comments.find((comment: any) => comment.key === commentKey);
    if (!commentToDelete) {
      res.status(404).json({ success: false, error: 'Comment not found' });
      return;
    }

    // 댓글 삭제
    await articleRef.update({
      [FIRESTORE_FIELD_COMMENTS]: admin.firestore.FieldValue.arrayRemove([commentToDelete])
    });

    // 삭제 후 남은 댓글 목록 가져오기
    const updatedDoc = await articleRef.get();
    const updatedData = updatedDoc.data();
    const remainingComments = updatedData?.[FIRESTORE_FIELD_COMMENTS] || [];

    res.status(200).json({
      success: true,
      message: 'Comment deleted successfully',
      data: remainingComments
    });

  } catch (error) {
    console.error('Error deleting comment:', error);
    res.status(500).json({ success: false, error: 'Failed to delete comment' });
  }
}); 