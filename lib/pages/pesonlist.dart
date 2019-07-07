import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class PersonList extends StatefulWidget {
  final List data;
  PersonList({this.data});
  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("人员列表"),
      ),
      body: Center(
        child: getBody(),
      ),
    );
  }
  getBody(){
    print(widget.data);
    if(widget.data.length != 0){
      return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context,int position){
          return getItem(widget.data[position]);
        },
      );
    }else{
      //加载菊花
      return CupertinoActivityIndicator();
    }
  }
  getItem(var person){
    var row = Container(
      margin: EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              person['_source']['imageUrl'],
              width: 100.0, height: 150.0,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8.0),
                height: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
//                    personId
                    Text(
                      person['_source']['personId'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                      maxLines: 1,
                    ),
//                    imageId
//                    Text(
//                      'imageId：${person['_source']['imageId']}',
//                      style: TextStyle(
//                          fontSize: 16.0
//                      ),
//                    ),
//                    类型
                    Text(
                        "类型：${person['_source']['type']}"
                    ),
//                    来源
                    Text(
                        'source：${person['_source']['source']}'
                    ),
//                    是否在线
                    Text(
                      'online: ${person['_source']['online']}'
                    ),
//                    创建时间
                    Text(
                      'createTime: ${person['_source']['createTime']}'
                    ),
//                    相似度
                    Text(
//                        '相似度: ${person['_score']}'
                        '相似度： ${getScore(person['_score'])}'
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
    return Card(
      child: row,
    );
  }

  String getScore(double score) {
    var pows = pow(20,(2*score-1));
    var result = 2/(2+pows);
    return (result*100).toStringAsPrecision(2) + "%";
  }

}