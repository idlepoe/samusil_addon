import * as admin from 'firebase-admin';
import { onRequest } from 'firebase-functions/v2/https';
import { verifyAuth } from '../utils/auth';
import { TrackArticle } from '../utils/types';
import { FIRESTORE_COLLECTION_TRACK_ARTICLE } from '../utils/constants';

export const updateTrackArticle = onRequest({ 
  cors: true,
  region: 'asia-northeast3'
}, async (req, res) => {
  try {
    // OPTIONS 요청 처리
    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // POST 요청만 허용
    if (req.method !== 'POST') {
      res.status(405).json({ success: false, error: 'Method not allowed' });
      return;
    }

    // Firebase Auth 토큰 검증
    const decoded = await verifyAuth(req);
    const uid = decoded.uid;

    const { id, title, tracks, description } = req.body;

    if (!id) {
      res.status(400).json({ success: false, error: '트랙 아티클 ID가 필요합니다.' });
      return;
    }

    const db = admin.firestore();
    const trackArticleRef = db.collection(FIRESTORE_COLLECTION_TRACK_ARTICLE).doc(id);

    // 트랜잭션으로 업데이트 처리
    const result = await db.runTransaction(async (transaction) => {
      const trackArticleDoc = await transaction.get(trackArticleRef);
      
      if (!trackArticleDoc.exists) {
        throw new Error('존재하지 않는 플레이리스트입니다.');
      }

      const trackArticleData = trackArticleDoc.data() as TrackArticle;

      // 작성자 확인
      if (trackArticleData.profile_uid !== uid) {
        throw new Error('수정 권한이 없습니다.');
      }

      // 업데이트할 데이터 준비
      const updateData: Partial<TrackArticle> = {
        updated_at: admin.firestore.Timestamp.now(),
      };

      if (title !== undefined) {
        updateData.title = title;
      }

      if (tracks !== undefined) {
        updateData.tracks = tracks;
        updateData.track_count = tracks.length;
        updateData.total_duration = tracks.length * 180; // 평균 3분
      }

      if (description !== undefined) {
        updateData.description = description;
      }

      transaction.update(trackArticleRef, updateData);

      return {
        ...trackArticleData,
        ...updateData,
        id: id,
      };
    });

    res.status(200).json({
      success: true,
      message: '플레이리스트가 성공적으로 수정되었습니다.',
      data: result,
    });

  } catch (error) {
    console.error('updateTrackArticle 오류:', error);
    
    if (
      error instanceof Error &&
      (error.message.includes('authorization') || error.message.includes('token'))
    ) {
      res.status(401).json({ success: false, error: 'Authentication failed' });
    } else {
      const message = error instanceof Error ? error.message : '플레이리스트 수정 중 오류가 발생했습니다.';
      res.status(500).json({ success: false, error: message });
    }
  }
}); 