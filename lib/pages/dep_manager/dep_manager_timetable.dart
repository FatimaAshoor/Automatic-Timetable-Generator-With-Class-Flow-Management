import 'package:flutter/material.dart';
import 'package:timetable_admin/main.dart';
import 'package:timetable_admin/pages/dep_manager/Timetable/create_timetable.dart';
import 'package:timetable_admin/pages/dep_manager/Timetable/show_timetable.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});
  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {



  bool showTimetable = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        //color: TColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child:  sharedPref.getBool("created_timetable") == true? ShowTimetable(onDelete: () {
        setState(() {
          showTimetable = false;
          Navigator.of(context).pop();
        });
      }) : CreateTimetable(onCreate: () {
        setState(() {
          showTimetable = true;
        });
      })
    );
  }






}
