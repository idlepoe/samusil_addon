import { onCall } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { CloudFunctionResponse, PointHistory } from '../utils/types';
import { sendPushNotification } from '../utils/notificationService';

const db = admin.firestore();

export const placeBet = onCall(async (request): Promise<CloudFunctionResponse> => {
  try {
    if (!request.auth) {
      return { success: false, message: '인증이 필요합니다.' };
    }

    const { raceId, horseId, betType, amount } = request.data;
    const uid = request.auth.uid;

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

      // 포인트 차감 이력 기록 - PointHistory 인터페이스 구조 사용
      const pointHistoryRef = profileRef.collection('point_history').doc();
      const pointHistoryData: PointHistory = {
        id: pointHistoryRef.id,
        profile_uid: uid,
        action_type: '베팅',
        points_earned: -amount, // 차감이므로 음수
        description: '코인 경마 베팅',
        created_at: admin.firestore.Timestamp.now(),
      };
      
      transaction.set(pointHistoryRef, pointHistoryData);

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