import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { CloudFunctionResponse } from '../utils/types';
import { sendPushNotification } from '../utils/notificationService';

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

      let horseName = '';

      await db.runTransaction(async (transaction) => {
        const raceDoc = await transaction.get(raceRef);
        const profileDoc = await transaction.get(profileRef);

        if (!raceDoc.exists) { throw new Error('경마 정보를 찾을 수 없습니다.'); }
        if (!profileDoc.exists) { throw new Error('프로필 정보를 찾을 수 없습니다.'); }
        
        const raceData = raceDoc.data()!;
        const userPoint = profileDoc.data()!.point;

        const horseToBetOn = raceData.horses.find((h: any) => h.coinId === horseId);
        if (!horseToBetOn) { throw new Error('선택한 말을 찾을 수 없습니다.'); }
        horseName = horseToBetOn.name;

        if (new Date() > raceData.bettingEndTime.toDate()) { throw new Error('베팅 시간이 종료되었습니다.'); }
        if (userPoint < amount) { throw new Error('포인트가 부족합니다.'); }

        transaction.update(profileRef, { point: admin.firestore.FieldValue.increment(-amount) });

        const betRef = raceRef.collection('bets').doc(uid);
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

      // 트랜잭션 성공 후 알림 발송
      const betTypeMap: { [key: string]: string } = {
        winner: '1등 맞추기',
        top2: '2등 안에 맞추기',
        top3: '3등 안에 맞추기',
      };
      const title = '베팅 완료 알림';
      const body = `'${horseName}'에게 ${betTypeMap[betType]}으로 ${amount}P 베팅을 완료했습니다. 행운을 빌어요!`;
      
      await sendPushNotification(uid, title, body);

      return { success: true, message: '베팅에 성공했습니다.' };

    } catch (error: any) {
      console.error('베팅 처리 중 오류 발생:', error);
      return { success: false, message: error.message || '베팅 중 오류가 발생했습니다.' };
    }
  }); 