import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { addPoint } from '../utils/pointService';
import { sendPushNotification } from '../utils/notificationService';

const db = admin.firestore();

// 1분마다 경마 상태 업데이트
export const scheduledUpdateHorseRace = functions
  .region('asia-northeast3')
  .pubsub.schedule('* * * * *')
  .timeZone('Asia/Seoul')
  .onRun(async (context) => {
    try {
      console.log('경마 업데이트 스케줄 실행');
      const now = new Date();
      const nowTimestamp = admin.firestore.Timestamp.fromDate(now);

      // 시작 시간이 된 경마를 활성화
      const racesToStartQuery = db.collection('horse_races')
        .where('isActive', '==', false)
        .where('isFinished', '==', false)
        .where('startTime', '<=', nowTimestamp);
      
      const racesToStart = await racesToStartQuery.get();
      for (const doc of racesToStart.docs) {
        await doc.ref.update({ isActive: true });
        // main_stadium 업데이트
        const stadiumRef = db.collection('horse_race_stadiums').doc('main_stadium');
        await stadiumRef.update({ isActive: true });
        console.log(`경마 시작: ${doc.id}`);
      }

      // 현재 진행 중인 경마 가져오기
      const activeRaceQuery = db.collection('horse_races')
        .where('isActive', '==', true)
        .where('isFinished', '==', false);
      
      const activeRaces = await activeRaceQuery.get();
      if (activeRaces.empty) {
        console.log('진행 중인 경마 없음');
        return;
      }

      for (const doc of activeRaces.docs) {
        const race = doc.data();

        // 경마 종료 시간이 지났으면 결과 처리
        if (nowTimestamp >= race.endTime) {
          await finishRace(doc.ref, race);
          continue;
        }

        // 말 위치를 임의의 데이터로 업데이트
        const updatedHorses = race.horses.map((horse: any) => {
          
          // 레이스 총 거리를 1.0으로 보고, 이번 라운드의 평균 이동 거리를 계산
          const averageMovement = 1.0 / race.totalRounds;

          // 평균 이동 거리의 50% ~ 150% 사이의 임의의 값을 생성
          const randomMovement = averageMovement * (0.5 + Math.random());

          const newPosition = horse.currentPosition + randomMovement;

          return {
            ...horse,
            currentPosition: newPosition,
            // lastPrice, previousPrice는 더 이상 업데이트하지 않음
            movements: [...horse.movements, randomMovement],
          };
        });

        await doc.ref.update({
          horses: updatedHorses,
          currentRound: admin.firestore.FieldValue.increment(1),
        });
        // main_stadium 업데이트
        const stadiumRef = db.collection('horse_race_stadiums').doc('main_stadium');
        await stadiumRef.update({
          horses: updatedHorses,
          currentRound: admin.firestore.FieldValue.increment(1),
        });
        console.log(`경마 업데이트: ${doc.id}, 라운드: ${race.currentRound + 1}`);
      }

    } catch (error) {
      console.error('경마 업데이트 중 오류 발생:', error);
    }
  });

async function finishRace(raceRef: admin.firestore.DocumentReference, race: any) {
  console.log(`경마 종료 및 결과 처리 시작: ${raceRef.id}`);

  // 최종 순위 결정
  const sortedHorses = [...race.horses].sort((a: any, b: any) => b.currentPosition - a.currentPosition);
  const finalHorses = sortedHorses.map((horse: any, index: number) => ({
    ...horse,
    rank: index + 1,
  }));

  // 베팅 결과 처리
  const betsSnapshot = await raceRef.collection('bets').get();
  for (const betDoc of betsSnapshot.docs) {
    const bet = betDoc.data();
    const selectedHorse = finalHorses.find((h: any) => h.coinId === bet.horseId);
    
    if (!selectedHorse) continue;

    let isWon = false;
    let wonAmount = 0;
    const rank = selectedHorse.rank;

    if (bet.betType === 'winner' && rank === 1) {
      isWon = true;
    } else if (bet.betType === 'top2' && rank <= 2) {
      isWon = true;
    } else if (bet.betType === 'top3' && rank <= 3) {
      isWon = true;
    }

    const title = '코인 경마 결과 알림';
    let body = '';

    if (isWon) {
      const multipliers = { winner: 5, top2: 2, top3: 1.5 };
      wonAmount = bet.amount * (multipliers[bet.betType as keyof typeof multipliers] || 1);
      
      // 포인트 지급
      await addPoint(bet.userId, wonAmount, '코인 경마 우승');
      
      await betDoc.ref.update({ isWon: true, wonAmount: wonAmount });

      body = `축하합니다! 베팅에 성공하여 ${wonAmount}P를 획득했습니다!`;
    } else {
      body = `아쉽지만 베팅에 실패했습니다. 다음 경마를 기대해주세요!`;
    }

    // 사용자에게 푸시 알림 발송 및 기록 저장
    if (bet.userId) {
      await sendPushNotification(bet.userId, title, body);
    }
  }

  // 최종 경주 데이터 객체 생성
  const finalRaceData = {
    ...race,
    horses: finalHorses,
    isActive: false,
    isFinished: true,
  };

  // 1. race_histories에 결과 저장
  await db.collection('race_histories').doc(raceRef.id).set(finalRaceData);
  console.log(`경마 기록 저장 완료: ${raceRef.id}`);

  // 2. 기존 경주 문서 상태 업데이트
  await raceRef.update({
    isActive: false,
    isFinished: true,
  });

  // 3. main_stadium 비우기 (조건부 실행)
  const stadiumRef = db.collection('horse_race_stadiums').doc('main_stadium');
  const stadiumDoc = await stadiumRef.get();

  // 현재 경기장에 있는 경주가 지금 막 종료시킨 경주와 동일할 때만 경기장을 비운다.
  if (stadiumDoc.exists && stadiumDoc.data()?.id === raceRef.id) {
    await stadiumRef.set({
      id: null,
      isFinished: true,
      isActive: false,
      horses: [],
      bettingStartTime: null,
      bettingEndTime: null,
      startTime: null,
      endTime: null,
      currentRound: 0,
      totalRounds: 0,
    });
    console.log(`경기장 비우기 완료: ${raceRef.id}`);
  } else {
    console.log(`현재 경기장이 다른 경주(${stadiumDoc.data()?.id})를 표시하고 있으므로, ${raceRef.id} 종료 시 비우지 않습니다.`);
  }
} 