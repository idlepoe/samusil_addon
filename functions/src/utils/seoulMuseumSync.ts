import * as admin from 'firebase-admin';
import axios from 'axios';

export async function performSeoulMuseumSync() {
    const db = admin.firestore();

    const API_KEY = '53574b6e7069646c3631646b4a4e53';
    const API_BASE = `http://openapi.seoul.go.kr:8088/${API_KEY}/json/SemaPsgudInfoKorInfo`;
    const BATCH_SIZE = 1000;

    try {
        // 전체 개수 조회
        const totalRes = await axios.get(`${API_BASE}/1/1`);
        const totalCount = totalRes.data.SemaPsgudInfoKorInfo.list_total_count;
        const pages = Math.ceil(totalCount / BATCH_SIZE);
        console.log(`🎨 총 작품 수: ${totalCount}, 페이지 수: ${pages}`);

        for (let i = 0; i < pages; i++) {
            const start = i * BATCH_SIZE + 1;
            const end = Math.min((i + 1) * BATCH_SIZE, totalCount);

            const url = `${API_BASE}/${start}/${end}`;
            console.log(`📦 요청 중: ${url}`);

            const response = await axios.get(url);
            const rows = response.data.SemaPsgudInfoKorInfo.row;

            if (!rows || rows.length === 0) {
                console.log(`⚠️ ${start} ~ ${end} 데이터 없음`);
                continue;
            }

            const batch = db.batch();
            for (const item of rows) {
                const id = generateSafeArtworkId(item);
                const docRef = db.collection('artworks').doc(id);
                const price = calculateArtworkPrice(item);

                batch.set(docRef, {
                    ...item,
                    id: id, // 안전한 ID 저장
                    price: price,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                }, {merge: true});
            }

            await batch.commit();
            console.log(`✅ 저장 완료: ${start} ~ ${end}`);
        }

        console.log('🎉 서울시립미술관 작품 전체 동기화 완료!');
    } catch (error) {
        console.error('❌ 동기화 실패:', (error as Error).message);
        throw error;
    }
}

function generateSafeArtworkId(artwork: any): string {
    const manageNo = artwork.manage_no_year || 'unknown';
    const title = artwork.prdct_nm_korean || 'unknown';
    
    // 슬래시, 백슬래시, 점, 콜론 등 Firestore 문서 ID에서 사용할 수 없는 문자들을 제거
    const safeTitle = title
        .replace(/[\/\\\.:]/g, '_') // 슬래시, 백슬래시, 점, 콜론을 언더스코어로 변경
        .replace(/\s+/g, '_') // 공백을 언더스코어로 변경
        .replace(/[^\w가-힣_-]/g, '') // 한글, 영문, 숫자, 언더스코어, 하이픈만 허용
        .substring(0, 100); // 길이 제한
    
    return `${manageNo}_${safeTitle}`;
}

function calculateArtworkPrice(artwork: any): number {
    const input = `${artwork.prdct_nm_korean}_${artwork.writr_nm}_${artwork.mnfct_year}_${artwork.prdct_stndrd}`;
    let hash = 0;
    for (let i = 0; i < input.length; i++) {
        hash = (hash * 31 + input.charCodeAt(i)) >>> 0; // 32bit 안전한 해시
    }
    const min = 800;
    const max = 5000;
    return min + (hash % (max - min));
} 