import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constant/t_colors.dart';
import 'package:intl/intl.dart';

import 'package:timetable_admin/Business Logic/components/info.dart';

import '../../main.dart';


class AdvertisementsPage extends StatefulWidget {
  const AdvertisementsPage({super.key});

  @override
  State<AdvertisementsPage> createState() => _AdvertisementsPageState();
}

class _AdvertisementsPageState extends State<AdvertisementsPage> {
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController TitleValue = TextEditingController();
  TextEditingController ContentValue = TextEditingController();
  int? id;

  String advTitle ="Introductory seminar";
  String advContent ="Registration will close at 10:00 pm today. We will only accept registered students for the symposium and inform them of their name to apologize for not attending the lectures. to apologize for not attending the lectures.";

  Info _info=Info();
  String? deptValue = sharedPref.getString("dm_id");

  Future getData() async {
    var response = await _info.getRequest("${serverLink}/dep_advertisement/${deptValue}");

    if (response!='failed') {
      List resBody = response;
      print(resBody);
      return resBody;
    }
  }

  Future postData() async {
    var response = await _info.postRequest("http://127.0.0.1:8000/API/advertisement",{
      "Title":TitleValue.text,
      "Content":ContentValue.text,
      "DepartmentId":'1',
      "Date":"${DateTime.now()}",


    });
    if (response==true){
      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();
    }
    else{
      Text("${response.statusCode}");
    }
  }
  Future putData() async {
    var response = await _info.putRequest("http://127.0.0.1:8000/API/advertisement/${id.toString()}",{
      "Title":TitleValue.text,
      "Content":ContentValue.text,
      "DepartmentId":'1',
      "Date":"${DateTime.now()}",

    });
    if (response==true){

      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();    }
    else{
      Text("Error");
    }
  }
  Future deleteData() async {
    var response = await _info.deleteRequest("http://127.0.0.1:8000/API/advertisement/${id.toString()}");
    if (response==true){

      (context as Element).markNeedsBuild();
      Navigator.of(context).pop();    }
    else{
      Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            //color: TColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FutureBuilder(
            future: getData(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snap.connectionState == ConnectionState.done) {
                if (snap.hasError) {
                  return Center(child: Text("${snap.error}"));
                }

                if (snap.hasData && snap.data!=[]) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: snap.data!.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          child: Flexible(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: i % 2 == 0 ? TColors.white : TColors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: Offset(1, 3), // changes the position of the shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Text("${snap.data[i]['Title']}",
                                      style: TextStyle(fontWeight: FontWeight.bold),),
                                      PopupMenuButton(
                                          icon: Icon(
                                            Symbols.more_horiz_rounded,
                                            color: TColors.darkGray,
                                          ),
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    value: "0",
                                                    child: Text("Edit"),
                                                  onTap: (){
                                                    id=snap.data[i]['id'];
                                                    TitleValue=TextEditingController(text:"${snap.data[i]['Title']}");
                                                    ContentValue=TextEditingController(text:"${snap.data[i]['Content']}");
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Padding(
                                                              padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text("Edit the advertisement", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                                                                  IconButton(onPressed: (){
                                                                    Navigator.of(context).pop();
                                                                  }, icon: Icon(Symbols.close_rounded, color: TColors.black,))
                                                                ],
                                                              ),
                                                            ),
                                                            content: Container(
                                                              width: 885,
                                                              height: 800,
                                                              margin: EdgeInsets.only(left: 50, right: 50),
                                                              child: Form(
                                                                child: Column(
                                                                  children: [
                                                                    TextFormField(
                                                                      controller: TitleValue,
                                                                      decoration: InputDecoration(
                                                                          hintText: "Advertisement Title",
                                                                          border: OutlineInputBorder()),
                                                                    ),
                                                                    SizedBox(height: 16,),
                                                                    TextFormField(
                                                                      controller: ContentValue,
                                                                      decoration: InputDecoration(
                                                                      hintText: "Advertisement Content",
                                                                      border: OutlineInputBorder()),
                                                                      maxLines: 9,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            actions: [
                                                              OutlinedButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text("Cancel", style: TextStyle(color: TColors.darkBlue),),
                                                                style: OutlinedButton.styleFrom(
                                                                    side: BorderSide(
                                                                        color: TColors.darkBlue, width: 1)),
                                                              ),
                                      
                                                              // Edit Button
                                                              ElevatedButton(
                                                                onPressed: () {
                                      
                                                                  putData();
                            
                                                                },
                                                                child: Text("Edit", style: TextStyle(color: TColors.white),),
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: TColors.darkBlue,
                                                                ),
                                                              ),
                                                            ],
                                                            actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                                                          );
                                                        }
                                                        );
                                                  },
                                                ),
                                                PopupMenuItem(
                                                    value: "1",
                                                    child: Text(
                                                      "Delete",
                                                      style:
                                                          TextStyle(color: TColors.red),
                                                    ),
                                                  onTap: (){
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            width:400,
                                                            height: 180,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(top: 50, left: 50,right: 50),
                                                              child: Column(
                                                                children: [
                                                                  CircleAvatar(child: Icon(Symbols.warning_rounded, color: TColors.red,), backgroundColor: Color.fromRGBO(255, 31, 31, 0.1),),
                                                                  SizedBox(height: 22,),
                                                                  Text("Are you sure?",style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black), ),
                                                                  SizedBox(height: 11,),
                                                                  Text("The Advertisement will be deleted.", style: TextStyle( color: TColors.darkGray), ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  width: 120,
                                                                  height: 38,
                                                                  child: OutlinedButton(
                                                                    onPressed: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Text("No", style: TextStyle(color: TColors.red),),
                                                                    style: OutlinedButton.styleFrom(
                                                                        side: BorderSide(
                                                                            color: TColors.red, width: 1)),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 32,),
                                                                Container(
                                                                  width: 120,
                                                                  height: 38,
                                                                  child: ElevatedButton(
                                                                    onPressed: ()async{
                                                                      id=snap.data[i]['id'];
                                                                      await deleteData();
                                      
                                                                    },
                                                                    child: Text("Yes"),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: TColors.red,
                                                                        textStyle: TextStyle(color: TColors.white)
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                          actionsPadding: EdgeInsets.only(left: 50,right: 50, bottom: 40),
                                                        );
                                                      },
                                                    );
                                                  },
                                      
                                                )
                                      
                                      
                                              ]),
                                    ],
                                  ),
                                  Text("${snap.data[i]['Content']}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 6,),
                                  Text("${DateFormat('yy-MM-dd HH:mm').format(DateTime.parse(snap.data[i]['Date']))}",
                                    style: TextStyle(color: TColors.darkGray),),
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${snap.data[i]['Title']}", style: TextStyle(fontWeight: FontWeight.bold, color: TColors.black),),
                                          IconButton(onPressed: (){
                                            Navigator.of(context).pop();
                                          }, icon: Icon(Symbols.close_rounded, color: TColors.black,))
                                        ],
                                      ),
                                    ),
                                    content: Container(
                                      width: 500,
                                      height: 350,
                                      margin: EdgeInsets.only(left: 50, right: 50),
                                      child: Text(
                                        "${snap.data[i]['Content']}",
                                      ),
                                    )




                                  );
                                }
                            );
                          },
                        );
                      });
                }
              }
              return Center(child: Text("there is no advertisement"));
            },
          ),
        ),


        Padding(
          padding: const EdgeInsets.only(bottom: 40, right: 20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: MaterialButton(
              onPressed: () {
                showDialog(

                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 40, right: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Add new Advertisement",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: TColors.black),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Symbols.close_rounded,
                                    color: TColors.black,
                                  ))
                            ],
                          ),
                        ),
                        content: Container(
                          width: 885,
                          height: 800,
                          margin: EdgeInsets.only(left: 50, right: 50),
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: TitleValue,
                                  decoration: InputDecoration(
                                      hintText: "Advertisement Title",
                                      border: OutlineInputBorder()),
                                ),
                                SizedBox(height: 16,),
                                TextFormField(
                                  controller: ContentValue,
                                  decoration: InputDecoration(
                                      hintText: "Advertisement Content",
                                      border: OutlineInputBorder()),
                                  maxLines: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        actions: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: TColors.darkBlue),
                            ),
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: TColors.darkBlue, width: 1)),
                          ),

                          // Save Button
                          ElevatedButton(
                            onPressed: () {
                              TitleValue=TextEditingController();
                              ContentValue=TextEditingController();
                              postData();
                            },
                            child: Text("Publish", style: TextStyle(color: TColors.white),),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: TColors.darkBlue,
                                textStyle: TextStyle(color: TColors.lightGray)),
                          ),
                        ],
                        actionsPadding: EdgeInsets.only(right: 32, bottom: 32),
                      );
                    });
              },
              color: TColors.darkBlue,
              textColor: Colors.white,
              child: Icon(
                Symbols.add_rounded,
                size: 24,
              ),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
