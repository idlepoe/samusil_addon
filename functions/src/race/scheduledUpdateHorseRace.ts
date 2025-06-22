import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { getCoinPrices } from '../utils/coinGeckoApi';
import { addPoint } from '../utils/pointService';

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

        // 말 위치 업데이트
        const coinIds = race.horses.map((h: any) => h.coinId);
        const prices = await getCoinPrices(coinIds);

        const updatedHorses = race.horses.map((horse: any) => {
          const newPrice = prices[horse.coinId]?.usd;
          if (newPrice === undefined) return horse;

          const movement = Math.abs((newPrice - horse.lastPrice) / horse.lastPrice) * 100;
          const newPosition = horse.currentPosition + movement;

          return {
            ...horse,
            currentPosition: newPosition,
            lastPrice: newPrice,
            movements: [...horse.movements, movement],
          };
        });

        await doc.ref.update({
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
    const selectedHorse = finalHorses.find((h: any) => h.coinId === bet.selectedHorseId);
    
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

    if (isWon) {
      const multipliers = { winner: 5, top2: 2, top3: 1.5 };
      wonAmount = bet.betAmount * (multipliers[bet.betType as keyof typeof multipliers] || 1);
      
      // 포인트 지급
      await addPoint(bet.userId, wonAmount, '코인 경마 우승');
      
      await betDoc.ref.update({ isWon: true, wonAmount: wonAmount });
    }
  }

  // 경마 상태 업데이트
  await raceRef.update({
    horses: finalHorses,
    isActive: false,
    isFinished: true,
  });

  console.log(`경마 결과 처리 완료: ${raceRef.id}`);
} 