import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;
import 'package:timetable_admin/pages/dep_manager/Notes/students_notes.dart';
import 'package:timetable_admin/pages/dep_manager/Notes/teacher_notes.dart';
import 'dart:convert';
import '../../constant/t_colors.dart';
import 'package:intl/intl.dart';

import 'package:timetable_admin/Business Logic/components/info.dart';

import '../../main.dart';


class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TickerProviderStateMixin {


  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController TitleValue = TextEditingController();
  TextEditingController ContentValue = TextEditingController();
  int? id;

  String advTitle = "Introductory seminar";
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
    TabController _tabController = TabController(length: 3, vsync: this);

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 8),
          padding: EdgeInsets.only(top: 8, left: 30, right: 30, bottom: 10),
          decoration: BoxDecoration(
            color: TColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: TColors.darkBlue,
                    indicatorWeight: 4,
                    indicatorPadding: EdgeInsets.only(bottom: 8),
                    labelColor: TColors.darkBlue,
                    unselectedLabelColor: TColors.darkBlue,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: "Teachers Notes",),
                      Tab(text: "Students Notes",),
                    ]),
              ),
              Container(
                  width: double.maxFinite,
                  height: 440,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TeacherNotes(),
                      StudentsNotes(),
                    ],
                  )
              ),
            ],
          ),
        ),],
    );
  }
}
