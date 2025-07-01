import { onRequest } from 'firebase-functions/v2/https';
import * as admin from 'firebase-admin';
import { CloudFunctionResponse } from '../utils/types';
import { verifyAuth } from '../utils/auth';

const db = admin.firestore();

export interface SetSelectedTitleRequest {
  titleId: string | null; // null이면 칭호 해제
}

/**
 * 대표 칭호 설정/해제
 */
export const setSelectedTitle = onRequest({
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
    
    const { titleId } = req.body as SetSelectedTitleRequest;

    const profileRef = db.collection('profile').doc(uid);

    // titleId가 null이 아닌 경우 보유한 칭호인지 확인
    if (titleId) {
      const titleRef = profileRef.collection('titles').doc(titleId);
      const titleDoc = await titleRef.get();
      
      if (!titleDoc.exists) {
        res.status(404).json({ success: false, error: '보유하지 않은 칭호입니다.' });
        return;
      }
    }

    // 대표 칭호 설정/해제
    await profileRef.update({
      selectedTitleId: titleId,
    });

    const response: CloudFunctionResponse = {
      success: true,
      message: titleId ? '대표 칭호가 설정되었습니다.' : '대표 칭호가 해제되었습니다.',
      data: {
        selectedTitleId: titleId,
      },
    };

    res.status(200).json(response);

  } catch (error: any) {
    console.error('대표 칭호 설정 중 오류 발생:', error);
    
    const response: CloudFunctionResponse = {
      success: false,
      message: error.message || '대표 칭호 설정에 실패했습니다.',
    };

    res.status(500).json(response);
  }
}); 