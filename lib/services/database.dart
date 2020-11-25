import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:yibe_final_ui/model/conversation.dart';
import 'package:yibe_final_ui/model/message.dart';
import 'package:yibe_final_ui/model/post.dart';
import 'package:yibe_final_ui/utils/constants.dart';

class DatabaseService {
  static DatabaseService instance = DatabaseService();
  FirebaseFirestore _db;

  DatabaseService() {
    _db = FirebaseFirestore.instance;
  }
  final String _userCollection = 'Users';
  final String _profAccount = 'Professional_Ac';
  final String _allUserCollection = 'All_User';
  final String _privateChats = 'Private_Chats';
  final String _privateNotifications = 'Pvt_Notifications';
  final String _profNotifications = 'Prof_Notifications';
  final String _privateConnections = 'Connections';
  final String _privateFollowings = 'Followings';
  final String _profFollowers = 'Prof_Followers';
  final String _profFollowings = 'Prof_Followings';
  final String _profChats = 'Prof_Chats';
  final String _allChats = 'All_Chats';
  final String _privatePosts = 'Private_Posts';
  final String _profPosts = 'Prof_Posts';
  final String _privateFeeds = 'Private_Feeds';
  final String _profFeeds = 'Prof_Feeds';



  //-----------------------------------------private queries-----------------------------------------//

  Future<void> createPvtUserInDB(Map pvtUserMap, String userId) async {
    try {
      await _db.collection(_userCollection).doc(userId).set(pvtUserMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createPvtUserInAllUserCollection(Map UserMap, String userId) async {
    try {
      await _db.collection(_allUserCollection).doc('PVT - ' + userId).set(UserMap);
    } catch (e) {
      print(e);
    }
  }

  Future<Map> getPvtCurrentUserInfo(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection(_userCollection).doc(uid).get();
      return doc.data();
    } catch (e) {
      print(e);
    }
  }

  Future<String> getPvtProfileUrlofAUser(String chattingWithId) async{
    try{
      DocumentSnapshot doc =  await _db.collection(_userCollection).doc(chattingWithId).get();
      if(doc.data()['privateUrl'] != null) {
        return doc.data()['privateUrl'];
      } else {
        return UniversalVariables.defaultImageUrl;
      }
    } catch(e){
      print(e);
      return UniversalVariables.defaultImageUrl;
    }
  }


  //private search
  Stream<QuerySnapshot> getAllUsers() {
    return _db.collection(_allUserCollection).snapshots();
  }


  Future<void> updateHaveAProfAc(String profId) async {
    print('In update prof ac');
    print(profId);
    try{
       _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).update({'haveProfAc': true, 'profId': profId });
       _db.collection(_allUserCollection).doc('PVT - ' +UniversalVariables.myPvtUid).update({'haveProfAc': true, 'profId': profId });
    } catch(e){
      print(e);
    }
  }

  Future<void> updatePrivateUserInfo(String bio, String imageUrl) async {
    print(bio);
    print(imageUrl);
    try{
       _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).update({'pvtBio': bio, 'privateUrl': imageUrl });
      _db.collection(_allUserCollection).doc('PVT - ' + UniversalVariables.myPvtUid).update({'pvtBio': bio, 'privateUrl': imageUrl });
    } catch(e){
      print(e);
    }
  }

