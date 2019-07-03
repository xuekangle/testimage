import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testimage/models/Person.dart';
import 'package:testimage/utils/EncodeUtil.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  File _image;
  var _type;
  var _base64;

  Future _selectedImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  searchFace() {
    EncodeUtil.imageFile2Base64(_image).then((base64) async {
      _base64 = base64;
      _type = "person";
      getResult(_type,_base64);
    });
//    List<Person> personList = await
  }

  getResult(String type,String base64) async {
    Map<String, dynamic> param = {
      'type': type,
      'content': _base64
    };
    try {
      final http.Response response = await http.post(
          'http://47.104.135.205:8801/person/search',
          body: json.encode(param),
          encoding: Utf8Codec(),
          headers: {"Content-Type":"application/json"}
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      print('$responseData 数据');
      
    } catch (error) {
      print('$error错误');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索好友"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text("请选择换一张图片，搜索相似的人！",style: new TextStyle(color: Colors.red),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              onPressed: _selectedImage,
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              onPressed: getImage,
                              tooltip: "image picker",
                              icon: Icon(Icons.add_a_photo),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 200,
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(10),
              child: Center(
                child: _image == null
                    ? Text("no image selected!")
                    : Image.file(_image),
              )
            ),
            Container(
              child: Center(
                child: _base64 == null
                    ? Text("base64 is null.")
                    : Text.rich(_base64),
              ),
            )
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: searchFace,
        ),
      ],
    );
  }
}
