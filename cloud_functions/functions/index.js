"use strict";
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onConversationCreated = functions.firestore.document("All_Chats/{chatRoomId}").onCreate(async (snap, context) => {
    let doc = snap.data();   
    console.log('This is the doc');
    console.log(doc);
    let chatRoomId = context.params.chatRoomId;
    if (doc) {
        //members can be pvt or prof 
        let members = doc.members;
        const ownerAcType = doc.ownerAcType;
        const receiverAcType = doc.receiverAcType;
        console.log(ownerAcType);
        console.log(receiverAcType);
    
        if(ownerAcType==='Professional' && receiverAcType==='Professional') {
            const ownerProfId = doc.ownerId;
            const receiverProfId = members[1];
            const ownerDoc = await admin.firestore().collection("All_User").doc('PRF - ' + ownerProfId).get();
            const receiverDoc = await admin.firestore().collection("All_User").doc('PRF - ' + receiverProfId).get();
            console.log(ownerDoc.data());
            console.log(receiverDoc.data());
            const ownerpvtId = ownerDoc.data().pvtId;
            const receiverpvtId = receiverDoc.data().pvtId;
    
            await admin.firestore().collection("Users").doc(ownerpvtId).collection('Professional_Ac').doc(ownerProfId).collection("Prof_Chats").doc(receiverProfId).create({
                    "chattingWithId": receiverProfId,
                    "chatRoomId": chatRoomId,
                    "fullname": receiverDoc.data().BusinessName,
                    "username": receiverDoc.data().profUserName,
                    "image": receiverDoc.data().profUrl,
                    "typeOfConversation":  "Direct",
                    "messagesCount": 0,
                    'acType':'Professional',
                    });

            await admin.firestore().collection("Users").doc(receiverpvtId).collection('Professional_Ac').doc(receiverProfId).collection("Prof_Chats").doc(ownerProfId).create({
                        "chattingWithId": ownerProfId,
                        "chatRoomId": chatRoomId,
                        "fullname": ownerDoc.data().BusinessName,
                        "username": ownerDoc.data().profUserName,
                        "image": ownerDoc.data().profUrl,
                        "typeOfConversation": "Request",
                        "messagesCount": 0,
                        'acType':'Professional',
                    });

             return true;       

            }  else if (ownerAcType==='Private' && receiverAcType==='Professional')  {
            const ownerPvtId = doc.ownerId;
            const receiverProfId = members[1];
            const ownerDoc = await admin.firestore().collection("Users").doc(ownerPvtId).get();
            const receiverDoc = await admin.firestore().collection("All_User").doc('PRF - ' + receiverProfId).get();
            const ownerProfId = ownerDoc.data().profId;
            console.log(ownerDoc.data());
            console.log(receiverDoc.data());
            const receiverpvtId = receiverDoc.data().pvtId;
            let url;

            if (ownerDoc.data().privateUrl===null){
                url = 'https://firebasestorage.googleapis.com/v0/b/college-section.appspot.com/o/noprofile.jpeg?alt=media&token=77431841-95d0-456a-9302-99390069717d';
            } else{
                url = ownerDoc.data().privateUrl;
            }
    
            await admin.firestore().collection("Users").doc(ownerPvtId).collection("Private_Chats").doc(receiverProfId).create({
                    "chattingWithId": receiverProfId,
                    "chatRoomId": chatRoomId,
                    "fullname": receiverDoc.data().BusinessName,
                    'username':receiverDoc.data().profUserName,
                    "image": receiverDoc.data().profUrl,
                    "typeOfConversation":  "Direct",
                    "messagesCount": 0,
                    'myRelation':'Following',
                    'acType': 'Private',
                    });

            await admin.firestore().collection("Users").doc(receiverpvtId).collection('Professional_Ac').doc(receiverProfId).collection("Prof_Chats").doc(ownerPvtId).create({
                        "chattingWithId": ownerPvtId,
                        "chatRoomId": chatRoomId,
                        "fullname": ownerDoc.data().fullname,
                        'username':ownerDoc.data().username,
                        "image": url,
                        "typeOfConversation": "Request",
                        "messagesCount": 0,
                        'acType':'Professional',
                    });

             return true;

            }  else if (ownerAcType==='Private' && receiverAcType==='Private') {
                
            const ownerPvtId = doc.ownerId;
            const receiverPvtId = members[1];
            const ownerDoc = await admin.firestore().collection("All_User").doc('PVT - ' + ownerPvtId).get();
            const receiverDoc = await admin.firestore().collection("All_User").doc('PVT - ' + receiverPvtId).get();
            const receiverConDoc = await admin.firestore().collection("Users").doc(receiverPvtId).collection("Connections").doc(ownerPvtId).get();
            const ownerConDoc = await admin.firestore().collection("Users").doc(ownerPvtId).collection("Connections").doc(receiverPvtId).get();
            const ownerConType = ownerConDoc.data().myRelation;
            const receiverConType = receiverConDoc.data().myRelation;

            console.log(ownerDoc.data());
            console.log(receiverDoc.data());
            console.log(receiverConDoc.data());
            console.log(ownerConType);
            console.log(receiverConType);
            let ownerUrl;
            let receiverUrl;

               
               if (ownerDoc.data().privateUrl===null){
                ownerUrl = 'https://firebasestorage.googleapis.com/v0/b/college-section.appspot.com/o/noprofile.jpeg?alt=media&token=77431841-95d0-456a-9302-99390069717d';
            } else{
                ownerUrl = ownerDoc.data().privateUrl;
            }

            if (receiverDoc.data().privateUrl===null){
                receiverUrl = 'https://firebasestorage.googleapis.com/v0/b/college-section.appspot.com/o/noprofile.jpeg?alt=media&token=77431841-95d0-456a-9302-99390069717d';
            } else{
                receiverUrl = receiverDoc.data().privateUrl;
            }
            
            await admin.firestore().collection("Users").doc(ownerPvtId).collection('Private_Chats').doc(receiverPvtId).create({
                    "chattingWithId": receiverPvtId,
                    "chatRoomId": chatRoomId,
                    "fullname": receiverDoc.data().fullname,
                    'username':receiverDoc.data().username,
                    "image": receiverUrl,
                    "typeOfConversation":  "Direct",
                    "messagesCount": 0,
                    'myRelation': ownerConType,
                    'acType':'Private',
                    }); 

            await admin.firestore().collection("Users").doc(receiverPvtId).collection('Private_Chats').doc(ownerPvtId).create({
                        "chattingWithId": ownerPvtId,
                        "chatRoomId": chatRoomId,
                        "fullname": ownerDoc.data().fullname,
                        'username':ownerDoc.data().username,
                        "image": ownerUrl,
                        "typeOfConversation": 'Direct',
                        "messagesCount": 0,
                        'myRelation': receiverConType,
                        'acType':'Private',
                    });
            return true;

        } else {
            console.log('Failed to execute conversation snippet creation');
            return false;
        }
    }   
});


