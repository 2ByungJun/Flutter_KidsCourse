import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pkidscoures/TeacherView/Attend/AttendUpdate.dart';

import '../PageManager.dart';
import 'AttendCreate.dart';

  final _url = PageManagerView.url;

  Future<List> fetchBaby() async {
    http.Response _res = await http.get(_url + "/baby");
    List<dynamic> _resBody = json.decode(_res.body);
    return _resBody;
  }

  class AttendView extends StatefulWidget {
    @override
    _AttendViewState createState() => _AttendViewState();
  }


  Future<List> fetchCourse() async {
    http.Response _res = await http.get(_url + "/babyCourseList");
    List<dynamic> _resBody = json.decode(_res.body);
    return _resBody;
  }

  var addressIdx = '';
  var address = '';
  var addressDetail = '';
  class _AttendViewState extends State<AttendView> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: FutureBuilder<List>(
          future: fetchBaby(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return !snapshot.hasData ? Center(
                child: CircularProgressIndicator()) :
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.69,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          color: Colors.orange[50]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onLongPress: ()async{
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text('??????????????? ?????????????????????????' , style: TextStyle(fontWeight: FontWeight.bold),),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('??????'),
                                            onPressed: () async{
                                              await  http.post( _url + '/babyDelete', body: {
                                                "id": snapshot.data[index]['id'].toString()
                                              });
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('??????'),
                                            onPressed: (){
                                              Navigator.pop(context, "??????");
                                            },
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                              onTap: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 150.0,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(10.0),
                                              child: Text(snapshot.data[index]['fields']['BabyName'].toString() + ' ????????? ?????????????????????.', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                            ),

                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: Text("?????? ??????",
                                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                                                    ),
                                                    color: Colors.orange[300],
                                                    onPressed: () async {
                                                      if(snapshot.data[index]['fields']['attend'].toString() == "??????"){
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context){
                                                              return AlertDialog(
                                                                title: Text('?????? ???????????? ???????????????.', style: TextStyle(fontWeight: FontWeight.bold),),
                                                                content: Text('?????? ????????? ???????????? ???????????????.'),
                                                                actions: <Widget>[
                                                                  FlatButton(
                                                                    child: Text('?????? ??????'),
                                                                    onPressed: () async{
                                                                      await  http.post( _url + '/babyAttend', body: {
                                                                          "id": snapshot.data[index]['id'].toString(),
                                                                          "attend": snapshot.data[index]['fields']['attend'].toString()
                                                                          });
                                                                        setState(() {});
                                                                        Navigator.pop(context);
                                                                      },
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text('??????'),
                                                                    onPressed: (){
                                                                      Navigator.pop(context, "??????");
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            }
                                                        );
                                                      }else{
                                                        await  http.post( _url + '/babyAttend', body: {
                                                          "id": snapshot.data[index]['id'].toString(),
                                                          "attend": snapshot.data[index]['fields']['attend'].toString()
                                                        }).then((value) => {
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext context){
                                                                return AlertDialog(
                                                                  title: Text('?????? ?????? ???????????????.', style: TextStyle(fontWeight: FontWeight.bold),),
                                                                  actions: <Widget>[
                                                                    FlatButton(
                                                                      child: Text('??????'),
                                                                      onPressed: () {
                                                                        setState(() {});
                                                                        Navigator.pop(context);
                                                                      },
                                                                    )
                                                                  ],
                                                                );
                                                             }
                                                            )
                                                        });
                                                      }
                                                    },
                                                  ),

                                                  CupertinoButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendUpdate(id: snapshot.data[index]['id'].toString(),)));
                                                    },
                                                    child: Text("?????? ??????",
                                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                                                    ),
                                                    color: Colors.purple[300],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Center(child: Text(snapshot.data[index]['fields']['BabyName'].toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                            ),

                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: <Widget>[
                                                  Text('???????????? : ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                  Text(snapshot.data[index]['fields']['ParentsName'].toString(), style: TextStyle(fontSize: 12))
                                                ],
                                              ),
                                            ),

                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: <Widget>[
                                                  Text('????????? : ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                  Text(snapshot.data[index]['fields']['Phone'].toString(), style: TextStyle(fontSize: 12))
                                                ],
                                              ),
                                            ),

                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: <Widget>[
                                                  Text('?????? ???????????? : ',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                  Text(snapshot.data[index]['fields']['attend'].toString(), style: TextStyle(fontSize: 12))
                                                ],
                                              ),
                                            ),

                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: <Widget>[
                                                  Text('????????? ?????? : ',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                  Text(snapshot.data[index]['fields']['Address'].toString(), style: TextStyle(fontSize: 12))
                                                ],
                                              ),
                                            ),

                                            Container(
                                              width: 55.0,
                                              height: 55.0,
                                              margin: EdgeInsetsDirectional.only(top: 5.0),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(snapshot.data[index]['fields']['attendImage'].toString()),fit: BoxFit.contain
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendCreate())).then((value){
              setState((){});
            });
          },
          label: Text("????????????", style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: Icon(Icons.person_add),
          backgroundColor: Color(0xFF7087F0),
        ),
      );
    }
}
