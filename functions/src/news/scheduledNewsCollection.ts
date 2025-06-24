import { onSchedule } from 'firebase-functions/v2/scheduler';
import * as admin from 'firebase-admin';
import { JSDOM } from 'jsdom';

const FIRESTORE_COLLECTION_ARTICLE = 'article';

interface ArticleContent {
  isPicture: boolean;
  contents: string;
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
  thumbnail?: string;
  updated_at: admin.firestore.Timestamp;
  timestamp: admin.firestore.Timestamp;
}

// 한국시간을 Firebase Timestamp로 변환하는 함수
function getKoreanTimestamp(): admin.firestore.Timestamp {
  // asia-northeast3 리전에서 실행되므로 이미 한국시간이 적용되어 있음
  return admin.firestore.Timestamp.now();
}

export { collectGameNews, fetchAndParseGameNews, collectEntertainmentNews, fetchAndParseEntertainmentNews };

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
              
              // YouTube iframe 체크
              const iframe = div.querySelector('iframe[src*="youtube.com/embed"]');
              if (iframe) {
                const src = iframe.getAttribute('src');
                if (src) {
                  // YouTube 임베드 URL을 일반 YouTube URL로 변환
                  const youtubeUrl = src.replace('youtube.com/embed/', 'youtube.com/watch?v=');
                  contents.push({ isPicture: false, contents: `YouTube 영상: ${youtubeUrl}` });
                  console.log(`[${index}] div ${i} YouTube 영상:`, youtubeUrl);
                }
              }
              
              // 일반 이미지 체크
              const img = div.querySelector('img');
              if (img) {
                const src = img.getAttribute('src');
                if (src) {
                  contents.push({ isPicture: true, contents: src });
                  console.log(`[${index}] div ${i} 이미지:`, src);
                }
              }
              
              // 텍스트 내용 체크 (YouTube iframe이 없는 경우에만)
              if (text && text.length > 10 && !iframe) {
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
        updated_at: currentTimestamp,
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

// 연예뉴스 크롤링 함수
async function fetchAndParseEntertainmentNews(db: admin.firestore.Firestore) {
  try {
    console.log('머니투데이 연예뉴스 크롤링 시작');
    
    // 기존 연예뉴스 목록 가져오기 (중복 체크용)
    const existingArticles = await db.collection(FIRESTORE_COLLECTION_ARTICLE)
      .where('board_name', '==', 'entertainment_news')
      .limit(100)
      .get();
    const existingTitles = existingArticles.docs.map(doc => doc.data().title);

    // 1. 뉴스 리스트 페이지에서 제목/상세링크 추출 (EUC-KR 인코딩 처리)
    const response = await fetch('https://news.mt.co.kr/newsList.html?pDepth=enter&pDepth1=enter&pDepth2=Senter');
    if (!response.ok) {
      console.error('Failed to fetch entertainment news from MoneyToday');
      return;
    }
    
    // EUC-KR 인코딩을 UTF-8로 변환
    const buffer = await response.arrayBuffer();
    const decoder = new TextDecoder('euc-kr');
    const html = decoder.decode(buffer);
    console.log('머니투데이 연예뉴스 HTML 길이:', html.length);

    // JSDOM을 사용하여 HTML 파싱
    const dom = new JSDOM(html);
    const document = dom.window.document;

    // 1. 메인 뉴스 (secm_top에서 추출)
    const mainNews = document.querySelector('.secm_top h1 a');
    const mainNewsItems: { title: string; href: string }[] = [];
    if (mainNews) {
      const mainHref = mainNews.getAttribute('href');
      const mainTitle = mainNews.textContent?.trim();
      if (mainTitle && mainHref) {
        mainNewsItems.push({ title: mainTitle, href: mainHref });
      }
    }

    // 2. 리스트 뉴스 (ul.conlist_p1의 li.bundle에서 추출)
    const newsItems: { title: string; href: string }[] = [];
    const listItems = document.querySelectorAll('ul.conlist_p1 li.bundle');
    console.log(`머니투데이 연예뉴스 li.bundle 아이템 ${listItems.length}개 발견`);

    listItems.forEach(item => {
      const linkElement = item.querySelector('.con .subject a');
      if (linkElement) {
        const href = linkElement.getAttribute('href');
        const title = linkElement.textContent?.trim();
        if (title && href) {
          newsItems.push({ title, href });
        }
      }
    });

    // 메인 뉴스와 리스트 뉴스 합치기
    const allNewsItems = [...mainNewsItems, ...newsItems];
    console.log(`총 ${allNewsItems.length}개 뉴스 아이템 추출`);

    const newsKey = Date.now().toString();
    const currentTimestamp = getKoreanTimestamp();
    let index = 0;

    for (let i = 0; i < Math.min(allNewsItems.length, 10); i++) {
      const newsItem = allNewsItems[i];
      const { title, href } = newsItem;

      if (!title || !href || existingTitles.includes(title)) continue;

      const detailUrl = href.startsWith('http') ? href : `https://news.mt.co.kr${href}`;
      console.log(`[${index}] 제목: ${title}, 상세링크: ${detailUrl}`);

      // 2. 상세 페이지에서 본문 내용 추출
      let contents: ArticleContent[] = [];
      try {
        console.log(`[${index}] 상세 페이지 접근 시도: ${detailUrl}`);
        const detailRes = await fetch(detailUrl);
        console.log(`[${index}] 상세 페이지 응답 상태: ${detailRes.status} ${detailRes.statusText}`);
        
        if (detailRes.ok) {
          // EUC-KR 인코딩을 UTF-8로 변환
          const detailBuffer = await detailRes.arrayBuffer();
          const detailDecoder = new TextDecoder('euc-kr');
          const detailHtml = detailDecoder.decode(detailBuffer);
          console.log(`[${index}] 상세 페이지 HTML 길이: ${detailHtml.length}`);
          
          const detailDom = new JSDOM(detailHtml);
          const detailDoc = detailDom.window.document;

          // 머니투데이 기사 본문 선택자
          const contentSelectors = [
            '#textBody',           // 머니투데이 연예뉴스 본문 (주요)
            '.view_txt',           // 머니투데이 기본 본문
            '.news_text',
            '.article_text', 
            '.content_text',
            '#article_text',
            '.view_text',
            '.article_content'
          ];

          console.log(`[${index}] 본문 선택자 탐색 시작 (${contentSelectors.length}개)`);
          let articleContent = null;
          for (const selector of contentSelectors) {
            articleContent = detailDoc.querySelector(selector);
            if (articleContent) {
              console.log(`[${index}] 본문 선택자 발견: ${selector}`);
              break;
            } else {
              console.log(`[${index}] 선택자 ${selector} - 요소 없음`);
            }
          }
          
          if (!articleContent) {
            console.log(`[${index}] 모든 선택자 실패, 페이지 구조 분석 시작`);
            // 페이지의 주요 요소들 확인
            const bodyChildren = detailDoc.body?.children;
            if (bodyChildren) {
              console.log(`[${index}] body 하위 요소 ${bodyChildren.length}개:`);
              for (let i = 0; i < Math.min(bodyChildren.length, 5); i++) {
                const child = bodyChildren[i];
                console.log(`[${index}] - ${child.tagName}#${child.id || 'no-id'}.${child.className || 'no-class'}`);
              }
            }
          }

          if (articleContent) {
            console.log(`[${index}] 본문 요소 발견: ${articleContent.tagName}#${articleContent.id || 'no-id'}.${articleContent.className || 'no-class'}`);
            
            // 이미지 추출 (article_photo 테이블의 이미지들)
            const images = articleContent.querySelectorAll('img');
            console.log(`[${index}] 이미지 ${images.length}개 발견`);
            images.forEach((img, imgIndex) => {
              const src = img.getAttribute('src');
              if (src) {
                let fullSrc = src;
                if (src.startsWith('//')) {
                  fullSrc = `https:${src}`;
                } else if (!src.startsWith('http')) {
                  fullSrc = `https://news.mt.co.kr${src}`;
                }
                console.log(`[${index}] 이미지[${imgIndex}]: ${fullSrc}`);
                contents.push({ isPicture: true, contents: fullSrc });
              }
            });

            // #textBody의 경우 특별한 파싱 로직 적용
            if (articleContent.id === 'textBody') {
              console.log(`[${index}] #textBody 특별 파싱 시작`);
              
              // 광고 스크립트와 테이블 제거
              const clonedContent = articleContent.cloneNode(true) as Element;
              const scripts = clonedContent.querySelectorAll('script');
              const adDivs = clonedContent.querySelectorAll('div[style*="max-width"]');
              
              console.log(`[${index}] 제거할 스크립트: ${scripts.length}개, 광고 div: ${adDivs.length}개`);
              scripts.forEach(script => script.remove());
              adDivs.forEach(div => div.remove());

              // HTML을 텍스트로 변환하면서 <br> 태그를 줄바꿈으로 처리
              let htmlContent = clonedContent.innerHTML;
              console.log(`[${index}] 원본 HTML 길이: ${htmlContent.length}`);
              
              htmlContent = htmlContent.replace(/<br\s*\/?>/gi, '\n');
              htmlContent = htmlContent.replace(/<[^>]+>/g, ' '); // HTML 태그 제거
              htmlContent = htmlContent.replace(/&[^;]+;/g, ' '); // HTML 엔티티 제거
              
              console.log(`[${index}] 정리된 텍스트 길이: ${htmlContent.length}`);
              
              // 줄바꿈으로 분할하여 문단별로 처리
              const paragraphs = htmlContent.split('\n');
              console.log(`[${index}] 문단 분할 결과: ${paragraphs.length}개`);
              
              let validParagraphs = 0;
              paragraphs.forEach((paragraph, pIndex) => {
                const text = paragraph.replace(/\s+/g, ' ').trim();
                if (text && text.length > 15 && !text.includes('사진제공=')) {
                  console.log(`[${index}] 문단[${pIndex}] 추가: ${text.substring(0, 50)}...`);
                  contents.push({ isPicture: false, contents: text });
                  validParagraphs++;
                } else if (text) {
                  console.log(`[${index}] 문단[${pIndex}] 제외 (길이:${text.length}, 사진제공:${text.includes('사진제공=')}): ${text.substring(0, 30)}...`);
                }
              });
              console.log(`[${index}] 유효한 문단 ${validParagraphs}개 추가됨`);
            } else {
              console.log(`[${index}] 일반 파싱 로직 적용`);
              
              // 일반적인 파싱 로직
              const paragraphs = articleContent.querySelectorAll('p, div');
              console.log(`[${index}] p, div 요소 ${paragraphs.length}개 발견`);
              
              let validTexts = 0;
              paragraphs.forEach((p, pIndex) => {
                const text = p.textContent?.replace(/\s+/g, ' ').trim();
                if (text && text.length > 10) {
                  console.log(`[${index}] 텍스트[${pIndex}] 추가: ${text.substring(0, 50)}...`);
                  contents.push({ isPicture: false, contents: text });
                  validTexts++;
                }
              });

              // 본문이 없으면 전체 텍스트 사용
              if (contents.filter(c => !c.isPicture).length === 0) {
                console.log(`[${index}] 본문 없음, 전체 텍스트 사용`);
                const fullText = articleContent.textContent?.replace(/\s+/g, ' ').trim();
                if (fullText && fullText.length > 10) {
                  console.log(`[${index}] 전체 텍스트 길이: ${fullText.length}`);
                  contents.push({ isPicture: false, contents: fullText });
                }
              } else {
                console.log(`[${index}] 일반 파싱으로 ${validTexts}개 텍스트 추가됨`);
              }
            }
          } else {
            console.log(`[${index}] 본문 요소를 찾을 수 없음`);
          }
        } else {
          console.log(`[${index}] 상세 페이지 접근 실패: ${detailRes.status}`);
        }
      } catch (e) { 
        console.error(`[${index}] 상세페이지 파싱 오류:`, e);
        if (e instanceof Error) {
          console.error(`[${index}] 오류 메시지: ${e.message}`);
          console.error(`[${index}] 오류 스택: ${e.stack}`);
        }
      }

      if (contents.length === 0) {
        contents.push({ isPicture: false, contents: "머니투데이에서 수집된 연예뉴스입니다." });
        console.log(`[${index}] 본문/이미지 없음, 기본 안내문 저장`);
      }

      const imageCount = contents.filter(c => c.isPicture).length;
      const textCount = contents.filter(c => !c.isPicture).length;
      console.log(`[${index}] 최종 컨텐츠 구성: 이미지 ${imageCount}개, 텍스트 ${textCount}개`);

      const article: Article = {
        key: (parseInt(newsKey) + index).toString(),
        board_name: 'entertainment_news',
        profile_key: "00000000000000001",
        profile_name: "연예뉴스봇",
        title: title,
        contents: contents,
        count_like: 0,
        count_unlike: 0,
        count_view: 0,
        count_comments: 0,
        is_notice: false,
                  created_at: currentTimestamp,
          updated_at: currentTimestamp,
        timestamp: currentTimestamp,
      };

      console.log(`[${index}] Firestore 저장 시작: ${article.key}`);
      await db.collection(FIRESTORE_COLLECTION_ARTICLE).doc(article.key).set(article);
      console.log(`[${index}] Firestore 저장 완료`);
      index++;
    }

    console.log(`Entertainment news collection completed: ${index} articles added`);
  } catch (error) {
    console.error('Error collecting entertainment news:', error);
  }
}

// 연예뉴스 수집 함수
async function collectEntertainmentNews(db: admin.firestore.Firestore) {
  await fetchAndParseEntertainmentNews(db);
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

// 연예뉴스 스케줄링
export const scheduledEntertainmentNewsCollection = onSchedule(
  { 
    schedule: 'every 90 minutes',
    region: 'asia-northeast3'
  },
  async (event) => {
    try {
      console.log('Starting scheduled entertainment news collection...');
      if (!admin.apps.length) {
        admin.initializeApp();
      }
      const db = admin.firestore();
      db.settings({ ignoreUndefinedProperties: true });
      await collectEntertainmentNews(db);
      console.log('Scheduled entertainment news collection completed successfully');
    } catch (error) {
      console.error('Error in scheduled entertainment news collection:', error);
    }
  }
);