  Future<void> updateProfUserInfo(String bio, String imageUrl) async {
    try{
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).update({'BusinessBio': bio, 'profUrl': imageUrl });
      await _db.collection(_allUserCollection).doc('PRF - ' + UniversalVariables.myProfUid).update({'BusinessBio': bio, 'profUrl': imageUrl });
    } catch(e){
      print(e);
    }
  }


  Future<void> sendMyConnectionRequest(Map myConnectionMap) async {
    try {
      await _db.collection(_userCollection).doc(myConnectionMap['To']).collection(_privateNotifications).doc(myConnectionMap['From']).set(myConnectionMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> withdrawMyConnectionRequest(String otherUserUid) async {
    try {
      await _db.collection(_userCollection).doc(otherUserUid).collection(_privateNotifications).doc(UniversalVariables.myPvtUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> acceptConnectionRequest(String otherUserUid, Map senderConnectionMap, Map receiverConnectionMap) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateNotifications).doc(otherUserUid).delete();
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).doc(otherUserUid).set(receiverConnectionMap);
      await _db.collection(_userCollection).doc(otherUserUid).collection(_privateConnections).doc(UniversalVariables.myPvtUid).set(senderConnectionMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> rejectConnectionRequest(String otherUserUid) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateNotifications).doc(otherUserUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendConnectionConfirmation(Map myConnectionMap) async {
    try {
      await _db.collection(_userCollection).doc(myConnectionMap['To']).collection(_privateNotifications).doc(myConnectionMap['From']).set(myConnectionMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> dismissConnectionConfirmation(String otherUserUid) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateNotifications).doc(otherUserUid).delete();
    } catch (e) {
      print(e);
    }
  }

  void removeUserFromMyConnection(String otherUserUid) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).doc(otherUserUid).delete();
      await _db.collection(_userCollection).doc(otherUserUid).collection(_privateConnections).doc(UniversalVariables.myPvtUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> incrementMyPvtFollowing(String otherUserUid) async {
    try {
      DocumentSnapshot doc =  await _db.collection(_allUserCollection).doc('PRF - '+ otherUserUid).get();
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFollowings).doc(otherUserUid).set({'uid': otherUserUid, 'name': doc.data()['BusinessName'], 'url': doc.data()['profUrl'], 'myRelation': 'Following'});
    } catch (e) {
      print(e);
    }
  }

  Future<void> decrementMyPvtFollowing(String otherUserUid) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFollowings).doc(otherUserUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getPvtNotifications() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateNotifications).snapshots();
  }

  Future<bool> checkUserExistsInMyConnection(String otherUserUid) async {
    bool exists = false;
    try {
       await _db.collection(_userCollection).doc(otherUserUid).collection(_privateConnections).doc(UniversalVariables.myPvtUid).get().then((doc) {
        doc.exists ? exists = true : exists = false;
      });
      return exists;
    } catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> checkIfAlreadySentConnectionRequest(String otherUserUid) async {
    bool exists = false;
    try {
      await _db.collection(_userCollection).doc(otherUserUid).collection(_privateNotifications).doc(UniversalVariables.myPvtUid).get().then((doc) {
        doc.exists ? exists = true : exists = false;
      });
      return exists;
    } catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> checkUserExistsInMyPvtFollowing(String otherUserUid) async {
    bool exists = false;
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFollowings).doc(otherUserUid).get().then((doc) {
        doc.exists ? exists = true : exists = false;
      });
      return exists;
    } catch(e){
      print(e);
      return false;
    }
  }

  Future<int> getConnectionCountOfAUser(String uid) async {
    try {
      QuerySnapshot connections = await _db.collection(_userCollection).doc(uid).collection(_privateConnections).get();
      List<DocumentSnapshot> connectionCount = connections.docs;
      return connectionCount.length;
    } catch(e){
      print(e);
      return 0;
    }
  }

  Future<int> getPvtFollowingCountOfAUser(String uid) async {
    try {
      QuerySnapshot connections = await _db.collection(_userCollection).doc(uid).collection(_privateFollowings).get();
      List<DocumentSnapshot> pvtFollowingCount = connections.docs;
      return pvtFollowingCount.length;
    } catch(e){
      print(e);
      return 0;
    }
  }

   Stream<QuerySnapshot> getAllMyConnections() {
      return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).snapshots();
  }

  Stream<QuerySnapshot> getAllMyPvtFollowings() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFollowings).snapshots();
  }

  void uploadPvtPost(Map newPostMap, String postId) async {
    return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privatePosts).doc(postId).set(newPostMap);
   // await _db.collection('Posts').doc().set(newPostMap);
  }

  void AddImagePostToMyConnectionFeed(String name, String image, String caption, String postId, String postUrl, Timestamp timestamp, String relationType) async{
    Post newPostMap = Post();
    if(relationType=='CF') {    //if user selects CF, send post to only CF connection
      print(relationType);
      return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: relationType).get().then((snapshot) =>
          snapshot.docs.forEach((doc) {
            print('connection id: ' + doc.data()['uid']);
            print('connection id: ' + doc.data()['otherUserRelation']);
            if (doc.data()['otherUserRelation']=='CF'){
              newPostMap = Post(
                type: 'image',
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                postUrl: postUrl,
                caption: caption,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            }else if (doc.data()['otherUserRelation']=='F'){
              newPostMap = Post(
                type: 'image',
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                postUrl: postUrl,
                caption: caption,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            } else{
              newPostMap = Post(
                type: 'image',
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                postUrl: postUrl,
                caption: caption,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                timestamp: Timestamp.now(),
              );
            }
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMap(newPostMap));
          }));
    } else if (relationType=='F' ){   //if user selects F, send post to connections - CF,F
      print(relationType);
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: 'CF').get().then((snapshot) {
        snapshot.docs.forEach((doc)  {
          print('connection id: ' + doc.data()['uid']);
          print('connection id: ' + doc.data()['otherUserRelation']);
          if (doc.data()['otherUserRelation']=='CF'){
            newPostMap = Post(
              type: 'image',
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              postUrl: postUrl,
              caption: caption,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          }else if (doc.data()['otherUserRelation']=='F'){
            newPostMap = Post(
              type: 'image',
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              postUrl: postUrl,
              caption: caption,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          } else{
            newPostMap = Post(
              type: 'image',
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              postUrl: postUrl,
              caption: caption,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              timestamp: Timestamp.now(),
            );
          }
          _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMap(newPostMap));
        });
      });
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: 'F').get().then((snapshot) {
        snapshot.docs.forEach((doc)  {
          print('connection id: ' + doc.data()['uid']);
          print('connection id: ' + doc.data()['otherUserRelation']);
          if (doc.data()['otherUserRelation']=='CF'){
            newPostMap = Post(
              type: 'image',
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              postUrl: postUrl,
              caption: caption,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          }else if (doc.data()['otherUserRelation']=='F'){
            newPostMap = Post(
              type: 'image',
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              postUrl: postUrl,
              caption: caption,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          } else{
            newPostMap = Post(
              type: 'image',
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              postUrl: postUrl,
              caption: caption,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              timestamp: Timestamp.now(),
            );
          }
          _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMap(newPostMap));
        });});
    } /*else if(relationType=='AQ') {    //if user selects AQ, send post to only AQ connection
      print(relationType);
      return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: relationType).get().then((snapshot) =>
          snapshot.docs.forEach((doc) {
            print('connection id: ' + doc.data()['uid']);
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap);
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).update({'myRelation': doc.data()['otherUserRelation']});
          }));
    }*/ else {     //if user selects All, send post to all connections - CF,F,AQ
      print(relationType);
      return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).get().then((snapshot) =>
          snapshot.docs.forEach((doc) {
            print('connection id: ' + doc.data()['uid']);
            print('connection id: ' + doc.data()['otherUserRelation']);
            if (doc.data()['otherUserRelation']=='CF'){
              newPostMap = Post(
                type: 'image',
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                postUrl: postUrl,
                caption: caption,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            }else if (doc.data()['otherUserRelation']=='F'){
              newPostMap = Post(
                type: 'image',
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                postUrl: postUrl,
                caption: caption,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            } else {
              newPostMap = Post(
                type: 'image',
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                postUrl: postUrl,
                caption: caption,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                timestamp: Timestamp.now(),
              );
            }
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMap(newPostMap));
          }));
    }
  }

  void AddMusePostToMyConnectionFeed(String name, String image, String postId, String museText, Timestamp timestamp, String relationType) async{
    Post newPostMap = Post();
    if(relationType=='CF') {    //if user selects CF, send post to only CF connection
      print(relationType);
      return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: relationType).get().then((snapshot) =>
          snapshot.docs.forEach((doc) {
            print('connection id: ' + doc.data()['uid']);
            print('connection id: ' + doc.data()['otherUserRelation']);
            if (doc.data()['otherUserRelation']=='CF'){
              newPostMap = Post.text(
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                type: 'text',
                postText: museText,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            }else if (doc.data()['otherUserRelation']=='F'){
              newPostMap = Post.text(
                type: 'text',
                postText: museText,
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            } else{
              newPostMap = Post.text(
                type: 'text',
                postText: museText,
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                timestamp: Timestamp.now(),
              );
            }
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMapMuse(newPostMap));
          }));
    } else if (relationType=='F' ){   //if user selects F, send post to connections - CF,F
      print(relationType);
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: 'CF').get().then((snapshot) {
        snapshot.docs.forEach((doc)  {
          print('connection id: ' + doc.data()['uid']);
          print('connection id: ' + doc.data()['otherUserRelation']);
          if (doc.data()['otherUserRelation']=='CF'){
            newPostMap = Post.text(
              type: 'text',
              postText: museText,
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          }else if (doc.data()['otherUserRelation']=='F'){
            newPostMap = Post.text(
              type: 'text',
              postText: museText,
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          } else{
            newPostMap = Post.text(
              type: 'text',
              postText: museText,
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              timestamp: Timestamp.now(),
            );
          }
          _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMapMuse(newPostMap));
        });
      });
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: 'F').get().then((snapshot) {
        snapshot.docs.forEach((doc)  {
          print('connection id: ' + doc.data()['uid']);
          print('connection id: ' + doc.data()['otherUserRelation']);
          if (doc.data()['otherUserRelation']=='CF'){
            newPostMap = Post.text(
              type: 'text',
              postText: museText,
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          }else if (doc.data()['otherUserRelation']=='F'){
            newPostMap = Post.text(
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              type: 'text',
              postText: museText,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              myRelation2: 'F',
              timestamp: Timestamp.now(),
            );
          } else{
            newPostMap = Post.text(
              postFrom: UniversalVariables.myPvtUid,
              postId: postId,
              postFor: relationType,
              name: name,
              type: 'text',
              postText: museText,
              image: image,
              myRelation1: doc.data()['otherUserRelation'],
              timestamp: Timestamp.now(),
            );
          }
          _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMapMuse(newPostMap));
        });});
    } /*else if(relationType=='AQ') {    //if user selects AQ, send post to only AQ connection
      print(relationType);
      return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).where('myRelation', isEqualTo: relationType).get().then((snapshot) =>
          snapshot.docs.forEach((doc) {
            print('connection id: ' + doc.data()['uid']);
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap);
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).update({'myRelation': doc.data()['otherUserRelation']});
          }));
    }*/ else {     //if user selects All, send post to all connections - CF,F,AQ
      print(relationType);
      return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateConnections).get().then((snapshot) =>
          snapshot.docs.forEach((doc) {
            print('connection id: ' + doc.data()['uid']);
            print('connection id: ' + doc.data()['otherUserRelation']);
            if (doc.data()['otherUserRelation']=='CF'){
              newPostMap = Post.text(
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                type: 'text',
                postText: museText,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            }else if (doc.data()['otherUserRelation']=='F'){
              newPostMap = Post.text(
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                type: 'text',
                postText: museText,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                myRelation2: 'F',
                timestamp: Timestamp.now(),
              );
            } else {
              newPostMap = Post.text(
                postFrom: UniversalVariables.myPvtUid,
                postId: postId,
                postFor: relationType,
                name: name,
                type: 'text',
                postText: museText,
                image: image,
                myRelation1: doc.data()['otherUserRelation'],
                timestamp: Timestamp.now(),
              );
            }
            _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap.toMapMuse(newPostMap));
          }));
    }
  }

  Stream<QuerySnapshot> getAllMyPvtFeeds() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFeeds).orderBy('timestamp',descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllCloseFriendsFeeds() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFeeds).where('myRelation1', isEqualTo: 'CF').orderBy('timestamp',descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllFriendsFeeds() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFeeds).where('myRelation2', isEqualTo: 'F').orderBy('timestamp',descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllAcquaintanceFeeds() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFeeds).where('myRelation1', isEqualTo: 'AQ').orderBy('timestamp',descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllPvtFollowingsFeeds() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFeeds).where('postFor', isEqualTo: 'Follower').orderBy('timestamp',descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllMyPvtPostImage() {
    return  _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privatePosts).where('type', isEqualTo: 'image').orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllPvtPostImageofOtherUser(String pvtId) {
   return  _db.collection(_userCollection).doc(pvtId).collection(_privatePosts).where('type', isEqualTo: 'image').orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllMyPvtPostMuse() {
    return  _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privatePosts).where('type', isEqualTo: 'text').orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllPvtPostMuseofOtherUser(String pvtId) {
    return  _db.collection(_userCollection).doc(pvtId).collection(_privatePosts).where('type', isEqualTo: 'text').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> addLikeToAPostInMyPvtFeed(Map likeMap, String postId, String posterId, String postFor, String postUrl) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFeeds).doc(postId).update({'isLiked': true});
      if(postFor=='Follower'){
        await _db.collection(_allUserCollection).doc('PRF - '+posterId).get().then((value) => _db.collection(_userCollection).doc(value.data()['pvtId']).collection(_profAccount).doc(posterId).collection(_profNotifications).doc(postId).set(likeMap));
        await _db.collection(_allUserCollection).doc('PRF - '+posterId).get().then((value) => _db.collection(_userCollection).doc(value.data()['pvtId']).collection(_profAccount).doc(posterId).collection(_profNotifications).doc(postId).update({'postUrl': postUrl, 'postId': postId}));
      }else{
        print(posterId);
        await _db.collection(_userCollection).doc(posterId).collection(_privateNotifications).doc(postId).set(likeMap);
        await _db.collection(_userCollection).doc(posterId).collection(_privateNotifications).doc(postId).update({'postUrl': postUrl, 'postId': postId});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeLikeFromAPostInMyPvtFeed(String postId, String posterId) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateFeeds).doc(postId).update({'isLiked': false});
      if(posterId.contains('-')){
        await _db.collection(_allUserCollection).doc('PRF - '+posterId).get().then((value) => _db.collection(_userCollection).doc(value.data()['pvtId']).collection(_profAccount).doc(posterId).collection(_profNotifications).doc(postId).delete());
      }else{
        print(posterId);
        await _db.collection(_userCollection).doc(posterId).collection(_privateNotifications).doc(postId).delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> dismissLikeNotificationFromAConnection(String postId) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateNotifications).doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ConversationSnippet>> getCFUserConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats);
    return _ref.where('myRelation', isEqualTo: 'CF').snapshots().map((snapshot) {
      print(snapshot.docs);
      return snapshot.docs.map((doc) {
        return ConversationSnippet.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<ConversationSnippet>> getFUserConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats);
    return _ref.where('myRelation', isEqualTo: 'F').snapshots().map((snapshot) {
      print(snapshot.docs);
      return snapshot.docs.map((doc) {
        return ConversationSnippet.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<ConversationSnippet>> getAQUserConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats);
    return _ref.where('myRelation', isEqualTo: 'AQ').snapshots().map((snapshot) {
      print(snapshot.docs);
      return snapshot.docs.map((doc) {
        return ConversationSnippet.fromFirestore(doc);
      }).toList();
    });
  }

  Stream<List<ConversationSnippet>> getFollowingUserConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats);
    return _ref.where('myRelation', isEqualTo: 'Following').snapshots().map((snapshot) {
      print(snapshot.docs);
      return snapshot.docs.map((doc) {
        return ConversationSnippet.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> movePvtRMToDM(String chattingWithId) async {
    print(chattingWithId);
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats).doc(chattingWithId).update({'typeOfConversation': 'Direct'});
  }

  Future<void> addThisPvtChatToSelective(String chattingWithId) async {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats).doc(chattingWithId).update({'InSelective': true});
  }

  Future<void> removeThisPvtChatFromSelective(String chattingWithId) async{
    await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats).doc(chattingWithId).update({'InSelective': false});
  }


  //-----------------------------------------professional queries-----------------------------------------//

  Future<bool> getProfAcStatus() async{
    try{
      DocumentSnapshot doc =  await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).get();
      return doc.data()['haveProfAc'];
    } catch(e){
      print(e);
      return false;
    }
  }

  Future<String> getProfUidIfUserHaveProfAc(String myPvtId) async {
    try{
      DocumentSnapshot doc =  await _db.collection(_userCollection).doc(myPvtId).get();
      bool haveAProfAc = doc.data()['haveProfAc'];
      String profUid;
      if(haveAProfAc==true){
        await _db.collection(_allUserCollection).where('pvtId',isEqualTo: myPvtId).get().then((snapshot) =>
            snapshot.docs.forEach((doc) {
              profUid = doc.data()['uid'];
            }));
      }
      return profUid;
    } catch(e){
      print(e);
      return 'null';
    }
  }

  Future<void> createProfUserInDB(Map prfUserMap) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(prfUserMap['profId']).set(prfUserMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createProfUserInAllUserCollection(Map UserMap) async {
    try {
      await _db.collection(_allUserCollection).doc('PRF - ' + UserMap['profId']).set(UserMap);
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getProfCurrentUserInfoStream(String myProfUid) {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).where('uid', isEqualTo: myProfUid).snapshots();
  }

  Future<Map> getProfCurrentUserInfo() async{
    try{
      print('In get prof current user Info');
      print(UniversalVariables.myPvtUid);
      print('Prof uid :');
      print(UniversalVariables.myProfUid);
      DocumentSnapshot doc =  await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).get();
      return doc.data();
    } catch(e){
      print(e);
    }
  }



  //prof search page
  Stream<QuerySnapshot> getAllProfUsers() {
    return _db.collection(_allUserCollection).where('accountType', isEqualTo: 'Professional').snapshots();
  }


  Future<void> sendFollowingConfirmation(Map myFollowingMap, String otherUserPvtId) async {
    try {
      // print('In send following confirmation');
      // print(myfollowingMap);
      await _db.collection(_userCollection).doc(otherUserPvtId).collection(_profAccount).doc(myFollowingMap['To']).collection(_profNotifications).doc(myFollowingMap['From']).set(myFollowingMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> dismissFollowerNotification(String otherUserUid) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profNotifications).doc(otherUserUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFollowerNotification(String otherUserPvtId, String otherUserProfId, String myUid) async {
    try {
      await _db.collection(_userCollection).doc(otherUserPvtId).collection(_profAccount).doc(otherUserProfId).collection(_profNotifications).doc(myUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removePvtFollower(String followerPvtId) async {
    try {
      await _db.collection(_userCollection).doc(followerPvtId).collection(_privateFollowings).doc(UniversalVariables.myProfUid).delete();
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowers).doc(followerPvtId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeProfFollower(String followerProfId) async {
    print('FollowerId :');
    print(followerProfId);
    try {
      DocumentSnapshot doc = await _db.collection(_allUserCollection).doc('PRF - '+followerProfId).get();
      print(doc.data());
      await _db.collection(_userCollection).doc(doc.data()['pvtId']).collection(_profAccount).doc(followerProfId).collection(_profFollowings).doc(UniversalVariables.myProfUid).delete();
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowers).doc(followerProfId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMeAsAFollower(String otherUserPvtUid, String otherUserProfUid, bool navigatedFromPrivateAc, String myUid) async {    //myUid can be my pvtUid or profUid depending from which accountType I'll want to become a follower
    try {
      if(navigatedFromPrivateAc){
        String url;
        DocumentSnapshot doc = await _db.collection(_allUserCollection).doc('PVT - '+myUid).get();
        doc.data()['privateUrl'] != null ? url= doc.data()['privateUrl']: url=UniversalVariables.defaultImageUrl;
        await _db.collection(_userCollection).doc(otherUserPvtUid).collection(_profAccount).doc(otherUserProfUid).collection(_profFollowers).doc(myUid).set({'uid': myUid, 'name': doc.data()['fullname'], 'url': url, 'myRelation': 'Follower', 'userAcType': 'private'});
      } else{
        DocumentSnapshot doc = await _db.collection(_allUserCollection).doc('PRF - '+myUid).get();
        await _db.collection(_userCollection).doc(otherUserPvtUid).collection(_profAccount).doc(otherUserProfUid).collection(_profFollowers).doc(myUid).set({'uid': myUid, 'name': doc.data()['BusinessName'], 'url': doc.data()['profUrl'], 'myRelation': 'Follower', 'userAcTye': 'professional', 'pvtId': UniversalVariables.myPvtUid});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> incrementMyProfFollowing(String otherUserUid) async {
    try {
      DocumentSnapshot doc =  await _db.collection(_allUserCollection).doc('PRF - '+otherUserUid).get();
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowings).doc(otherUserUid).set({'uid': otherUserUid, 'name': doc.data()['BusinessName'], 'url': doc.data()['profUrl']});
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeMeAsAFollower(String otherUserPvtUid, String otherUserProfUid, String myUid) async { //myUid can be my pvtUid or profUid depending from which accountType I'll unfollow
    try {
      await _db.collection(_userCollection).doc(otherUserPvtUid).collection(_profAccount).doc(otherUserProfUid).collection(_profFollowers).doc(myUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> decrementMyProfFollowing(String otherUserUid) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowings).doc(otherUserUid).delete();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getProfNotifications() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profNotifications).snapshots();
  }

  Future<bool> checkUserExistsInMyProfFollowing(String otherUserUid) async {
    bool exists = false;
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowings).doc(otherUserUid).get().then((doc) {
        doc.exists ? exists = true : exists = false;
      });
      return exists;
    } catch(e){
      print(e);
      return false;
    }
  }

  Future<int> getProfFollowingCountOfAUser(String pvtUid, String profUid) async {
    try {
      QuerySnapshot followings = await _db.collection(_userCollection).doc(pvtUid).collection(_profAccount).doc(profUid).collection(_profFollowings).get();
      List<DocumentSnapshot> followingCount = followings.docs;
      return followingCount.length;
    } catch(e){
      print(e);
      return 0;
    }
  }

  Future<int> getProfFollowersCountOfAUser(String pvtUid, String profUid) async {
    try {
      QuerySnapshot followers = await _db.collection(_userCollection).doc(pvtUid).collection(_profAccount).doc(profUid).collection(_profFollowers).get();
      List<DocumentSnapshot> followerCount = followers.docs;
      return followerCount.length;
    } catch(e){
      print(e);
      return 0;
    }
  }

  Stream<QuerySnapshot> getAllMyProfFollowers() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowers).snapshots();
  }

  Stream<QuerySnapshot> getAllMyProfFollowings() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowings).snapshots();
  }


  void uploadProfPost(Map newPostMap, String postId) async {
    return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profPosts).doc(postId).set(newPostMap);
    //await _db.collection('Posts').doc().set(newPostMap);
  }

  void AddMyProfPostToMyFollowersFeed(Map newPostMap, String relationType, String postId) async{
    return await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFollowers).get().then((snapshot){
      print(snapshot.docs);
      snapshot.docs.forEach((doc) async {
        if(doc.data()['userAcType']=='private'){
          await _db.collection(_userCollection).doc(doc.data()['uid']).collection(_privateFeeds).doc(postId).set(newPostMap);
        } else{
          await _db.collection(_userCollection).doc(doc.data()['pvtId']).collection(_profAccount).doc(doc.data()['uid']).collection(_profFeeds).doc(postId).set(newPostMap);
        }
      });});
  }

  Stream<QuerySnapshot> getAllMyProfFeeds() {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFeeds).orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllMyProfPostImage() {
    return  _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profPosts).where('type', isEqualTo: 'image').orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllProfPostImageofOtherUser(String pvtId, String profId) {
    return _db.collection(_userCollection).doc(pvtId).collection(_profAccount).doc(profId).collection(_profPosts).where('type', isEqualTo: 'image').orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllMyProfPostMuse() {
    return  _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profPosts).where('type', isEqualTo: 'text').orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getAllProfPostMuseofOtherUser(String pvtId, String profId) {
    return _db.collection(_userCollection).doc(pvtId).collection(_profAccount).doc(profId).collection(_profPosts).where('type', isEqualTo: 'text').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> addLikeToAPostInMyProfFeed(Map likeMap, String postId, String posterId, String postFor, String postUrl) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFeeds).doc(postId).update({'isLiked': true});
      await _db.collection(_allUserCollection).doc('PRF - '+posterId).get().then((value) => _db.collection(_userCollection).doc(value.data()['pvtId']).collection(_profAccount).doc(posterId).collection(_profNotifications).doc(postId).set(likeMap));
      await _db.collection(_allUserCollection).doc('PRF - '+posterId).get().then((value) => _db.collection(_userCollection).doc(value.data()['pvtId']).collection(_profAccount).doc(posterId).collection(_profNotifications).doc(postId).update({'postUrl': postUrl, 'postId': postId}));
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeLikeFromAPostInMyProfFeed(String postId, String posterId) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profFeeds).doc(postId).update({'isLiked': false});
      await _db.collection(_allUserCollection).doc('PRF - '+posterId).get().then((value) => _db.collection(_userCollection).doc(value.data()['pvtId']).collection(_profAccount).doc(posterId).collection(_profNotifications).doc(postId).delete());
    } catch (e) {
      print(e);
    }
  }

  Future<void> dismissLikeNotificationFromAFollower(String postId) async {
    try {
      await _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profNotifications).doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Stream<List<ConversationSnippet>> getProfUserDirectConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profChats);
    return _ref.where('typeOfConversation', isEqualTo: 'Direct').snapshots().map((_snapshot) {
      // _snapshot is an instance of query snapshot
      return _snapshot.docs.map((_doc) {//_doc is an instance of query doc snapshot
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<ConversationSnippet>> getProfUserRequestConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profChats);
    return _ref.where('typeOfConversation', isEqualTo: 'Request').snapshots().map((_snapshot) {
      // _snapshot is an instance of query snapshot
      return _snapshot.docs.map((_doc) {//_doc is an instance of query doc snapshot
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Future<void> moveProfRMToDM(String chattingWithId) async {
    print(chattingWithId);
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profChats).doc(chattingWithId).update({'typeOfConversation': 'Direct'});
  }

  Future<void> addThisProfChatToSelective(String chattingWithId) async {
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profChats).doc(chattingWithId).update({'InSelective': true});
  }

  Future<void> removeThisProfChatFromSelective(String chattingWithId) async{
    return _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profChats).doc(chattingWithId).update({'InSelective': false});
  }


  //-----------------------------------------Chats-----------------------------------------//

  Future<void> sendMessage(String chatRoomId, Message _message) {
    print(chatRoomId +' in send message');
    var _ref = _db.collection(_allChats).doc(chatRoomId);
    var _messageType = '';
    switch (_message.type) {
      case MessageType.Text:
        _messageType = 'text';
        break;
      case MessageType.Image:
        _messageType = 'image';
        break;
      default:
    }
    return _ref.update({
      'messages': FieldValue.arrayUnion(
        [
          {
            'content': _message.content,
            'senderId': _message.senderId,
            'timestamp': _message.timestamp,
            'type': _messageType,
          },
        ],
      ),
    });
  }

  Stream<ConversationEssentials> getConversation(String chatRoomId) {
    var _ref = _db.collection(_allChats).doc(chatRoomId);
    return _ref.snapshots().map((_doc) {return ConversationEssentials.fromFirestore(_doc);},);
  }

  Future<void> createOrGetConversation(String otherUserUid,String ownerAcType, String receiverAcType, Future<void> Function(String chatRoomId) _onSuccess) async {

    var ref = _db.collection(_allChats);
    var userConversationRef;
    if(ownerAcType=='Private') {
        userConversationRef = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats);

      try {
        var chat = await userConversationRef.doc(otherUserUid).get();
        print(chat.data());
        if (chat.data() != null) {
          return _onSuccess(chat.data()['chatRoomId']);
        } else {
          var conversationRef = ref.doc();
          await conversationRef.set(
            { 'members': [UniversalVariables.myPvtUid, otherUserUid],
              'ownerId': UniversalVariables.myPvtUid,
              'ownerAcType' : ownerAcType,
              'receiverAcType' : receiverAcType,
              'messages': [],
            },
          );
          print(conversationRef.id);
          return _onSuccess(conversationRef.id);
        }
      } catch (e) {
        print(e);
      }
    } else{
      userConversationRef = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profChats);
      print('Prof to prof chat');
      try {
        var chat = await userConversationRef.doc(otherUserUid).get();
        print(chat.data());
        if (chat.data() != null) {
          return _onSuccess(chat.data()['chatRoomId']);
        } else {
          var conversationRef = ref.doc();
          await conversationRef.set(
            { 'members': [UniversalVariables.myProfUid, otherUserUid],
              'ownerId': UniversalVariables.myProfUid,
              'ownerAcType' : ownerAcType,
              'receiverAcType' : receiverAcType,
              'messages': [],
            },
          );
          print(conversationRef.id);
          print(chat.data()['chatRoomId']);
          return _onSuccess(conversationRef.id);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Stream<List<ConversationSnippet>> getPvtSelectiveConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_privateChats);
    return _ref.where('InSelective', isEqualTo: true).snapshots().map((_snapshot) {
      // _snapshot is an instance of query snapshot
      return _snapshot.docs.map((_doc) {//_doc is an instance of query doc snapshot
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<ConversationSnippet>> getProfSelectiveConversations() {
    var _ref = _db.collection(_userCollection).doc(UniversalVariables.myPvtUid).collection(_profAccount).doc(UniversalVariables.myProfUid).collection(_profChats);
    return _ref.where('InSelective', isEqualTo: true).snapshots().map((_snapshot) {
      // _snapshot is an instance of query snapshot
      return _snapshot.docs.map((_doc) {//_doc is an instance of query doc snapshot
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

}
