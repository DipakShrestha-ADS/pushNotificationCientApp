import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

//const dbFireStore = admin.firestore();
const firebaseMessaging = admin.messaging();

export const sendToDevice = functions.firestore
  .document('pushData/{pushDataId}')
  .onCreate(async snapshot => {
    
    const dataPushed = snapshot.data();
    const dateTime = Date.now();
  
    // const querySnapshot = await
    //     dbFireStore.collection('users')
    //             .doc('YuLbEhEZqQcGTcp7zaY7YMKPUAN2')
    //             .collection('tokens')
    //             .get();
                
    //const tokens = querySnapshot.docs.map((snap: { id: any; }) => snap.id);
    
    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `${dataPushed!=null?dataPushed.title:'Dipak Shrestha'}`,
        body: `${dataPushed!=null?dataPushed.abstractMessage:'This is dipak body.'}`,
        icon: '@drawable/notification_icon',
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        color:'@color/notification_color'
      },
      data: {
        "title": `${dataPushed!=null?dataPushed.title:'Dipak Shrestha'}`,
        "abstractMessage": `${dataPushed!=null?dataPushed.abstractMessage:'This is abstaract message.'}`,
        "detailedMessage": `${dataPushed!=null?dataPushed.detailedMessage:'This is detailed message.'}`,
        "publishDate": `${dataPushed!=null?dataPushed.publishDate:'This is publish date.'}`,
        "accessedDate": `${dateTime}`,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "image": "https://firebasestorage.googleapis.com/v0/b/flutter-push-notificatio-117f8.appspot.com/o/circle-cropped.png?alt=media&token=6c1ae3c6-d659-4111-b32c-c3576290cbd7",
       },
    };
    console.log(`payload: ${payload}`);

    //return firebaseMessaging.sendToDevice(tokens, payload);
    return firebaseMessaging.sendToTopic('pushmsg',payload);
  });