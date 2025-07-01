import { onSchedule } from 'firebase-functions/v2/scheduler';
import { performSeoulMuseumSync } from '../utils/seoulMuseumSync';

export const scheduledSeoulMuseumSync = onSchedule(
    {
        schedule: "0 9 1 * *", // 매월 1일 오전 9시
        timeZone: "Asia/Seoul",
    },
    async () => {
        await performSeoulMuseumSync();
    }
); 