import axios from 'axios';

interface CoinData {
  id: string;
  symbol: string;
  name: string;
  image: string;
  current_price: number;
}

/**
 * CoinGecko API를 사용하여 상위 코인 목록을 가져옵니다.
 * @param {number} count 가져올 코인 수
 * @returns {Promise<CoinData[]>} 코인 데이터 배열
 */
export async function getTopCoins(count: number = 6): Promise<CoinData[]> {
  try {
    const url = `https://api.coingecko.com/api/v3/coins/markets`;
    const params = {
      vs_currency: 'usd',
      order: 'market_cap_desc',
      per_page: count,
      page: 1,
      sparkline: false,
    };

    const response = await axios.get<CoinData[]>(url, { params });
    return response.data;
  } catch (error) {
    console.error('CoinGecko API에서 코인 정보를 가져오는 중 오류 발생:', error);
    return [];
  }
}

/**
 * 특정 코인들의 현재 가격 정보를 가져옵니다.
 * @param {string[]} coinIds 코인 ID 배열
 * @returns {Promise<Record<string, { usd: number }>>} 코인 가격 객체
 */
export async function getCoinPrices(coinIds: string[]): Promise<Record<string, { usd: number }>> {
  try {
    const ids = coinIds.join(',');
    const url = `https://api.coingecko.com/api/v3/simple/price`;
    const params = {
      ids: ids,
      vs_currencies: 'usd',
    };
    
    const response = await axios.get<Record<string, { usd: number }>>(url, { params });
    return response.data;
  } catch (error) {
    console.error('CoinGecko API에서 코인 가격을 가져오는 중 오류 발생:', error);
    return {};
  }
} 