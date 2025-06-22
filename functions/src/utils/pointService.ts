import * as admin from 'firebase-admin';
import { PointAction, PointHistory } from './types';

const db = admin.firestore();

/**
 * 포인트 지급 및 히스토리 기록
 */
export async function awardPoints(pointAction: PointAction): Promise<number> {
  try {
    const { profile_uid, action_type, points_earned, description, related_id } = pointAction;

    // 1. 프로필 포인트 업데이트
    const profileRef = db.collection('profile').doc(profile_uid);
    const profileDoc = await profileRef.get();
    
    if (!profileDoc.exists) {
      throw new Error('Profile not found');
    }

    const currentPoints = profileDoc.data()?.point || 0;
    const newPoints = currentPoints + points_earned;

    // 2. 포인트 히스토리 기록
    const pointHistoryData: PointHistory = {
      profile_uid,
      action_type,
      points_earned,
      description,
      related_id,
      created_at: admin.firestore.Timestamp.now(),
    };

    // 3. 트랜잭션으로 포인트 업데이트와 히스토리 기록을 원자적으로 처리
    await db.runTransaction(async (transaction) => {
      // 프로필 포인트 업데이트
      transaction.update(profileRef, { point: newPoints });
      
      // 포인트 히스토리 추가
      const historyRef = profileRef.collection('point_history').doc();
      transaction.set(historyRef, pointHistoryData);
    });

    console.log(`Awarded ${points_earned} points to ${profile_uid} for ${action_type}: ${description}`);
    return newPoints;
  } catch (error) {
    console.error('Error awarding points:', error);
    throw error;
  }
}

/**
 * 특정 액션에 대한 포인트 지급
 */
export async function awardPointsForAction(
  profile_uid: string,
  action_type: PointAction['action_type'],
  points_earned: number,
  description: string,
  related_id?: string
): Promise<number> {
  const pointAction: PointAction = {
    profile_uid,
    action_type,
    points_earned,
    description,
    related_id,
  };

  return await awardPoints(pointAction);
}

/**
 * 게시글 작성 포인트 지급
 */
export async function awardPointsForArticle(profile_uid: string, articleId: string): Promise<number> {
  return await awardPointsForAction(
    profile_uid,
    'article',
    10,
    '게시글 작성',
    articleId
  );
}

/**
 * 댓글 작성 포인트 지급
 */
export async function awardPointsForComment(
  profile_uid: string, 
  commentId: string, 
  isFirstComment: boolean = false
): Promise<number> {
  const points = isFirstComment ? 8 : 3; // 기본 3점 + 첫 댓글 5점
  const description = isFirstComment ? '첫 번째 댓글 작성' : '댓글 작성';
  
  return await awardPointsForAction(
    profile_uid,
    isFirstComment ? 'first_comment' : 'comment',
    points,
    description,
    commentId
  );
}

/**
 * 좋아요 받은 포인트 지급
 */
export async function awardPointsForLike(profile_uid: string, articleId: string): Promise<number> {
  return await awardPointsForAction(
    profile_uid,
    'like_received',
    1,
    '좋아요 받음',
    articleId
  );
}

/**
 * 소원 작성 포인트 지급
 */
export async function awardPointsForWish(profile_uid: string, points: number): Promise<number> {
  return await awardPointsForAction(
    profile_uid,
    'wish',
    points,
    `소원 작성 (연속 ${points - 5}일차)`,
  );
} 