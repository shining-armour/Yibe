import 'dart:async';
import 'dart:io';
import 'package:yibe_final_ui/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:yibe_final_ui/pages/PostImage.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';

class Gallery extends StatefulWidget {
  Gallery({Key key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  static List categoryList = ["Media", "Muse", "Stories"];
  static const MethodChannel _channel = const MethodChannel('photo_gallery');
  final TextEditingController _museTextController = TextEditingController();
  bool _isPrivate = true;
  Color green = Color(0xFF0CB5BB);
  Color blue = Color(0xFF424283);
  bool isFriend = true;
  bool isCloseFriend = true;
  bool isEveryOne = true;
  Map profUserMap;
  Post newPostMap = Post();
  var uuid = Uuid();
  String postFor='All';
  bool getList = true;
  List<Medium> photos;
  int activeCategory = 0;
  bool selected = false;
  String selectImageId = '';
  @override
  void initState() {
    super.initState();
    getListOfImages();
    DatabaseService.instance.getProfCurrentUserInfo().then((value) => setState(() {
      profUserMap = value;
    }));
  }

  void _uploadNewPvtPost(String text, String postId) {
    print(postFor);
    DatabaseService.instance.getPvtProfileUrlofAUser(
        UniversalVariables.myPvtUid).then((value) {
      String image = value ?? UniversalVariables.defaultImageUrl;
      newPostMap = Post.text(
        postFrom: UniversalVariables.myPvtUid,
        postId: postId,
        postFor: postFor,
        name: UniversalVariables.myPvtFullName,
        image: image,
        type: 'text',
        postText: text,
        timestamp: Timestamp.now(),
      );

      DatabaseService.instance.uploadPvtPost(newPostMap.toMapMuse(newPostMap), postId);
      DatabaseService.instance.AddMusePostToMyConnectionFeed(UniversalVariables.myPvtFullName, image, postId,text,Timestamp.now(), postFor);
      NavigationService.instance.goBack();
    });
  }

  void _uploadNewProfPost(String text, String postId) {

    Post newPostMap = Post.text(
      postFrom: UniversalVariables.myProfUid,
      postId: postId,
      postFor: 'Follower',
      name: profUserMap['BusinessName'],
      image: profUserMap['profUrl'],
      type: 'text',
      postText: text,
      timestamp: Timestamp.now(),
    );
    DatabaseService.instance.uploadProfPost(newPostMap.toMapMuse(newPostMap), postId);
    DatabaseService.instance.AddMyProfPostToMyFollowersFeed(newPostMap.toMapMuse(newPostMap), 'Follower', postId);
    NavigationService.instance.goBack();
  }


  Future<void> getListOfImages() async {
    if (await _promptPermissionSetting()) {
      List<Album> photoalbum =
      await PhotoGallery.listAlbums(mediumType: MediumType.image);
      MediaPage _photos = await photoalbum[1].listMedia(take: 10);
      setState(() {
        photos = _photos.items;
        getList = false;
        selectImageId = photos[0].id;
      });
    }
    setState(() {
      getList = false;
    });
  }

  static Future<MediaPage> listMedia({
    @required Album album,
    @required int total,
    int skip,
    int take,
  }) async {
    assert(album.id != null);
    final json = await _channel.invokeMethod('listMedia', {
      'albumId': album.id,
      'mediumType': mediumTypeToJson(album.mediumType),
      'total': total,
      'skip': skip,
      'take': take,
    });
    return MediaPage.fromJson(album, json);
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
        await Permission.storage.request().isGranted &&
        await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(46.0),
          child: AppBar(
            backgroundColor: Colors.white,
            actions: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        "assets/images/back_btn.svg",
                        width: 30,
                      ),
                    ),
                    Spacer(),
                   activeCategory !=1 ?  GestureDetector(
                        onTap: () async {
                          final File file = await PhotoGallery.getFile(mediumId: selectImageId);
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PostImage(selectedImage: file,);
                          }));
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.black, fontSize: 25.0),
                        )) : Container(),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              Container(
                height: 40.0,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoryList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          changeCategory(index);
                        },
                        child: Container(
                          padding: index == 0
                              ? EdgeInsets.only(top: 6.0, bottom: 6.0, left: 20)
                              : index == 1
                              ? EdgeInsets.only(
                              top: 6.0,
                              bottom: 6.0,
                              left: 100.0,
                              right: 100.0)
                              : EdgeInsets.only(
                              top: 6.0, bottom: 6.0, right: 20.0),
                          child: Text(
                            categoryList[index],
                            style: TextStyle(
                                fontSize: 20.0,
                                color: activeCategory == index
                                    ? Colors.black
                                    : Colors.grey),
                          ),
                        ),
                      );
                    }),
              ),
              activeCategory == 0
                  ? getList
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : gridImage()
                  : activeCategory ==1 ? postMuse() : Container()
            ]),
          ),
        ));
  }

  void changeCategory(int index) {
    activeCategory = index;
    setState(() {});
  }

  Widget postMuse(){
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5),
        child: Column(children: [
          Container(
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(
                  color: _isPrivate ? green : blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPrivate = !_isPrivate;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _isPrivate ? green : Colors.white,
                            border: Border.all(
                                color: _isPrivate ? green : Colors.white,
                                width: 2),
                            borderRadius:
                            BorderRadius.all(Radius.circular(100))),
                        child: Text(
                          "Private",
                          style: TextStyle(
                              color:
                              _isPrivate ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    )),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPrivate = !_isPrivate;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _isPrivate ? Colors.white : blue,
                            border: Border.all(
                                color: _isPrivate ? Colors.white : blue,
                                width: 2),
                            borderRadius:
                            BorderRadius.all(Radius.circular(100))),
                        child: Text(
                          "Professional",
                          style: TextStyle(
                              color:
                              _isPrivate ? Colors.grey : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: _museTextController,
              maxLines: 5,
              decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color(0xFF0CB5BB), width: 2.0),
                  ),
                  hintText: 'Type your muse'),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _isPrivate
              ? Column(
            // for private account
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCloseFriend = true;
                        isEveryOne = false;
                        isFriend = false;
                        postFor = 'CF';
                      });
                    },
                    child: Text(
                      'Close Friends',
                      style: TextStyle(
                        color: isCloseFriend
                            ? Colors.black
                            : Color(0xFFA7A7A7),
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '>',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 20.0,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCloseFriend = true;
                        isEveryOne = false;
                        isFriend = true;
                        postFor = 'F';
                      });
                    },
                    child: Text(
                      'Friends',
                      style: TextStyle(
                        color: isFriend
                            ? Colors.black
                            : Color(0xFFA7A7A7),
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '>',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 20.0,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCloseFriend = true;
                        isEveryOne = true;
                        isFriend = true;
                        postFor = 'All';
                      });
                    },
                    child: Text(
                      'Everyone',
                      style: TextStyle(
                        color: isEveryOne
                            ? Colors.black
                            : Color(0xFFA7A7A7),
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Spacer(),
                ]),
              ),
              Center(
                child: Text(
                  'Slide into your friendzone ',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontFamily: 'Poppins',
                    fontSize: 10.0,
                  ),
                ),
              ),
            ],
          )
              : Center(
            child: Text(
              ' Professional posts are always public. ',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Poppins',
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: FlatButton(
                      onPressed: () async {
                        _isPrivate ? _uploadNewPvtPost(_museTextController.text, uuid.v4()) : _uploadNewProfPost(_museTextController.text, uuid.v4());
                      },
                      color: _isPrivate ? green : blue,
                      child: Text('Post',
                          style: TextStyle(color: Colors.white))))),
        ]));
  }

  Widget gridImage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double gridWidth = (constraints.maxWidth - 20) / 3;
        double gridHeight = gridWidth + 33;
        double ratio = gridWidth / gridHeight;
        return Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Container(
                    color: Colors.grey[300],
                    height: gridWidth,
                    width: gridWidth,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: AssetImage(
                          'assets/images/photo-placeholder-icon-7.jpg'),
                      image: PhotoProvider(
                          mediumId: selected ? selectImageId : photos[0].id),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: ratio,
                crossAxisCount: 3,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                children: <Widget>[
                  ...? photos ?.map(
                        (photo) => GestureDetector(
                      onTap: () {
                        changeSelectedImage(photo.id);
                      },
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.grey[300],
                              height: gridWidth,
                              width: gridWidth,
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder: AssetImage(
                                    'assets/images/photo-placeholder-icon-7.jpg'),
                                image: PhotoProvider(mediumId: photo.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void changeSelectedImage(String imageId) {
    setState(() {selected = true; selectImageId = imageId;});
  }
}