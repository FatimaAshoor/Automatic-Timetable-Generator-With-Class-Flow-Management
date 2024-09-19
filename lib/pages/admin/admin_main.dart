import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:timetable_admin/constant/t_colors.dart';
import 'package:timetable_admin/main.dart';
import 'package:timetable_admin/pages/admin/admin_classrooms_page.dart';
import 'package:timetable_admin/pages/admin/admin_departments_page.dart';
import 'package:timetable_admin/pages/admin/admin_students_page.dart';
import 'package:timetable_admin/pages/admin/admin_teachers_page.dart';

class AdminMainPage extends StatefulWidget {
  final int pageIndex;
  const AdminMainPage({super.key,this.pageIndex=0});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}
class _AdminMainPageState extends State<AdminMainPage> {
  showContent() {
    switch (activeButtonIndex) {
      case 1:
        return ClassroomsPage();
      case 2:
        return TeachersPage();
      case 3:
        return StudentsPage();
      default:
        return DepartmentsPage();
    }
  }

  @override
  int? activeButtonIndex;
  void initState() {
    super.initState();
    activeButtonIndex = widget.pageIndex;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.darkBlue,
        leading: Row(
          children: [
            SizedBox(width: 6,),
            Image.asset("images/WebSchedule.png", width: 46, height: 46,),
            Text("", style: TextStyle(color: TColors.darkGray),),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  activeButtonIndex = 0;
                });
              },
              label: Text(
                "Departments",
                style: TextStyle(
                  color: activeButtonIndex == 0
                      ? TColors.darkBlue
                      : TColors.lightGray,
                ),
              ),
              icon: Icon(
                Symbols.apartment_rounded,
                color: activeButtonIndex == 0
                    ? TColors.darkBlue
                    : TColors.lightGray,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeButtonIndex == 0
                    ? TColors.lightGray
                    : TColors.darkBlue,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  activeButtonIndex = 1;
                });
              },
              label: Text(
                "Classrooms",
                style: TextStyle(
                  color: activeButtonIndex == 1
                      ? TColors.darkBlue
                      : TColors.lightGray,
                ),
              ),
              icon: Icon(
                Symbols.meeting_room_rounded,
                color: activeButtonIndex == 1
                    ? TColors.darkBlue
                    : TColors.lightGray,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeButtonIndex == 1
                    ? TColors.lightGray
                    : TColors.darkBlue,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  activeButtonIndex = 2;
                });
              },
              label: Text("Teachers",
                  style: TextStyle(
                    color: activeButtonIndex == 2
                        ? TColors.darkBlue
                        : TColors.lightGray,
                  )),
              icon: Icon(
                Symbols.group_rounded,
                color: activeButtonIndex == 2
                    ? TColors.darkBlue
                    : TColors.lightGray,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeButtonIndex == 2
                    ? TColors.lightGray
                    : TColors.darkBlue,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  activeButtonIndex = 3;
                });
              },
              label: Text("Students",
                  style: TextStyle(
                    color: activeButtonIndex == 3
                        ? TColors.darkBlue
                        : TColors.lightGray,
                  )),
              icon: Icon(
                Symbols.for_you_rounded,
                color: activeButtonIndex == 3
                    ? TColors.darkBlue
                    : TColors.lightGray,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeButtonIndex == 3
                    ? TColors.lightGray
                    : TColors.darkBlue,
              ),
            ),
          ],
        ),
        actions: [
          Row(children: [
            IconButton(icon: Icon(Symbols.logout_rounded), color: TColors.white,onPressed:(){
              sharedPref.clear();
              Navigator.of(context).pushNamed("loginPage");
            } ,),
            Text("Logout", style: TextStyle(color: TColors.white),),
            SizedBox(width: 6,)
          ]),
        ],
      ),
      body: showContent(),
    );
  }
}