exports.onConversationUpdated = functions.firestore.document("All_Chats/{chatRoomId}").onUpdate(async (change, context) => {
    let doc = change === null || change === void 0 ? void 0 : change.after.data();
    console.log(doc);

    if (doc) {
        let members = doc.members;
        const ownerAcType = doc.ownerAcType;
        const receiverAcType = doc.receiverAcType;
        console.log(doc.messages.length);
        let lastMessage = doc.messages[doc.messages.length - 1];
        console.log(lastMessage);
        console.log(doc.messages);
        console.log(lastMessage.content);
        const senderId = lastMessage.senderId;

        if (ownerAcType==='Professional' && receiverAcType==='Professional') {
            const ownerProfId = doc.ownerId;
            const receiverProfId = members[1];
            const ownerDoc = await admin.firestore().collection("All_User").doc('PRF - ' + ownerProfId).get();
            const receiverDoc = await admin.firestore().collection("All_User").doc('PRF - ' + receiverProfId).get();
            const ownerpvtId = ownerDoc.data().pvtId;
            const receiverpvtId = receiverDoc.data().pvtId;
            const senderId = lastMessage.senderId;
            let senderName;
            let fcmToken;
    
            await admin.firestore().collection("Users").doc(ownerpvtId).collection('Professional_Ac').doc(ownerProfId).collection("Prof_Chats").doc(receiverProfId).update({
                        "lastMessage": lastMessage.content,
                        "timestamp": lastMessage.timestamp,
                        "type": lastMessage.type,
                        "messagesCount": admin.firestore.FieldValue.increment(1),
                        });

            await admin.firestore().collection("Users").doc(receiverpvtId).collection('Professional_Ac').doc(receiverProfId).collection("Prof_Chats").doc(ownerProfId).update({
                        "lastMessage": lastMessage.content,
                        "timestamp": lastMessage.timestamp,
                        "type": lastMessage.type,
                        "messagesCount": admin.firestore.FieldValue.increment(1),
                    });

            if(senderId===ownerProfId){
                senderName = ownerDoc.data().BusinessName;
                fcmToken = receiverDoc.data().fcmToken;
            } else{
                senderName = receiverDoc.data().BusinessName;
                fcmToken = ownerDoc.data().fcmToken;
            }       
            console.log(senderName);
            console.log(fcmToken);

                    const not1 = {
                        "notification": {
                            title: senderName,
                            body: lastMessage.content,
                        },
                        token: fcmToken,
                    }
            
                  return admin.messaging().send(not1);   

            }  else if (ownerAcType==='Private' && receiverAcType==='Professional')  {

            const ownerPvtId = doc.ownerId;
            const otherProfId = members[1];
            const otherDoc = await admin.firestore().collection("All_User").doc('PRF - ' + otherProfId).get();
            const otherpvtId = otherDoc.data().pvtId;
            let senderName2;
            let fcmToken2;
    
            await admin.firestore().collection("Users").doc(ownerPvtId).collection('Private_Chats').doc(otherProfId).update({
                        "lastMessage": lastMessage.content,
                        "timestamp": lastMessage.timestamp,
                        "type": lastMessage.type,
                        "messagesCount": admin.firestore.FieldValue.increment(1),
                    });

            await admin.firestore().collection("Users").doc(otherpvtId).collection('Professional_Ac').doc(otherProfId).collection("Prof_Chats").doc(ownerPvtId).update({
                        "lastMessage": lastMessage.content,
                        "timestamp": lastMessage.timestamp,
                        "type": lastMessage.type,
                        "messagesCount": admin.firestore.FieldValue.increment(1),
                    });
      
             
           if(lastMessage.senderId===ownerPvtId){
                const senderDoc = await admin.firestore().collection("All_User").doc('PVT - ' + ownerPvtId).get();
                senderName2 = senderDoc.data().fullname;    
                fcmToken2 = otherDoc.data().fcmToken;
            } else if (lastMessage.senderId===otherProfId){
                senderName2 = otherDoc.data().BusinessName;
                const receiverDoc = await admin.firestore().collection("All_User").doc('PVT - ' + ownerPvtId).get();    
                fcmToken2 = receiverDoc.data().fcmToken;
            }

            console.log(senderName2);
            console.log(fcmToken2);  
                    
                const not2 = {
                    "notification": {
                        title: senderName2,
                        body: lastMessage.content,
                    },
                    token: fcmToken2,
                }
                    
                return admin.messaging().send(not2);    

            }  else if (ownerAcType==='Private' && receiverAcType==='Private') {
                
            const ownerPvtId = doc.ownerId;
            const otherPvtId = members[1];
            const ownerDoc = await admin.firestore().collection("All_User").doc('PVT - ' + ownerPvtId).get();
            const otherDoc = await admin.firestore().collection("All_User").doc('PVT - ' + otherPvtId).get();
            let senderName3;
            let fcmToken3;

            await admin.firestore().collection("Users").doc(ownerPvtId).collection('Private_Chats').doc(otherPvtId).update({
                            "lastMessage": lastMessage.content,
                            "timestamp": lastMessage.timestamp,
                            "type": lastMessage.type,
                            "messagesCount": admin.firestore.FieldValue.increment(1),
                    });

            await admin.firestore().collection("Users").doc(otherPvtId).collection('Private_Chats').doc(ownerPvtId).update({
                            "lastMessage": lastMessage.content,
                            "timestamp": lastMessage.timestamp,
                            "type": lastMessage.type,
                            "messagesCount": admin.firestore.FieldValue.increment(1),
                    });

          if(senderId===ownerPvtId) {
            senderName3 = ownerDoc.data().fullname;  
            fcmToken3 = otherDoc.data().fcmToken;  
          } else{
            senderName3 = otherDoc.data().fullname;  
            fcmToken3 = ownerDoc.data().fcmToken;
          }

            console.log(senderName3);
            console.log(fcmToken3);
            
                    const not3 = {
                        "notification": {
                            title: senderName3,
                            body: lastMessage.content,
                        },
                        token: fcmToken3,
                    }
            
                  return admin.messaging().send(not3);   

        } else {
            console.log('Failed to update conversation');
            return false;
        }
    }
    
});

