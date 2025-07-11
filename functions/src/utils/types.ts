import * as admin from 'firebase-admin';

// Article 관련 타입
export interface ArticleContent {
  isPicture: boolean;
  contents: string;
}

export interface MainComment {
  key: string;
  contents: string;
  profile_key: string;
  profile_name: string;
  created_at: admin.firestore.Timestamp;
  is_sub: boolean;
  parents_key: string;
}

export interface Article {
  key: string;
  board_name: string;
  profile_key: string;
  profile_name: string;
  count_view: number;
  count_like: number;
  count_unlike: number;
  title: string;
  contents: ArticleContent[];
  created_at: admin.firestore.Timestamp;
  comments: MainComment[];
  is_notice: boolean;
  thumbnail?: string;
  count_comments: number;
}

// Profile 관련 타입
export interface Profile {
  key: string;
  name: string;
  point: number;
  liked_track_articles?: string[]; // 좋아요한 플레이리스트 ID 목록
}



export interface PriceHistory {
  price: number;
  volume_24h: number;
  timestamp: admin.firestore.Timestamp;
}

// Board 관련 타입
export interface BoardInfo {
  board_name: string;
  title: string;
  isPopular?: boolean;
  isNotice?: boolean;
}

// API 응답 타입
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PointHistory {
  id?: string;
  profile_uid: string;
  action_type: '소원' | '게시글' | '댓글' | '첫댓글' | '대댓글' | '좋아요받음' | '베팅' | '플레이리스트' | '아바타구매' | '물고기판매' | '아트워크구매';
  points_earned: number;
  description: string;
  related_id?: string; // 게시글 ID, 댓글 ID 등
  created_at: admin.firestore.Timestamp;
}

export interface PointAction {
  profile_uid: string;
  action_type: PointHistory['action_type'];
  points_earned: number;
  description: string;
  related_id?: string;
}

/**
 * Cloud Function의 표준 응답 형식입니다.
 */
export interface CloudFunctionResponse {
  success: boolean;
  message?: string;
  data?: any;
}

/**
 * 사용자 프로필 정보를 나타냅니다.
 */
export interface UserProfile {
  uid: string;
  name: string;
  photo_url: string;
  point: number;
  one_comment: string;
}

// Track Article 관련 타입
export interface Track {
  id: string;
  videoId: string;
  title: string;
  description: string;
  thumbnail: string;
  duration: string;
}

export interface TrackArticle {
  id?: string;
  profile_uid: string;
  profile_name: string;
  profile_photo_url: string;
  count_view: number;
  count_like: number;
  count_unlike: number;
  count_comments: number;
  title: string;
  tracks: Track[];
  created_at: admin.firestore.Timestamp;
  updated_at?: admin.firestore.Timestamp;
  profile_point?: number;
  comments?: MainComment[];
  total_duration: number; // 총 재생시간 (초)
  track_count: number; // 트랙 개수
  description: string; // 플레이리스트 설명
}

// 물고기 관련 타입
export interface FishInventory {
  fishId: string;
  fishName: string;
  caughtCount: number; // 총 잡은 횟수
  currentCount: number; // 현재 보유 수량
  lastCaughtAt: admin.firestore.Timestamp;
}

export interface SellFishRequest {
  fishId: string;
  fishName: string;
  sellCount: number;
  pointPerFish: number;
}

// 칭호 관련 타입
export interface TitleInfo {
  id: string;
  name: string;
  description: string;
  condition: string;
  unlockedAt: admin.firestore.Timestamp;
} 