import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { verifyAuth } from '../utils/auth';

export const deleteComment = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // DELETE 요청만 허용
    if (req.method !== 'DELETE') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const { articleId, commentId } = req.body;

    if (!articleId || !commentId) {
      res.status(400).json({ success: false, error: 'Article ID and comment ID are required' });
      return;
    }

    // 게시글 존재 여부 확인
    const articleRef = admin.firestore().collection(FIRESTORE_COLLECTION_ARTICLE).doc(articleId);
    const articleDoc = await articleRef.get();

    if (!articleDoc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    const articleData = articleDoc.data();
    if (!articleData) {
      res.status(404).json({ success: false, error: 'Article data not found' });
      return;
    }

    // 댓글 목록에서 해당 댓글 찾기
    const comments = articleData.comments || [];
    const commentIndex = comments.findIndex((comment: any) => comment.id === commentId);

    if (commentIndex === -1) {
      res.status(404).json({ success: false, error: 'Comment not found' });
      return;
    }

    const commentToDelete = comments[commentIndex];

    // 댓글 작성자 확인 (토큰의 uid와 댓글의 profile_uid 비교)
    if (commentToDelete.profile_uid !== uid) {
      res.status(403).json({ success: false, error: 'Only the author can delete the comment' });
      return;
    }

    // 댓글 삭제
    comments.splice(commentIndex, 1);

    await articleRef.update({
      comments: comments,
      count_comments: admin.firestore.FieldValue.increment(-1)
    });

    res.status(200).json({
      success: true,
      data: comments
    });

  } catch (error) {
    console.error('Error deleting comment:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to delete comment' });
    }
  }
}); 