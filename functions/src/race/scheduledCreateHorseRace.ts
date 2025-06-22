import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { getTopCoins } from '../utils/coinGeckoApi';

const db = admin.firestore();

// 매시 0분, 30분에 경마 생성
export const scheduledCreateHorseRace = functions
  .region('asia-northeast3')
  .pubsub.schedule('0,30 * * * *')
  .timeZone('Asia/Seoul')
  .onRun(async (context) => {
    try {
      console.log('경마 생성 스케줄 실행');

      const now = new Date();
      
      // 경주 시작 및 종료 시간 설정
      const bettingStartTime = now;
      const bettingEndTime = new Date(now.getTime() + 10 * 60 * 1000); // 10분 후
      const raceStartTime = new Date(bettingEndTime.getTime() + 30 * 1000); // 베팅 종료 30초 후 시작
      const raceEndTime = new Date(raceStartTime.getTime() + 19 * 60 * 1000); // 19분 후로 변경

      // 중복 생성 방지
      const existingRace = await db.collection('horse_races')
        .where('startTime', '==', admin.firestore.Timestamp.fromDate(raceStartTime))
        .get();

      if (!existingRace.empty) {
        console.log('이미 해당 시간의 경마가 존재합니다.');
        return;
      }

      // 유명 코인 목록 가져오기 (상위 6개)
      const coins = await getTopCoins(6);
      if (coins.length === 0) {
        console.error('코인 정보를 가져오지 못했습니다.');
        return;
      }

      // 말 생성
      const horses = coins.map((coin) => ({
        coinId: coin.id,
        name: coin.name,
        symbol: coin.symbol.toUpperCase(),
        image: coin.image,
        currentPosition: 0.0,
        movements: [],
        lastPrice: coin.current_price,
        previousPrice: coin.current_price,
        rank: 0,
      }));

      // 경마 문서 생성
      const raceRef = db.collection('horse_races').doc();
      const race = {
        id: raceRef.id,
        bettingStartTime: admin.firestore.Timestamp.fromDate(bettingStartTime),
        bettingEndTime: admin.firestore.Timestamp.fromDate(bettingEndTime),
        startTime: admin.firestore.Timestamp.fromDate(raceStartTime),
        endTime: admin.firestore.Timestamp.fromDate(raceEndTime),
        horses: horses,
        isActive: false,
        isFinished: false,
        currentRound: 0,
        totalRounds: 19, // 19 라운드로 변경
      };

      await raceRef.set(race);
      console.log(`새로운 경마 생성 완료: ${race.id}`);

      // main_stadium 업데이트
      const stadiumRef = db.collection('horse_race_stadiums').doc('main_stadium');
      await stadiumRef.set(race);
      console.log('main_stadium 업데이트 완료');

    } catch (error) {
      console.error('경마 생성 중 오류 발생:', error);
    }
  }); 