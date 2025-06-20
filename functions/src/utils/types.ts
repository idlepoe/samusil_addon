import * as admin from 'firebase-admin';

// Article 관련 타입
export interface ArticleContent {
  isPicture: boolean;
  isOriginal?: boolean;
  contents: string;
  isBold?: boolean;
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
  coin_balance?: CoinBalance[];
}

// Coin 관련 타입
export interface Price {
  price: number;
  last_updated: string;
}

export interface CoinPrice {
  id: string;
  price: number;
  volume_24h: number;
  last_updated: string;
}

export interface CoinBalance {
  symbol: string;
  quantity: number;
  price: number;
  sub_list?: CoinBalance[];
}

export interface Coin {
  id: string;
  name: string;
  symbol: string;
  rank: number;
  is_active: boolean;
  current_price: number;
  current_volume_24h: number;
  last_updated: admin.firestore.Timestamp;
  diffPercentage?: number;
  diffList?: number[];
  color?: number;
}

export interface PriceHistory {
  price: number;
  volume_24h: number;
  timestamp: admin.firestore.Timestamp;
}

// Alarm 관련 타입
export interface Alarm {
  key: string;
  my_contents: string;
  is_read: boolean;
  target_article_key: string;
  target_contents: string;
  target_info: string;
  target_key_type: number;
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