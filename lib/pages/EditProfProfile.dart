import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yibe_final_ui/services/database.dart';
import 'package:yibe_final_ui/services/storage_service.dart';
import 'package:yibe_final_ui/utils/constants.dart';
import 'package:yibe_final_ui/services/navigation_service.dart';
import 'package:yibe_final_ui/services/media_service.dart';


class EditProfProfile extends StatefulWidget {

  @override
  _EditProfProfileState createState() => _EditProfProfileState();
}

class _EditProfProfileState extends State<EditProfProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'edit-private');
  final TextEditingController _addBusinessBio = TextEditingController();
  File _profImage;
  String profUrl;

  @override
  void dispose() {
    _addBusinessBio.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DatabaseService.instance.getProfCurrentUserInfo().then((value) => setState(() {
        profUrl = value['profUrl'];
        _addBusinessBio.text = value['BusinessBio'];
      }));
    }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(46.0),
              child: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
              ),
            ),
            body: Center(
                child:  Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Tap the image to change profile pic',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[700], fontSize: 15.0)),

                        SizedBox(height: 20.0),

                        InkWell(
                            onTap: () => _bottomSheet(context), //open camera or gallery
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _profImage != null ? FileImage(_profImage) : NetworkImage(profUrl),
                            )),
                        TextFormField(
                          controller: _addBusinessBio,
                          decoration: const InputDecoration(labelText: 'Professional Bio'),
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'bio cannot be empty';
                            }
                            return null;
                          },
                        ),
                        Spacer(),
                        FlatButton(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                            color: primaryColor,
                            child: Text('Save'),
                            onPressed: () async {
                              StorageService.instance.uploadProfProfilePic(_profImage, UniversalVariables.myPvtUid).then((value) {
                                print(value);
                                DatabaseService.instance.updateProfUserInfo(_addBusinessBio.text, value);
                              });
                              NavigationService.instance.goBack();
                            }
                        ),
                      ],
                    ),
                  ),
                ))
        ));
  }


  void _bottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.add_a_photo, color: primaryColor),
                    hoverColor: primaryColor,
                    title: Text('Camera'),
                    onTap:  () async {
                      File _image = await MediaService.instance.getCamImage();
                      setState(() {
                        _profImage = _image;
                      });
                      NavigationService.instance.goBack();
                    }
                ),
                ListTile(
                    leading: Icon(
                      Icons.add_photo_alternate, color: primaryColor,),
                    hoverColor: primaryColor,
                    title: Text('Gallery'),
                    onTap:  () async {
                      File _image = await MediaService.instance.getGalleryImage();
                      setState(() {
                        _profImage = _image;
                      });
                      NavigationService.instance.goBack();
                    }
                ),
              ],
            ),
          );
        }
    );
  }

}