exports.sendConnectionNotification = functions.firestore.document('Users/{idTo}/Pvt_Notifications/{idFrom}').onCreate(async (snap,context) => {
    try{
    const doc = snap.data();
    const idTo = doc.To;
    const idFrom = context.params.idFrom;
    const username = doc.fullname;
    const notifType = doc.type;
    let notifContent;
    console.log(idFrom);
    console.log(idTo);
    console.log(username);
    console.log(notifType);

    const receiver = await admin.firestore().collection("Users").doc(idTo).get();
    const fcmToken = receiver.data().fcmToken;
    console.log(fcmToken);

    if(notifType==='Connection Request'){
        notifContent = username + ' has sent you a connection request';
    } else if (notifType==='Connection Accepted'){
        notifContent = username + ' is now in connection';
    } else if (notifType==='Like'){
        notifContent = username + ' has liked your post';
    }
    console.log(notifContent);
      const not1 = {
            'notification' : {
                title: notifContent,
            },
            token: fcmToken,
        }
      console.log(not1);  
      return admin.messaging().send(not1)
    } catch(e){
        console.log('send Connection Notification Failed');
    }
});


exports.sendFollowerNotification = functions.firestore.document('Users/{PvtIdTo}/Professional_Ac/{ProfIdTo}/Prof_Notifications/{idFrom}').onCreate(async (snap,context) => {
    //idFrom can be pvt or prof 
    try{
    const doc = snap.data();
    const idFrom = context.params.idFrom;
    const ProfIdTo = doc.To;
    const username = doc.fullname;
    const notifType = doc.type;
    let notifContent;
    console.log(ProfIdTo);
    console.log(username);
    console.log(idFrom);
 
    const receiver = await admin.firestore().collection("All_User").doc('PRF - '+ ProfIdTo).get();
    const PvtIdTo = receiver.data().pvtId;
    const fcmToken = receiver.data().fcmToken;
    console.log(PvtIdTo);
    console.log(fcmToken);

    if(notifType==='Like'){
        notifContent = username + ' has liked your post';
    } else {
        notifContent = username + ' started following you';
    }

    console.log(notifContent);
      const not2 = {
            "notification": {
                title: notifContent,
            },
            token: fcmToken,
        }
        console.log(not2);
      return admin.messaging().send(not2)
    } catch(e){
        console.log('send Follower Notification Failed');
    }
});


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
