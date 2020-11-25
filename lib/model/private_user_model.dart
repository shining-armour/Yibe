class PrivateUserModel{

  String pvtid;
  String profId;
  String fullname;
  String username;
  String emailId;
  String accountType;
  String privateUrl;
  String pvtBio;
  String fcmToken;
  bool haveProfAc;
  List interests;

  PrivateUserModel({this.pvtid, this.profId, this.fullname, this.username, this.emailId,this.accountType,this.privateUrl, this.pvtBio, this.fcmToken, this.haveProfAc, this.interests});

  Map toMap(PrivateUserModel userMap) {
    var data = <String, dynamic>{};
    data['profId'] = userMap.profId;
    data['pvtId'] = userMap.pvtid;
    data['fullname'] = userMap.fullname;
    data['username'] = userMap.username;
    data['emailId'] = userMap.emailId;
    data['accountType'] = userMap.accountType;
    data['privateUrl'] = userMap.privateUrl;
    data['pvtBio'] = userMap.pvtBio;
    data['fcmToken'] = userMap.fcmToken;
    data['haveProfAc'] = userMap.haveProfAc;
    data['interests'] = userMap.interests;
    return data;
  }

}