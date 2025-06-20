import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { verifyAuth } from '../utils/auth';

export const createComment = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // CORS 헤더 설정
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // POST 요청만 허용
    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const { articleId, commentData } = req.body;

    if (!articleId || !commentData) {
      res.status(400).json({ success: false, error: 'Article ID and comment data are required' });
      return;
    }

    // 게시글 존재 여부 확인
    const articleRef = admin.firestore().collection(FIRESTORE_COLLECTION_ARTICLE).doc(articleId);
    const articleDoc = await articleRef.get();

    if (!articleDoc.exists) {
      res.status(404).json({ success: false, error: 'Article not found' });
      return;
    }

    // 댓글 데이터 준비
    const comment = {
      id: admin.firestore().collection('comments').doc().id, // 자동 생성된 ID
      contents: commentData.contents,
      profile_uid: uid, // 토큰에서 추출한 uid 사용
      profile_name: commentData.profile_name,
      profile_photo_url: commentData.profile_photo_url,
      created_at: admin.firestore.FieldValue.serverTimestamp(),
      is_sub: false,
      parents_key: '',
    };

    // 댓글 추가
    await articleRef.update({
      comments: admin.firestore.FieldValue.arrayUnion(comment),
      count_comments: admin.firestore.FieldValue.increment(1)
    });

    // 업데이트된 댓글 목록 반환
    const updatedDoc = await articleRef.get();
    const updatedData = updatedDoc.data();
    const comments = updatedData?.comments || [];

    res.status(200).json({
      success: true,
      data: comments
    });

  } catch (error) {
    console.error('Error creating comment:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      res.status(500).json({ success: false, error: 'Failed to create comment' });
    }
  }
}); 