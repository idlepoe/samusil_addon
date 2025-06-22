import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { FIRESTORE_COLLECTION_ARTICLE } from '../utils/constants';
import { verifyAuth } from '../utils/auth';
import { awardPointsForComment } from '../utils/pointService';
import { sendCommentNotification } from '../utils/notificationService';

export const createComment = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
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

    // 작성자의 프로필 정보 조회 (포인트 포함)
    const profileRef = admin.firestore().collection('profile').doc(uid);
    const profileDoc = await profileRef.get();
    let profilePoint = 0;
    let profileData: any = null;
    
    if (profileDoc.exists) {
      profileData = profileDoc.data();
      profilePoint = profileData?.point || 0;
    }

    // 댓글 서브컬렉션에 댓글 추가
    const commentRef = articleRef.collection('comments').doc();
    const comment = {
      id: commentRef.id,
      contents: commentData.contents,
      profile_uid: uid, // 토큰에서 추출한 uid 사용
      profile_name: commentData.profile_name,
      profile_photo_url: commentData.profile_photo_url,
      profile_point: profilePoint,
      created_at: new Date(),
      is_sub: false,
      parents_key: '',
    };

    // 첫 번째 댓글인지 확인
    const existingCommentsSnapshot = await articleRef.collection('comments').limit(1).get();
    const isFirstComment = existingCommentsSnapshot.empty;

    // 댓글 저장
    await commentRef.set(comment);

    // 게시글의 댓글 수 증가
    await articleRef.update({
      count_comments: admin.firestore.FieldValue.increment(1)
    });

    // 포인트 지급
    const pointsEarned = isFirstComment ? 8 : 3;
    const newPoints = await awardPointsForComment(uid, commentRef.id, isFirstComment);

    // 댓글 알림 발송
    const articleData = articleDoc.data()!;
    const authorUid = articleData.author_uid;
    const commenterName = profileData?.name || commentData.profile_name;

    await sendCommentNotification(
      articleId,
      articleData.title,
      authorUid,
      uid,
      commenterName
    );

    // 업데이트된 댓글 목록 반환
    const commentsSnapshot = await articleRef.collection('comments').orderBy('created_at', 'asc').get();
    const comments = commentsSnapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.status(200).json({
      success: true,
      data: {
        comments: comments,
        pointsEarned: pointsEarned,
        newPoints: newPoints,
        isFirstComment: isFirstComment
      }
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