import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { CloudFunctionResponse } from './types';
import { verifyAuth } from './auth';

const db = admin.firestore();

export interface UpdatePointsRequest {
  pointsChange: number; // 양수: 증가, 음수: 감소
  actionType: string;
  description?: string;
  metadata?: Record<string, any>;
}

/**
 * 포인트 증감 공통 처리 함수
 */
export const updatePoints = onRequest({
  cors: true,
  region: 'asia-northeast3',
}, async (req, res) => {
  try {
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }
    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;
    
    const { pointsChange, actionType, description, metadata } = req.body as UpdatePointsRequest;

    // 입력값 검증
    if (pointsChange === undefined || pointsChange === null || !actionType) {
      res.status(400).json({ 
        success: false, 
        error: '포인트 변경량과 액션 타입은 필수입니다.' 
      });
      return;
    }

    const profileRef = db.collection('profile').doc(uid);
    const pointHistoryRef = profileRef.collection('point_history').doc();

    const result = await db.runTransaction(async (transaction) => {
      // 현재 프로필 정보 가져오기
      const profileDoc = await transaction.get(profileRef);
      
      if (!profileDoc.exists) {
        throw new Error('프로필을 찾을 수 없습니다.');
      }

      const currentPoints = profileDoc.data()?.point || 0;
      const newPoints = currentPoints + pointsChange;

      // 포인트가 음수가 되는 것을 방지 (감소 시에만)
      if (newPoints < 0) {
        throw new Error(`포인트가 부족합니다. (현재: ${currentPoints}P, 요청: ${pointsChange}P)`);
      }

      // 프로필 포인트 업데이트
      transaction.update(profileRef, { point: newPoints });

      // 포인트 히스토리 기록
      const pointHistoryData = {
        id: pointHistoryRef.id,
        profile_uid: uid,
        action_type: actionType,
        points_earned: pointsChange, // 양수/음수 그대로 기록
        description: description || `${actionType} 처리`,
        created_at: admin.firestore.Timestamp.now(),
        ...(metadata && { metadata }), // metadata가 있으면 추가
      };

      transaction.set(pointHistoryRef, pointHistoryData);

      return {
        previousPoints: currentPoints,
        newPoints: newPoints,
        pointsChange: pointsChange,
      };
    });

    const response: CloudFunctionResponse = {
      success: true,
      message: `포인트 ${pointsChange > 0 ? '증가' : '감소'}: ${Math.abs(pointsChange)}P`,
      data: {
        pointsChange: result.pointsChange,
        previousPoints: result.previousPoints,
        newPoints: result.newPoints,
        actionType: actionType,
        description: description,
        metadata: metadata,
      },
    };

    res.status(200).json(response);

  } catch (error: any) {
    console.error('포인트 업데이트 중 오류 발생:', error);
    
    const response: CloudFunctionResponse = {
      success: false,
      message: error.message || '포인트 업데이트에 실패했습니다.',
    };

    res.status(500).json(response);
  }
});

/**
 * 내부 함수: 다른 Cloud Functions에서 사용할 수 있는 포인트 업데이트 함수
 */
export async function updatePointsInternal(
  uid: string,
  pointsChange: number,
  actionType: string,
  description?: string,
  metadata?: Record<string, any>
): Promise<{ success: boolean; newPoints: number; error?: string }> {
  try {
    const profileRef = db.collection('profile').doc(uid);
    const pointHistoryRef = profileRef.collection('point_history').doc();

    const result = await db.runTransaction(async (transaction) => {
      const profileDoc = await transaction.get(profileRef);
      
      if (!profileDoc.exists) {
        throw new Error('프로필을 찾을 수 없습니다.');
      }

      const currentPoints = profileDoc.data()?.point || 0;
      const newPoints = currentPoints + pointsChange;

      if (newPoints < 0) {
        throw new Error(`포인트가 부족합니다. (현재: ${currentPoints}P, 요청: ${pointsChange}P)`);
      }

      transaction.update(profileRef, { point: newPoints });

      const pointHistoryData = {
        id: pointHistoryRef.id,
        profile_uid: uid,
        action_type: actionType,
        points_earned: pointsChange,
        description: description || `${actionType} 처리`,
        created_at: admin.firestore.Timestamp.now(),
        ...(metadata && { metadata }),
      };

      transaction.set(pointHistoryRef, pointHistoryData);

      return newPoints;
    });

    console.log(`포인트 업데이트 성공: ${uid}, ${pointsChange}P, 새 포인트: ${result}`);
    return { success: true, newPoints: result };

  } catch (error: any) {
    console.error('포인트 업데이트 중 오류 발생:', error);
    return { success: false, newPoints: 0, error: error.message };
  }
} 