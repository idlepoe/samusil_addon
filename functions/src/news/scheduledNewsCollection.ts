import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as admin from 'firebase-admin';
import { JSDOM } from 'jsdom';

const FIRESTORE_COLLECTION_ARTICLE = 'article';

interface ArticleContent {
  isPicture: boolean;
  contents: string;
  isOriginal?: boolean;
  isBold?: boolean;
}

interface MainComment {
  key: string;
  contents: string;
  profile_key: string;
  profile_name: string;
  created_at: admin.firestore.Timestamp;
  is_sub: boolean;
  parents_key: string;
}

interface Article {
  key: string;
  board_name: string;
  profile_key: string;
  profile_name: string;
  title: string;
  contents: ArticleContent[];
  count_like: number;
  count_unlike: number;
  count_view: number;
  count_comments: number;
  is_notice: boolean;
  created_at: admin.firestore.Timestamp;
  comments: MainComment[];
  thumbnail?: string;
  last_updated: admin.firestore.Timestamp;
  timestamp: admin.firestore.Timestamp;
}

// 한국시간을 Firebase Timestamp로 변환하는 함수
function getKoreanTimestamp(): admin.firestore.Timestamp {
  // asia-northeast3 리전에서 실행되므로 이미 한국시간이 적용되어 있음
  return admin.firestore.Timestamp.now();
}

export { collectGameNews, fetchAndParseGameNews };

// 공통 게임뉴스 크롤링 함수
async function fetchAndParseGameNews(db: admin.firestore.Firestore) {
  try {
    console.log('게임메카 뉴스 크롤링 시작');
    // 기존 게임 뉴스 목록 가져오기 (중복 체크용)
    const existingArticles = await db.collection(FIRESTORE_COLLECTION_ARTICLE)
      .where('board_name', '==', 'game_news')
      .limit(100)
      .get();
    const existingTitles = existingArticles.docs.map(doc => doc.data().title);
    // 1. 뉴스 리스트 페이지에서 제목/상세링크 추출
    const response = await fetch('https://www.gamemeca.com/news.php');
    if (!response.ok) {
      console.error('Failed to fetch game news from Gamemeca');
      return;
    }
    const html = await response.text();
    // <a href="/view.php?gid=1762750">제목</a> 패턴 추출
    const listPattern = /<a href="(\/view\.php\?gid=\d+)">([^<]+)<\/a>/g;
    const matches = [...html.matchAll(listPattern)];
    console.log(`게임메카 리스트에서 ${matches.length}개 뉴스 추출됨`);
    const newsKey = Date.now().toString();
    // 한국시간으로 Firebase Timestamp 생성
    const currentTimestamp = getKoreanTimestamp();
    let index = 0;
    for (const match of matches.slice(0, 10)) {
      const detailUrl = "https://www.gamemeca.com" + match[1];
      const title = match[2].trim();
      if (!title || existingTitles.includes(title)) continue;
      console.log(`[${index}] 제목: ${title}, 상세링크: ${detailUrl}`);
      // 2. 상세 페이지에서 본문/이미지/설명 등 contents 추출
      let contents: ArticleContent[] = [];
      try {
        const detailRes = await fetch(detailUrl);
        if (detailRes.ok) {
          const detailHtml = await detailRes.text();
          console.log(`[${index}] 상세페이지 HTML:`, detailHtml);
          
          // JSDOM에서 .article을 바로 찾음
          const dom = new JSDOM(detailHtml);
          const articleDiv = dom.window.document.querySelector('.article');
          console.log(`[${index}] articleDiv 존재 여부:`, !!articleDiv);
          if (articleDiv) {
            console.log(`[${index}] articleDiv innerHTML 길이:`, articleDiv.innerHTML.length);
            console.log(`[${index}] articleDiv children 개수:`, articleDiv.children.length);
            // article div 바로 안에 있는 직계 자식 div들만 순회
            const topLevelDivs = Array.from(articleDiv.children).filter(child => child.tagName === 'DIV');
            console.log(`[${index}] 최상위 div 개수:`, topLevelDivs.length);
            for (let i = 0; i < topLevelDivs.length; i++) {
              const div = topLevelDivs[i];
              const text = div.textContent?.replace(/\s+/g, ' ').trim();
              const img = div.querySelector('img');
              if (img) {
                const src = img.getAttribute('src');
                if (src) {
                  contents.push({ isPicture: true, contents: src });
                  console.log(`[${index}] div ${i} 이미지:`, src);
                }
              }
              if (text && text.length > 10) {
                contents.push({ isPicture: false, contents: text });
                console.log(`[${index}] div ${i} 텍스트:`, text.substring(0, 100));
              }
            }
            console.log(`[${index}] 최종 파싱 결과:`, contents);
          } else {
            console.log(`[${index}] articleDiv를 찾지 못함`);
          }
        }
      } catch (e) { console.log(`[${index}] 상세페이지 파싱 오류`, e); }
      if (contents.length === 0) {
        contents.push({ isPicture: false, contents: "게임메카에서 수집된 뉴스입니다." });
        console.log(`[${index}] 본문/이미지 없음, 기본 안내문 저장`);
      }
      const article: Article = {
        key: (parseInt(newsKey) + index).toString(),
        board_name: 'game_news',
        profile_key: "00000000000000000",
        profile_name: "게임뉴스봇",
        title: title,
        contents: contents,
        count_like: 0,
        count_unlike: 0,
        count_view: 0,
        count_comments: 0,
        is_notice: false,
        created_at: currentTimestamp,
        comments: [],
        last_updated: currentTimestamp,
        timestamp: currentTimestamp,
      };
      await db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(article.key).set(article);
      index++;
    }
    console.log(`Game news collection completed: ${index} articles added`);
  } catch (error) {
    console.error('Error collecting game news:', error);
  }
}

// 게임 뉴스 수집 함수 (공통 함수만 호출)
async function collectGameNews(db: admin.firestore.Firestore) {
  await fetchAndParseGameNews(db);
}

// 게임뉴스만 스케줄링
export const scheduledGameNewsCollection = onSchedule(
  { 
    schedule: 'every 60 minutes',
    region: 'asia-northeast3'
  },
  async (event) => {
    try {
      console.log('Starting scheduled game news collection...');
      if (!admin.apps.length) {
        admin.initializeApp();
      }
      const db = admin.firestore();
      db.settings({ ignoreUndefinedProperties: true });
      await collectGameNews(db);
      console.log('Scheduled game news collection completed successfully');
    } catch (error) {
      console.error('Error in scheduled game news collection:', error);
    }
  }
);

