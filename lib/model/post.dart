import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String postFrom;
  String postId;
  String postFor;
  String name;
  String image;
  String postUrl;
  String caption;
  String myRelation1;
  String myRelation2;
  Timestamp timestamp;
  String postText;
  String type;

  Post({this.postFrom,this.postId, this.postFor, this.postUrl, this.type,this.name, this.image, this.caption, this.timestamp, this.myRelation1, this.myRelation2});
  Post.text({this.postFrom,this.postId, this.postFor, this.postText, this.name, this.type, this.image, this.timestamp, this.myRelation1, this.myRelation2});

  Map toMap(Post newPost) {
    var map = <String, dynamic>{};
    map['type'] = newPost.type;
    map['postFrom'] = newPost.postFrom;
    map['name'] = newPost.name;
    map['image'] = newPost.image;
    map['postId'] = newPost.postId;
    map['postFor'] = newPost.postFor;
    map['postUrl'] = newPost.postUrl;
    map['caption'] = newPost.caption;
    map['timestamp'] = newPost.timestamp;
    map['myRelation1'] = newPost.myRelation1;
    map['myRelation2'] = newPost.myRelation2;
    return map;
  }

  Map toMapMuse(Post newPost) {
    var map = <String, dynamic>{};
    map['type'] = newPost.type;
    map['postFrom'] = newPost.postFrom;
    map['name'] = newPost.name;
    map['image'] = newPost.image;
    map['postId'] = newPost.postId;
    map['postFor'] = newPost.postFor;
    map['postText'] = newPost.postText;
    map['timestamp'] = newPost.timestamp;
    map['myRelation1'] = newPost.myRelation1;
    map['myRelation2'] = newPost.myRelation2;
    return map;
  }

}