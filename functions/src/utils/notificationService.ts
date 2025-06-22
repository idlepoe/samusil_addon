import * as admin from 'firebase-admin';

const db = admin.firestore();

export interface NotificationData {
  id?: string;
  type: 'comment' | 'like';
  title: string;
  body: string;
  article_id: string;
  article_title: string;
  sender_uid: string;
  sender_name: string;
  created_at: admin.firestore.Timestamp;
  read: boolean;
}

/**
 * 알림 히스토리에 추가
 */
export async function addNotificationHistory(
  recipientUid: string,
  notificationData: Omit<NotificationData, 'id' | 'created_at' | 'read'>
): Promise<void> {
  try {
    const notification: NotificationData = {
      ...notificationData,
      created_at: admin.firestore.Timestamp.now(),
      read: false,
    };

    const profileRef = db.collection('profile').doc(recipientUid);
    const historyRef = profileRef.collection('notification_history').doc();

    await historyRef.set(notification);
    
    console.log(`Notification history added for ${recipientUid}: ${notificationData.type}`);
  } catch (error) {
    console.error('Error adding notification history:', error);
    throw error;
  }
}

/**
 * FCM 토픽으로 푸시 알림 발송
 */
export async function sendPushNotification(
  topic: string,
  title: string,
  body: string,
  data?: Record<string, string>
): Promise<void> {
  try {
    const message: admin.messaging.Message = {
      topic: topic,
      notification: {
        title: title,
        body: body,
      },
      data: data,
      android: {
        notification: {
          channelId: 'default',
          priority: 'high',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    const response = await admin.messaging().send(message);
    console.log(`Push notification sent to topic ${topic}:`, response);
  } catch (error) {
    console.error('Error sending push notification:', error);
    throw error;
  }
}

/**
 * 댓글 알림 처리
 */
export async function sendCommentNotification(
  articleId: string,
  articleTitle: string,
  authorUid: string,
  commenterUid: string,
  commenterName: string
): Promise<void> {
  try {
    // 자신의 게시글에 댓글을 달면 알림 발송하지 않음
    if (authorUid === commenterUid) {
      return;
    }

    const title = '새로운 댓글이 달렸습니다';
    const body = `${commenterName}님이 "${articleTitle}"에 댓글을 달았습니다`;

    // 알림 히스토리에 추가
    await addNotificationHistory(authorUid, {
      type: 'comment',
      title,
      body,
      article_id: articleId,
      article_title: articleTitle,
      sender_uid: commenterUid,
      sender_name: commenterName,
    });

    // 푸시 알림 발송 (작성자의 UID를 토픽으로 사용)
    await sendPushNotification(
      authorUid,
      title,
      body,
      {
        type: 'comment',
        article_id: articleId,
        sender_uid: commenterUid,
      }
    );
  } catch (error) {
    console.error('Error sending comment notification:', error);
  }
}

/**
 * 좋아요 알림 처리
 */
export async function sendLikeNotification(
  articleId: string,
  articleTitle: string,
  authorUid: string,
  likerUid: string,
  likerName: string
): Promise<void> {
  try {
    // 자신의 게시글에 좋아요를 누르면 알림 발송하지 않음
    if (authorUid === likerUid) {
      return;
    }

    const title = '좋아요를 받았습니다';
    const body = `${likerName}님이 "${articleTitle}"에 좋아요를 눌렀습니다`;

    // 알림 히스토리에 추가
    await addNotificationHistory(authorUid, {
      type: 'like',
      title,
      body,
      article_id: articleId,
      article_title: articleTitle,
      sender_uid: likerUid,
      sender_name: likerName,
    });

    // 푸시 알림 발송 (작성자의 UID를 토픽으로 사용)
    await sendPushNotification(
      authorUid,
      title,
      body,
      {
        type: 'like',
        article_id: articleId,
        sender_uid: likerUid,
      }
    );
  } catch (error) {
    console.error('Error sending like notification:', error);
  }
} 