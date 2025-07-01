import { onRequest } from 'firebase-functions/v2/https';
import { performSeoulMuseumSync } from '../utils/seoulMuseumSync';

export const manualSeoulMuseumSync = onRequest({
  cors: true,
}, async (req, res) => {
  try {
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }
    if (req.method !== 'GET') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    console.log(`🎨 수동 서울시립미술관 동기화 시작`);

    // 동기화 함수 호출
    await performSeoulMuseumSync();

    res.status(200).json({
      success: true,
      message: '서울시립미술관 작품 동기화가 완료되었습니다.'
    });
  } catch (error: any) {
    console.error('수동 동기화 실패:', error);
    res.status(200).json({ 
      success: false, 
      error: error.message || '수동 동기화 처리 중 오류가 발생했습니다.' 
    });
  }
}); 