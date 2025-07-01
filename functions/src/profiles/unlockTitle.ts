import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { CloudFunctionResponse, TitleInfo } from '../utils/types';
import { verifyAuth } from '../utils/auth';

const db = admin.firestore();

export interface UnlockTitleRequest {
  titleId: string;
  titleName: string;
  titleDescription?: string;
  condition: string;
}

/**
 * 칭호 해금
 */
export const unlockTitle = onRequest({
  cors: true,
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
    
    const { titleId, titleName, titleDescription, condition } = req.body as UnlockTitleRequest;

    // 입력값 검증
    if (!titleId || !titleName || !condition) {
      res.status(400).json({ success: false, error: '필수 정보가 누락되었습니다.' });
      return;
    }

    const profileRef = db.collection('profile').doc(uid);
    const titleRef = profileRef.collection('titles').doc(titleId);

    // 이미 해금된 칭호인지 확인
    const titleDoc = await titleRef.get();
    if (titleDoc.exists) {
      res.status(409).json({ success: false, error: '이미 해금된 칭호입니다.' });
      return;
    }

    // 칭호 정보 생성
    const titleInfo: TitleInfo = {
      id: titleId,
      name: titleName,
      description: titleDescription || '',
      condition,
      unlockedAt: admin.firestore.Timestamp.now(),
    };

    // 칭호 해금
    await titleRef.set(titleInfo);

    const response: CloudFunctionResponse = {
      success: true,
      message: `새로운 칭호 "${titleName}"를 해금했습니다!`,
      data: titleInfo,
    };

    res.status(200).json(response);

  } catch (error: any) {
    console.error('칭호 해금 중 오류 발생:', error);
    
    const response: CloudFunctionResponse = {
      success: false,
      message: error.message || '칭호 해금에 실패했습니다.',
    };

    res.status(500).json(response);
  }
}); 