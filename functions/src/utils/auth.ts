import * as admin from 'firebase-admin';
import { Request } from 'firebase-functions/v2/https';

export interface DecodedToken {
  uid: string;
  email?: string;
  [key: string]: any;
}

/**
 * Firebase Auth 토큰을 검증하고 디코딩된 정보를 반환
 * @param req HTTP 요청 객체
 * @returns 디코딩된 토큰 정보
 */
export async function verifyAuth(req: Request): Promise<DecodedToken> {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    throw new Error('No valid authorization header found');
  }

  const token = authHeader.split('Bearer ')[1];
  
  if (!token) {
    throw new Error('No token provided');
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    return decodedToken;
  } catch (error) {
    console.error('Token verification failed:', error);
    throw new Error('Invalid token');
  }
}

/**
 * 사용자 정보를 업데이트하거나 생성
 * @param uid 사용자 UID
 * @param userData 사용자 데이터
 */
export async function updateUserData(uid: string, userData: Record<string, any>): Promise<void> {
  const db = admin.firestore();
  const userRef = db.collection("users").doc(uid);
  const now = admin.firestore.Timestamp.now();

  const dataToUpdate = {
    ...userData,
    uid: uid,
    updatedAt: now,
  };

  await userRef.set(dataToUpdate, { merge: true });
} 