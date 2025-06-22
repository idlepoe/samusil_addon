import * as admin from 'firebase-admin';
import { PointAction, PointHistory } from './types';

const db = admin.firestore();

/**
 * 사용자에게 포인트를 지급하고 히스토리를 기록합니다.
 * @param {string} uid 사용자 ID
 * @param {number} amount 지급할 포인트 양
 * @param {string} reason 지급 사유
 */
export async function addPoint(uid: string, amount: number, reason: string): Promise<number> {
  try {
    if (!uid || !amount || !reason) {
      throw new Error('포인트 지급에 필요한 정보가 부족합니다.');
    }

    const profileRef = db.collection('profile').doc(uid);
    const pointHistoryRef = profileRef.collection('point_history').doc();

    await db.runTransaction(async (transaction) => {
      const profileDoc = await transaction.get(profileRef);
      if (!profileDoc.exists) {
        throw new Error('프로필을 찾을 수 없습니다.');
      }

      const currentPoint = profileDoc.data()?.point || 0;
      const newPoint = currentPoint + amount;

      // 포인트 업데이트
      transaction.update(profileRef, { point: newPoint });

      // 포인트 히스토리 기록
      transaction.set(pointHistoryRef, {
        id: pointHistoryRef.id,
        amount,
        reason,
        created_at: admin.firestore.Timestamp.now(),
      });
    });

    const updatedProfile = await profileRef.get();
    const finalPoint = updatedProfile.data()?.point || 0;
    
    console.log(`포인트 지급 완료: ${uid}, ${amount}P, 사유: ${reason}, 최종 포인트: ${finalPoint}`);
    return finalPoint;

  } catch (error) {
    console.error('포인트 지급 중 오류 발생:', error);
    throw error;
  }
}

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
      created_at: admin.firestore.Timestamp.now(),
    };

    // related_id가 있는 경우에만 추가
    if (related_id) {
      pointHistoryData.related_id = related_id;
    }

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
export async function awardPointsForArticle(authorUid: string, articleId: string): Promise<number> {
  return await addPoint(authorUid, 10, '게시글 작성');
}

/**
 * 댓글 작성 포인트 지급
 */
export async function awardPointsForComment(commenterUid: string, commentId: string, isFirstComment: boolean): Promise<number> {
  const points = isFirstComment ? 8 : 3;
  const reason = isFirstComment ? '첫 댓글 작성' : '댓글 작성';
  return await addPoint(commenterUid, points, reason);
}

/**
 * 좋아요 받은 포인트 지급
 */
export async function awardPointsForLike(authorUid: string, articleId: string): Promise<number> {
  return await addPoint(authorUid, 1, '좋아요 받음');
}

/**
 * 소원 작성 포인트 지급
 */
export async function awardPointsForWish(profile_uid: string, points: number): Promise<number> {
  return await awardPointsForAction(
    profile_uid,
    'wish',
    points,
    `소원 작성 (연속 ${Math.floor(points / 5)}일차)`,
    undefined // related_id는 소원 작성시 필요하지 않음
  );
} 