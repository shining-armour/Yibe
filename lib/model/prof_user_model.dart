class ProfUserModel{

  String profId;
  String pvtId;
  String accountType;
  String businessName;
  String businessBio;
  String profUrl;
  String profUserName;
  String fcmToken;

  ProfUserModel({this.profId, this.pvtId,this.accountType, this.businessName, this.profUserName,this.businessBio,this.profUrl, this.fcmToken});

  Map toMap(ProfUserModel userMap) {
    var data = <String, String>{};
    data['profId'] = userMap.profId;
    data['pvtId'] = userMap.pvtId;
    data['accountType'] = userMap.accountType;
    data['BusinessName'] = userMap.businessName;
    data['BusinessBio'] = userMap.businessBio;
    data['profUrl'] = userMap.profUrl;
    data['fcmToken'] = userMap.fcmToken;
    data['profUserName'] = userMap.profUserName;
    return data;
  }

}