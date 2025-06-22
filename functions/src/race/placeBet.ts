import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { CloudFunctionResponse } from '../utils/types';
import { addPoint } from '../utils/pointService';

const db = admin.firestore();

export const placeBet = functions
  .region('asia-northeast3')
  .https.onCall(async (data, context): Promise<CloudFunctionResponse> => {
    try {
      if (!context.auth) {
        return { success: false, message: '인증이 필요합니다.' };
      }

      const { raceId, horseId, betType, amount } = data;
      const uid = context.auth.uid;

      if (!raceId || !horseId || !betType || !amount) {
        return { success: false, message: '필수 정보가 누락되었습니다.' };
      }

      const raceRef = db.collection('horse_races').doc(raceId);
      const profileRef = db.collection('profile').doc(uid);

      let raceData;
      let userPoint = 0;

      await db.runTransaction(async (transaction) => {
        const raceDoc = await transaction.get(raceRef);
        const profileDoc = await transaction.get(profileRef);

        if (!raceDoc.exists) {
          throw new Error('경마 정보를 찾을 수 없습니다.');
        }
        if (!profileDoc.exists) {
          throw new Error('프로필 정보를 찾을 수 없습니다.');
        }
        
        raceData = raceDoc.data()!;
        userPoint = profileDoc.data()!.point;

        // 베팅 시간 확인
        if (new Date() > raceData.bettingEndTime.toDate()) {
          throw new Error('베팅 시간이 종료되었습니다.');
        }

        // 포인트 확인
        if (userPoint < amount) {
          throw new Error('포인트가 부족합니다.');
        }

        // 포인트 차감
        transaction.update(profileRef, { point: admin.firestore.FieldValue.increment(-amount) });

        // 베팅 기록
        const betRef = raceRef.collection('bets').doc(uid); // 1인 1베팅
        transaction.set(betRef, {
          userId: uid,
          userName: profileDoc.data()!.name,
          raceId,
          horseId,
          betType,
          amount,
          betTime: admin.firestore.Timestamp.now(),
          isWon: false,
          wonAmount: 0,
        });
      });

      return { success: true, message: '베팅에 성공했습니다.' };

    } catch (error: any) {
      console.error('베팅 처리 중 오류 발생:', error);
      return { success: false, message: error.message || '베팅 중 오류가 발생했습니다.' };
    }
  }); 