import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_advertisements.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_levels.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_notifications.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_notes.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_subject.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_teachers.dart';
import 'package:timetable_admin/pages/dep_manager/dep_manager_timetable.dart';
import '../../main.dart';
import 'package:timetable_admin/Business%20Logic/components/info.dart';



class DepManagerMainPage extends StatefulWidget {
  final int pageIndex;
  final levelIndex;
  const DepManagerMainPage({super.key,this.pageIndex=0,this.levelIndex=0});

  @override
  State<DepManagerMainPage> createState() => _DepManagerMainPageState();
}

class _DepManagerMainPageState extends State<DepManagerMainPage> {
  showContent({int? i}) {
    switch (activeButtonIndex) {
      case 1:
        return SubjectsPage();
      case 2:
        return TeachersPage();
      case 3:
        return LevelsPage(tab: i);
      case 4:
        return AdvertisementsPage();
      case 5:
        return NotesPage();
      case 6:
        return NotificationsPage();
      default:
        return TimetablePage();
    }
  }
  var dmId = sharedPref.getString("dm_id");
  Info _info = Info();
  bool un_seen=false;
  Future getTB() async{
    var response = await _info.getRequest("${serverLink}/get_timetable/$dmId");

    await sharedPref.setBool("created_timetable",response['bool']);
    return [];

  }

  Future getNotify() async {
    var response = await _info.getRequest("${serverLink}/DM_notification/$dmId");
    if (response!='failed') {
      List resBody = response;
      for(var i in resBody){
        if(i['seen']==false){
          un_seen=true;
          break;
        }
      }
      return resBody;
    }
  }
  @override
  int? activeButtonIndex;
  void initState() {

    super.initState();
    activeButtonIndex = widget.pageIndex;
  }
  String activeButtonName = "Timetable";

  bool hasNotification = true;

  var dep_num = sharedPref.getInt("dm_counter")!;


  Widget build(BuildContext context) {
    print(sharedPref.getString("role"));
    List departments = [];
    Future.delayed(Duration(),(){getTB();});

    if(dep_num>1){
    for (int i = 0; i < dep_num; i++) {
      var id = sharedPref.getString('dm_id$i');
      var name = sharedPref.getString('dm_name$i');

      if(id != sharedPref.getString('dm_id') && name != sharedPref.getString('dm_name') ){
        departments.add({'id': id!, 'name': name!});
      }
    }}

    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // side
            Expanded(
              child: Container(
                color: TColors.darkBlue,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width:6 ,),
                        Image.asset("images/WebSchedule.png", width: 50, height: 50,),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "   Main pages",
                          style:
                              TextStyle(color: TColors.lightGray, fontSize: 14),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: activeButtonIndex == 0
                                ? TColors.lightGray
                                : TColors.darkBlue,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                activeButtonIndex = 0;
                                activeButtonName = "Timetable";
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Timetable",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            textColor: activeButtonIndex == 0
                                ? TColors.darkBlue
                                : TColors.lightGray,
                            elevation: 0,
                            height: 54,
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "   Data Management",
                          style:
                              TextStyle(color: TColors.lightGray, fontSize: 14),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: activeButtonIndex == 1
                                ? TColors.lightGray
                                : TColors.darkBlue,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                activeButtonIndex = 1;
                                activeButtonName = "Subjects";
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Subjects",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            textColor: activeButtonIndex == 1
                                ? TColors.darkBlue
                                : TColors.lightGray,
                            elevation: 0,
                            height: 54,
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: activeButtonIndex == 2
                                ? TColors.lightGray
                                : TColors.darkBlue,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                activeButtonIndex = 2;
                                activeButtonName = "Teachers";
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Teachers",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            textColor: activeButtonIndex == 2
                                ? TColors.darkBlue
                                : TColors.lightGray,
                            elevation: 0,
                            height: 54,
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: activeButtonIndex == 3
                                ? TColors.lightGray
                                : TColors.darkBlue,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                activeButtonIndex = 3;
                                activeButtonName = "Levels";
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Levels",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            textColor: activeButtonIndex == 3
                                ? TColors.darkBlue
                                : TColors.lightGray,
                            elevation: 0,
                            height: 54,
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "   others",
                          style:
                              TextStyle(color: TColors.lightGray, fontSize: 14),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: activeButtonIndex == 4
                                ? TColors.lightGray
                                : TColors.darkBlue,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                activeButtonIndex = 4;
                                activeButtonName = "Advertisements";
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Advertisements",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            textColor: activeButtonIndex == 4
                                ? TColors.darkBlue
                                : TColors.lightGray,
                            elevation: 0,
                            height: 54,
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8)),
                            color: activeButtonIndex == 5
                                ? TColors.lightGray
                                : TColors.darkBlue,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                activeButtonIndex = 5;
                                activeButtonName = "Notes";
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Notes",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18),
                              ),
                            ),
                            textColor: activeButtonIndex == 5
                                ? TColors.darkBlue
                                : TColors.lightGray,
                            elevation: 0,
                            height: 54,
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
                flex: 5,
                child: Container(
                  color: TColors.lightGray,
                  child: Column(
                    children: [
                      // APP BAR
                      Container(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$activeButtonName", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                            Row(
                              children: [
                                Container(
                                  child: Stack(
                                      children:[
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              hasNotification=false;
                                              activeButtonIndex = 6;
                                              activeButtonName = "Notifications";
                                            });
                                          },
                                          child:Icon(Symbols.notifications_active_rounded, size: 25,),
                                          shape: CircleBorder(),
                                          color: TColors.lightGray,
                                        ),
                                        if(hasNotification)
                                          Positioned(
                                            left: 42,
                                            top: 2,
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: TColors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                      ]
                                  ),
                                ),
                                SizedBox(width: 2,),
                                Text("${sharedPref.getString("dm_teacher")}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                                PopupMenuButton(
                                    itemBuilder: (context) => [

                                      for (int i = 0; i <= departments.length; i++)
                                        i == (departments.length )?
                                        PopupMenuItem(
                                          child: Row(children: [
                                            Icon(Symbols.logout_rounded, color: TColors.red,),
                                            Text(" Logout", style: TextStyle(color: TColors.red),)
                                          ]),
                                          onTap: () {
                                            sharedPref.clear();
                                            Navigator.of(context).pushNamed("loginPage");
                                          },
                                        ):
                                        PopupMenuItem(
                                          value: departments[i]['id'],
                                          child: Row(children: [
                                            Icon(Symbols.logout_rounded, color: TColors.black,),
                                            Text("${departments[i]['name']}",
                                              style: TextStyle(color: TColors.black),)
                                          ]),
                                          onTap: () async{
                                            await sharedPref.setString('dm_id',departments[i]['id']);
                                            await sharedPref.setString('dm_name',departments[i]['name']);
                                            dmId=await sharedPref.getString('dm_id');
                                            await getTB();
                                            Navigator.of(context).pushReplacementNamed("depManagerMainPage");



                                            setState(() {

                                            });
                                            Navigator.of(context).pushNamed("");
                                          },
                                        ),
                                    ],
                                    icon: Icon(
                                      Symbols.expand_more_rounded,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),


                      // CONTENT
                      Expanded(child: showContent(i:widget.levelIndex),),


                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

